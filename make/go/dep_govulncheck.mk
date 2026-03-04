# Managed by makego. DO NOT EDIT.
#
# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)

# We want to ensure we rebuild govulncheck every time we require a new Go minor version.
# Otherwise, the cached version may not support the latest language features.
# This version is the go toolchain version not the module version to ensure
# the build handles specific language features in newer toolchains.
GOVULNCHECK_GO_VERSION := $(shell go env GOVERSION | sed 's/^go//' | cut -d'.' -f1-2)

# Settable
# https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck 20250106 checked 20250212
GOVULNCHECK_VERSION ?= v1.1.4

GOVULNCHECK := $(CACHE_BIN)/govulncheck

$(CACHE_VERSIONS)/govulncheck/govulncheck-$(GOVULNCHECK_VERSION)-go$(GOVULNCHECK_GO_VERSION):
	@rm -f $(GOVULNCHECK)
	@rm -rf $(dir $@)
	@mkdir -p $(dir $@)
	GOBIN=$(dir $@) go install golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)
	@mv $(dir $@)/govulncheck $@
	@test -x $@
	@touch $@

$(GOVULNCHECK): $(CACHE_VERSIONS)/govulncheck/govulncheck-$(GOVULNCHECK_VERSION)-go$(GOVULNCHECK_GO_VERSION)
	@mkdir -p $(dir $@)
	@ln -sf $< $@

dockerdeps:: $(GOVULNCHECK)
