GO_BINS := $(GO_BINS) cmd/foo
# Uncomment below to set GOPROXY
# GOPROXY := https://goproxy.io,direct
DOCKER_BINS := $(DOCKER_BINS) foo
PROTO_PATH := proto
PROTOC_GEN_GO_OUT := internal/gen/proto/go

include make/go/bootstrap.mk
include make/go/go.mk
include make/go/codecov.mk
include make/go/docker.mk
include make/go/protoc_gen_go.mk
