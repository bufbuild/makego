GO_BINS := $(GO_BINS) cmd/foo
DOCKER_BINS := $(DOCKER_BINS) foo

include make/go/bootstrap.mk
include make/go/go.mk
include make/go/docker.mk
include make/go/dep_buf.mk
include make/go/dep_protoc_gen_go.mk

.PHONY: bufgeneratedeps
bufgeneratedeps:: $(BUF) $(PROTOC_GEN_GO)

.PHONY: bufgenerateclean
bufgenerateclean::

.PHONY: bufgeneratecleango
bufgeneratecleango:
	rm -rf internal/gen/proto

bufgenerateclean:: bufgeneratecleango

.PHONY: bufgeneratesteps
bufgeneratesteps::

.PHONY: bufgenerateproto
bufgenerateproto:
	buf generate proto

bufgeneratesteps:: bufgenerateproto

.PHONY: bufgenerate
bufgenerate:
	$(MAKE) bufgeneratedeps
	$(MAKE) bufgenerateclean
	$(MAKE) bufgeneratesteps

pregenerate:: bufgenerate
