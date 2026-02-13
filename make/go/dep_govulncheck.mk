# Managed by makego. DO NOT EDIT.
#
# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _assert_var,CACHE_VERSIONS)
$(call _assert_var,CACHE_BIN)

# We want to ensure we rebuild govulncheck every time we require a new Go minor version.
# Otherwise, the cached version may not support the latest language features.
GOVULNCHECK_GO_VERSION := $(shell go list -m -f '{{.GoVersion}}' | cut -d'.' -f1-2)

# Settable
# https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck 20250106 checked 20250212
GOVULNCHECK_VERSION ?= v1.1.4

$(CACHE_VERSIONS)/govulncheck/govulncheck-$(GOVULNCHECK_VERSION)-go$(GOVULNCHECK_GO_VERSION):
	@rm -f $(CACHE_BIN)/govulncheck
	@rm -rf $(dir $@)
	@mkdir -p $(dir $@)
	GOBIN=$(dir $@) go install golang.org/x/vuln/cmd/govulncheck@$(GOVULNCHECK_VERSION)
	@mv $(dir $@)/govulncheck $@
	@test -x $@

$(CACHE_BIN)/govulncheck: $(CACHE_VERSIONS)/govulncheck/govulncheck-$(GOVULNCHECK_VERSION)-go$(GOVULNCHECK_GO_VERSION)
	@mkdir -p $(dir $@)
	@ln -sf $< $@

GOVULNCHECK := $(CACHE_BIN)/govulncheck

dockerdeps:: $(GOVULNCHECK)
