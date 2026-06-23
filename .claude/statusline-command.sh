#!/bin/sh
# Claude Code statusLine command
# Mirrors the zsh prompt: green user [git branch] cwd | model | context

input=$(cat)

# -- cwd (from Claude's data, more reliable than pwd in this context)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
[ -z "$cwd" ] && cwd=$(pwd)

# -- user
user=$(whoami)

# -- AWS account number (last 4 digits) — mirrors the zsh prompt.
# `aws sts` is slow (~3-4s behind the corporate proxy), so we never call it
# inline. The cached value is printed immediately; when the cache is missing or
# older than 1h, a *detached background* job refreshes it (appears on the next
# render). The account is stable per profile, so slight staleness / a one-render
# delay is fine. A .attempt marker throttles refreshes to once per 60s so bad
# credentials can't spawn a pile-up of background calls.
aws_acct=""
if [ -n "$AWS_ACCESS_KEY_ID" ] || [ -n "$AWS_PROFILE" ]; then
  cache_dir="$HOME/.claude/cache"
  cache_id=$(printf '%s' "${AWS_PROFILE:-default}" | md5sum 2>/dev/null | cut -d' ' -f1)
  cache_file="$cache_dir/aws-acct-$cache_id"
  [ -f "$cache_file" ] && aws_acct=$(cat "$cache_file" 2>/dev/null)

  now=$(date +%s)
  age=99999; [ -f "$cache_file" ] && age=$(( now - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0) ))
  last=0; [ -f "$cache_file.attempt" ] && last=$(stat -c %Y "$cache_file.attempt" 2>/dev/null || echo 0)
  if { [ -z "$aws_acct" ] || [ "$age" -ge 3600 ]; } && [ "$(( now - last ))" -ge 60 ]; then
    mkdir -p "$cache_dir" 2>/dev/null
    touch "$cache_file.attempt" 2>/dev/null
    (
      acct=$(aws sts get-caller-identity --output json 2>/dev/null | jq -r '.Account // empty' 2>/dev/null)
      last4=$(printf '%s' "$acct" | rev | cut -c 1-4 | rev)
      [ -n "$last4" ] && printf '%s' "$last4" > "$cache_file" 2>/dev/null
    ) >/dev/null 2>&1 &
  fi
fi

# -- git branch with status color (skip locks to stay non-blocking)
branch=""
git_color=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  st=$(git -C "$cwd" -c core.hooksPath=/dev/null status --no-lock-index 2>/dev/null)
  if echo "$st" | grep -q "^nothing to commit"; then
    git_color="\033[32m"   # green  - clean
  elif echo "$st" | grep -q "^Untracked files"; then
    git_color="\033[31m"   # red?   - untracked
  elif echo "$st" | grep -q "^Changes not staged for commit"; then
    git_color="\033[31m"   # red+   - unstaged
  elif echo "$st" | grep -q "^Changes to be committed"; then
    git_color="\033[33m"   # yellow - staged
  else
    git_color="\033[34m"   # blue   - other
  fi
fi

# -- model
model=$(echo "$input" | jq -r '.model.display_name // empty')

# -- context remaining
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# -- assemble output
# Line 1: user [aws-account] [git-branch] cwd
printf "\033[32m%s\033[0m" "$user"
if [ -n "$aws_acct" ]; then
  printf " \033[32m[%s]\033[0m" "$aws_acct"
fi
if [ -n "$branch" ]; then
  printf " [%b%s\033[0m]" "$git_color" "$branch"
fi
printf " %s" "$cwd"

# Separator
printf "  |"

# model (dimmed)
if [ -n "$model" ]; then
  printf "  \033[2m%s\033[0m" "$model"
fi

# context remaining
if [ -n "$remaining" ]; then
  printf "  \033[2mctx:%s%%\033[0m" "$(printf '%.0f' "$remaining")"
fi

printf "\n"
