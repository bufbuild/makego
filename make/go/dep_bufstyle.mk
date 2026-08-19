# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_buf.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)
$(call _assert_var,BUF_VERSION)

# We want to ensure we rebuild bufstyle every time we require a new Go minor version.
# Otherwise, the cached version may not support the latest language features.
BUFSTYLE_GO_VERSION := $(call _major_minor,$(shell go list -m -f '{{.GoVersion}}'))

# Settable
#
# Based off of main branch, pending a release including golang.org/x/tools v0.49.0.
# https://github.com/bufbuild/bufstyle-go/commits/main
BUFSTYLE_VERSION ?= ce18c4427ccee4b402ecf98dd7996b3e3b98a320

BUFSTYLE := $(CACHE_BIN)/bufstyle

$(CACHE_VERSIONS)/bufstyle/bufstyle-$(BUFSTYLE_VERSION)-go$(BUFSTYLE_GO_VERSION):
	@rm -f $(BUFSTYLE)
	@rm -rf $(dir $@)
	@mkdir -p $(dir $@)
	GOBIN=$(dir $@) go install buf.build/go/bufstyle@$(BUFSTYLE_VERSION)
	@mv $(dir $@)/bufstyle $@
	@test -x $@
	@touch $@

$(BUFSTYLE): $(CACHE_VERSIONS)/bufstyle/bufstyle-$(BUFSTYLE_VERSION)-go$(BUFSTYLE_GO_VERSION)
	@mkdir -p $(dir $@)
	@ln -sf $< $@

dockerdeps:: $(BUFSTYLE)
