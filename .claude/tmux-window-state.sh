#!/bin/sh
# Prefix the active tmux window name with a Claude-state symbol.
#   *  busy   (processing)
#   !  perm   (waiting for permission)
#   ?  idle   (waiting for user input)
# Usage: tmux-window-state.sh <busy|perm|idle|clear|notify>
# Called from Claude Code hooks; the hook JSON arrives on stdin.
# Assumes tmux automatic-rename is off (otherwise tmux overwrites the symbol).
#
# Note: a user-rejected permission prompt emits no hook event, so after a
# reject the window stays at "!" until the next prompt (-> *) or 60s idle
# (idle_prompt -> ?). That gap is a Claude Code limitation, not a bug here.

state="$1"

# Notification covers both permission and idle: derive which from notification_type.
if [ "$state" = "notify" ]; then
  case "$(jq -r '.notification_type // empty' 2>/dev/null)" in
    permission_prompt) state="perm" ;;
    idle_prompt)       state="idle" ;;
    *)                 exit 0 ;;
  esac
else
  cat >/dev/null 2>&1   # drain stdin so the hook pipe closes cleanly
fi

# Only act when running inside the tmux pane that launched Claude.
[ -z "$TMUX" ] && exit 0
[ -z "$TMUX_PANE" ] && exit 0

# Current window name with any existing state symbol stripped (idempotent).
current=$(tmux display-message -p -t "$TMUX_PANE" '#W' 2>/dev/null) || exit 0
base=$(printf '%s' "$current" | sed -E 's/^[*!?] //')

case "$state" in
  busy)  name="* $base"; flag="busy" ;;
  perm)  name="! $base"; flag="perm" ;;
  idle)  name="? $base"; flag="idle" ;;
  clear) name="$base";   flag="" ;;     # session ended: drop symbol + colour
  *)     exit 0 ;;
esac

# @claude_state drives the window-name colour via window-status-format in tmux.conf.
tmux set-option -w -t "$TMUX_PANE" @claude_state "$flag" 2>/dev/null
tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
exit 0
