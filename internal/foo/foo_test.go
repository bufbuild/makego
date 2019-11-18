package foo

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBar(t *testing.T) {
	assert.Equal(t, "bar", Bar())
}
