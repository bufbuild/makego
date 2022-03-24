GO_BINS := $(GO_BINS) cmd/foo
DOCKER_BINS := $(DOCKER_BINS) foo

LICENSE_HEADER_LICENSE_TYPE := apache
LICENSE_HEADER_COPYRIGHT_HOLDER := Buf Technologies, Inc.
LICENSE_HEADER_YEAR_RANGE := 2020-2022
LICENSE_HEADER_IGNORES := \/testdata

BUF_LINT_INPUT := .
BUF_FORMAT_INPUT := .

include make/go/bootstrap.mk
include make/go/go.mk
include make/go/docker.mk
include make/go/buf.mk
include make/go/license_header.mk
include make/go/dep_protoc_gen_go.mk

bufgeneratedeps:: $(BUF) $(PROTOC_GEN_GO)

.PHONY: bufgeneratecleango
bufgeneratecleango:
	rm -rf internal/gen/proto

bufgenerateclean:: bufgeneratecleango

.PHONY: bufgeneratego
bufgeneratego:
	buf generate

bufgeneratesteps:: bufgeneratego
