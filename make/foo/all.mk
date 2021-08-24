GO_BINS := $(GO_BINS) cmd/foo
DOCKER_BINS := $(DOCKER_BINS) foo

include make/go/bootstrap.mk
include make/go/go.mk
include make/go/docker.mk
include make/go/buf.mk
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
