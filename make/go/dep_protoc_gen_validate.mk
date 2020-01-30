# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_INCLUDE)
$(call _assert_var,GOBIN)

# Settable
# https://github.com/envoyproxy/protoc-gen-validate/commits/master 20200123
PROTOC_GEN_VALIDATE_VERSION ?= f185a54fed22823c74d623a5fc6a58d78ba8795f

GO_GET_PKGS := $(GO_GET_PKGS) github.com/envoyproxy/protoc-gen-validate@$(PROTOC_GEN_VALIDATE_VERSION)

PROTOC_GEN_VALIDATE := $(CACHE_VERSIONS)/protoc-gen-validate/$(PROTOC_GEN_VALIDATE_VERSION)
$(PROTOC_GEN_VALIDATE):
	@rm -f $(GOBIN)/protoc-gen-validate
	@rm -rf third_party/proto/validate
	@mkdir -p third_party/proto/validate
	$(eval PROTOC_GEN_VALIDATE_TMP := $(shell mktemp -d))
	cd $(PROTOC_GEN_VALIDATE_TMP); go get github.com/envoyproxy/protoc-gen-validate@$(PROTOC_GEN_VALIDATE_VERSION)
	curl -sSL \
		https://raw.githubusercontent.com/envoyproxy/protoc-gen-validate/$(PROTOC_GEN_VALIDATE_VERSION)/validate/validate.proto \
		-o third_party/proto/validate/validate.proto
	@rm -rf $(PROTOC_GEN_VALIDATE_TMP)
	@rm -rf $(dir $(PROTOC_GEN_VALIDATE))
	@mkdir -p $(dir $(PROTOC_GEN_VALIDATE))
	@touch $(PROTOC_GEN_VALIDATE)

dockerdeps:: $(PROTOC_GEN_VALIDATE)
