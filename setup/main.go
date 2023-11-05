package main

import (
	"log"
	"os"
	"path/filepath"

	"github.com/RedSkiesReaperr/Budgetizer/setup/filesystem"
)

func main() {
	err := filesystem.Check()
	if err != nil {
		log.Fatalf("Invalid filesystem: %s\n", err)
	}
	log.Println("Filesystem is valid")

	err = filesystem.Rename(filepath.Join(".git", "hooks", "pre-commit.sample"), filepath.Join(".git", "hooks", "pre-commit"))
	if err != nil {
		log.Fatalf("Cannot rename: %s\n", err)
	}

	copied, err := os.ReadFile(filepath.Join("git-hooks", "pre-commit.sh"))
	if err != nil {
		log.Fatalf("Cannot read pre-commit: %s\n", err)
	}

	err = os.WriteFile(filepath.Join(".git", "hooks", "pre-commit"), copied, os.FileMode(0777))
	if err != nil {
		log.Fatalf("Cannot copy pre-commit: %s\n", err)
	}

	err = os.Chmod(filepath.Join(".git", "hooks", "pre-commit"), os.FileMode(0755))
	if err != nil {
		log.Fatalf("Cannot grant pre-commit: %s\n", err)
	}

	log.Println("Git hooks installed")
}
