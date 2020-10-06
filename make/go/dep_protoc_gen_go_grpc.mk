# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)

# Settable
# https://github.com/grpc/grpc-go/releases/tag/cmd%2Fprotoc-gen-go-grpc%2Fv1.0.0 20201002 checked 20201005
PROTOC_GEN_GO_GRPC_VERSION ?= b2c5f4a808fd5de543c4e987cd85d356140ed681

GO_GET_PKGS := $(GO_GET_PKGS) google.golang.org/grpc@$(PROTOC_GEN_GO_GRPC_VERSION)

PROTOC_GEN_GO_GRPC := $(CACHE_VERSIONS)/protoc-gen-go-grpc/$(PROTOC_GEN_GO_GRPC_VERSION)
$(PROTOC_GEN_GO_GRPC):
	@rm -f $(CACHE_BIN)/protoc-gen-go-grpc
	$(eval PROTOC_GEN_GO_GRPC_TMP := $(shell mktemp -d))
	cd $(PROTOC_GEN_GO_GRPC_TMP); GOBIN=$(CACHE_BIN) go get \
		google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)
	@rm -rf $(PROTOC_GEN_GO_GRPC_TMP)
	@rm -rf $(dir $(PROTOC_GEN_GO_GRPC))
	@mkdir -p $(dir $(PROTOC_GEN_GO_GRPC))
	@touch $(PROTOC_GEN_GO_GRPC)

dockerdeps:: $(PROTOC_GEN_GO_GRPC)
