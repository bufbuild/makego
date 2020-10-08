# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_buf.mk)
$(call _conditional_include,$(MAKEGO)/dep_protoc_gen_twirp.mk)
$(call _conditional_include,$(MAKEGO)/protoc_gen_go.mk)
# Must be set
$(call _assert_var,PROTOC_GEN_TWIRP_OUT)
$(call _assert_var,CACHE_BIN)
$(call _assert_var,BUF)
$(call _assert_var,PROTOC_GEN_TWIRP)

# Not modifiable for now
PROTOC_GEN_TWIRP_OPT := paths=source_relative

.PHONY: protocgentwirp
protocgentwirp: protocgengoclean $(BUF) $(PROTOC_GEN_TWIRP)
	$(CACHE_BIN)/buf beta generate \
		--plugin twirp \
		--plugin-out $(PROTOC_GEN_TWIRP_OUT) \
		--plugin-opt $(PROTOC_GEN_TWIRP_OPT)

bufgenerate:: protocgentwirp
