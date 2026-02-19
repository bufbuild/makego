# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_buf.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)
$(call _assert_var,BUF_VERSION)

# Settable
# https://github.com/bufbuild/buf/releases
BANDEPS_VERSION ?= $(BUF_VERSION)

$(CACHE_VERSIONS)/bandeps/bandeps-$(BANDEPS_VERSION):
	@rm -f $(CACHE_BIN)/bandeps
	@rm -rf $(dir $@)
	@mkdir -p $(dir $@)
	GOBIN=$(dir $@) go install github.com/bufbuild/buf/private/pkg/bandeps/cmd/bandeps@$(BANDEPS_VERSION)
	@mv $(dir $@)/bandeps $@
	@test -x $@

$(CACHE_BIN)/bandeps: $(CACHE_VERSIONS)/bandeps/bandeps-$(BANDEPS_VERSION)
	@mkdir -p $(dir $@)
	@ln -sf $< $@

BANDEPS := $(CACHE_BIN)/bandeps

dockerdeps:: $(BANDEPS)
