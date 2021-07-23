package main

import (
	"fmt"
	"os"

	"github.com/bufbuild/makego/internal/foo"
)

func main() {
	_, _ = fmt.Fprintln(os.Stdout, foo.Bar())
}
