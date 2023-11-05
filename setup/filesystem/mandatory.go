package filesystem

import (
	"fmt"
	"os"
)

func Check() error {
	for _, folderName := range MandatoryFolders() {
		fileInfo, err := os.Stat(folderName)
		if err != nil {
			return fmt.Errorf("%s\n", err)
		}

		if !fileInfo.IsDir() {
			return fmt.Errorf("%s: not a folder\n", folderName)
		}
	}

	for _, fileName := range MandatoryFiles() {
		_, err := os.Stat(fileName)
		if err != nil {
			return fmt.Errorf("%s\n", err)
		}
	}

	return nil
}

func MandatoryFiles() []string {
	return []string{
		"git-hooks/pre-commit.sh",
		"git-hooks/run-brakeman.sh",
		"git-hooks/run-rubocop.sh",
		"git-hooks/run-specs.sh",
	}
}

func MandatoryFolders() []string {
	return []string{
		".git",
		"git-hooks",
	}
}
