# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_buf.mk)
$(call _conditional_include,$(MAKEGO)/dep_protoc.mk)
$(call _conditional_include,$(MAKEGO)/dep_protoc_gen_twirp.mk)
$(call _conditional_include,$(MAKEGO)/protoc_gen_go.mk)
# Must be set
$(call _assert_var,PROTO_PATH)
# Must be set
$(call _assert_var,PROTOC_GEN_TWIRP_OUT)
$(call _assert_var,CACHE_INCLUDE)
$(call _assert_var,PROTOC)
$(call _assert_var,PROTOC_GEN_TWIRP)

# Not modifiable for now
PROTOC_GEN_TWIRP_OPT := paths=source_relative

EXTRA_MAKEGO_FILES := $(EXTRA_MAKEGO_FILES) scripts/protoc_gen_plugin.bash

PROTOC_GEN_TWIRP_EXTRA_FLAGS :=
ifdef USE_BUF_PROTOC
PROTOC_GEN_TWIRP_EXTRA_FLAGS := --use-buf-protoc
endif
ifdef USE_BUF_PROTOC_BY_DIR
PROTOC_GEN_TWIRP_EXTRA_FLAGS := --use-buf-protoc-by-dir
endif
ifdef USE_BUF_GENERATE
PROTOC_GEN_TWIRP_EXTRA_FLAGS := --use-buf-generate
endif

.PHONY: protocgentwirp
protocgentwirp: protocgengoclean $(PROTOC) $(BUF) $(PROTOC_GEN_TWIRP)
	bash $(MAKEGO)/scripts/protoc_gen_plugin.bash $(PROTOC_GEN_TWIRP_EXTRA_FLAGS) \
		"--buf_path=$(CACHE_BIN)/buf" \
		"--proto_path=$(PROTO_PATH)" \
		"--proto_include_path=$(CACHE_INCLUDE)" \
		$(patsubst %,--proto_include_path=%,$(PROTO_INCLUDE_PATHS)) \
		"--plugin_name=twirp" \
		"--plugin_out=$(PROTOC_GEN_TWIRP_OUT)" \
		"--plugin_opt=$(PROTOC_GEN_TWIRP_OPT)"

protocgenerate:: protocgentwirp
