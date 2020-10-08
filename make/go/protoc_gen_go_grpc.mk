# Managed by makego. DO NOT EDIT.

# Must be set
$(call _assert_var,MAKEGO)
$(call _conditional_include,$(MAKEGO)/base.mk)
$(call _conditional_include,$(MAKEGO)/dep_buf.mk)
$(call _conditional_include,$(MAKEGO)/dep_protoc_gen_go_grpc.mk)
$(call _conditional_include,$(MAKEGO)/protoc_gen_go.mk)
# Must be set
$(call _assert_var,PROTOC_GEN_GO_GRPC_OUT)
$(call _assert_var,CACHE_BIN)
$(call _assert_var,BUF)
$(call _assert_var,PROTOC_GEN_GO_GRPC)

# Not modifiable for now
PROTOC_GEN_GO_GRPC_OPT := paths=source_relative,require_unimplemented_servers=false

.PHONY: protocgengogrpc
protocgengogrpc: protocgengoclean $(BUF) $(PROTOC_GEN_GO_GRPC)
	$(CACHE_BIN)/buf beta generate \
		--plugin go-grpc \
		--plugin-out $(PROTOC_GEN_GO_GRPC_OUT) \
		--plugin-opt $(PROTOC_GEN_GO_GRPC_OPT)

bufgenerate:: protocgengogrpc
