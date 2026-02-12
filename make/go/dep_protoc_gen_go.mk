# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)

# Settable
# https://github.com/protocolbuffers/protobuf-go/releases 20251212 checked 20251219
PROTOC_GEN_GO_VERSION ?= v1.36.11

GO_GET_PKGS := $(GO_GET_PKGS) \
	google.golang.org/protobuf/proto@$(PROTOC_GEN_GO_VERSION)

PROTOC_GEN_GO := $(CACHE_VERSIONS)/protoc-gen-go/protoc-gen-go-$(PROTOC_GEN_GO_VERSION)
$(PROTOC_GEN_GO):
	@rm -f $(CACHE_BIN)/protoc-gen-go
	@rm -rf $(dir $@)
	@mkdir -p $(dir $@)
	GOBIN=$(dir $@) go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	@mv $(dir $@)/protoc-gen-go $@
	@test -x $@

$(CACHE_BIN)/protoc-gen-go: $(PROTOC_GEN_GO)
	@mkdir -p $(dir $@)
	ln -sf $< $@

dockerdeps:: $(CACHE_BIN)/protoc-gen-go
