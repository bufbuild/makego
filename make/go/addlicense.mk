# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_addlicense.mk)
# Must be set
$(call _assert_var,COPYRIGHT_OWNER)
# Must be set
$(call _assert_var,COPYRIGHT_YEAR)
# Must be set
$(call _assert_var,LICENSE_TYPE)
$(call _assert_var,ADDLICENSE)

.PHONY: addlicense
addlicense: $(ADDLICENSE)
	addlicense -c "$(COPYRIGHT_OWNER)" -l "$(LICENSE_TYPE)" -y "$(COPYRIGHT_YEAR)"

pregenerate:: addlicense
