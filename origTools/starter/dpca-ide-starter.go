package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

var (
	TargetAccountID string
	InstanceID      string
	Profile         string
)

type CallerIdentity struct {
	Account string `json:"Account"`
}

type Instance struct {
	State struct {
		Name string `json:"Name"`
	} `json:"State"`
}

type DescribeInstancesOutput struct {
	Reservations []struct {
		Instances []Instance `json:"Instances"`
	} `json:"Reservations"`
}

func runPowerShell(command string) (string, error) {
	cmd := exec.Command("powershell.exe", "-Command", command)
	output, err := cmd.Output()
	return strings.TrimSpace(string(output)), err
}

func getCallerIdentity() (*CallerIdentity, error) {
	output, err := runPowerShell(fmt.Sprintf("aws sts get-caller-identity --output json --profile %s", Profile))
	if err != nil {
		return nil, err
	}

	var identity CallerIdentity
	err = json.Unmarshal([]byte(output), &identity)
	return &identity, err
}

func ssoLogin() error {
	_, err := runPowerShell(fmt.Sprintf("aws sso login --profile %s", Profile))
	return err
}

func getInstanceState() (string, error) {
	cmd := fmt.Sprintf("aws ec2 describe-instances --instance-ids %s --profile %s --output json", InstanceID, Profile)
	output, err := runPowerShell(cmd)
	if err != nil {
		return "", err
	}

	var result DescribeInstancesOutput
	err = json.Unmarshal([]byte(output), &result)
	if err != nil {
		return "", err
	}

	if len(result.Reservations) > 0 && len(result.Reservations[0].Instances) > 0 {
		return result.Reservations[0].Instances[0].State.Name, nil
	}
	return "", fmt.Errorf("インスタンスが見つかりません")
}

func startInstance() error {
	cmd := fmt.Sprintf("aws ec2 start-instances --instance-ids %s --profile %s", InstanceID, Profile)
	_, err := runPowerShell(cmd)
	return err
}

func waitForRunning() error {
	fmt.Println("インスタンスの起動を待機中...")
	for {
		state, err := getInstanceState()
		if err != nil {
			return err
		}

		fmt.Printf("現在の状態: %s\n", state)
		if state == "running" {
			fmt.Println("インスタンスが起動しました")
			return nil
		}

		time.Sleep(10 * time.Second)
	}
}

func main() {
	flag.StringVar(&TargetAccountID, "account", "", "Target AWS Account ID (required)")
	flag.StringVar(&InstanceID, "instance", "", "EC2 Instance ID (required)")
	flag.StringVar(&Profile, "profile", "", "AWS Profile (required)")
	flag.Parse()

	if TargetAccountID == "" || InstanceID == "" || Profile == "" {
		flag.Usage()
		os.Exit(1)
	}

	// アカウント確認
	identity, err := getCallerIdentity()
	if err != nil || identity.Account != TargetAccountID {
		fmt.Println("SSOログインが必要です...")
		if err := ssoLogin(); err != nil {
			fmt.Printf("SSOログインに失敗しました: %v\n", err)
			return
		}
		fmt.Println("SSOログイン完了")
	}

	// インスタンス状態確認
	state, err := getInstanceState()
	if err != nil {
		fmt.Printf("インスタンス状態の取得に失敗しました: %v\n", err)
		return
	}

	fmt.Printf("インスタンス状態: %s\n", state)

	// 起動判断
	if state == "stopped" {
		fmt.Println("インスタンスを起動します...")
		if err := startInstance(); err != nil {
			fmt.Printf("インスタンスの起動に失敗しました: %v\n", err)
			return
		}

		if err := waitForRunning(); err != nil {
			fmt.Printf("起動待機中にエラーが発生しました: %v\n", err)
			return
		}
	} else if state == "running" {
		fmt.Println("インスタンスは既に起動しています")
		fmt.Println("Ready For Connect DPCA-IDE")
	} else {
		fmt.Printf("インスタンスは現在 %s 状態です\n", state)
	}
}