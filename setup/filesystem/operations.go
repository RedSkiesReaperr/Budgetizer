package filesystem

import (
	"os"
)

func Rename(old, new string) error {
	_, err := os.Stat(old)
	if err != nil {
		return err
	}

	err = os.Rename(old, new)
	if err != nil {
		return err
	}

	return nil
}
