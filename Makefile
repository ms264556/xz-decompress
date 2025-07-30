xzdir := module/xz-embedded
xzlibdir := $(xzdir)/linux/lib/xz

wasisdkroot ?= wasi-sdk
webpackcommand := node_modules/.bin/webpack

.PHONY: all clean package

all: dist/native/xz-decompress.wasm package

dist/native/xz-decompress.wasm: src/native/* $(xzdir)/**/* Makefile
	mkdir -p dist/native
	"$(wasisdkroot)/bin/clang" --sysroot="$(wasisdkroot)/share/wasi-sysroot" \
		--target=wasm32 -DNDEBUG -Os -s -nostdlib -Wl,--no-entry \
		-DXZ_DEC_CONCATENATED -DXZ_USE_CRC64 -DXZ_USE_SHA256 -DXZ_DEC_ANY_CHECK \
		-Wl,--export=create_context \
		-Wl,--export=destroy_context \
		-Wl,--export=supply_input \
		-Wl,--export=get_next_output \
		-o dist/native/xz-decompress.wasm \
		-I$(xzdir)/userspace/ \
		-I$(xzdir)/linux/include/linux/ \
		module/walloc/walloc.c \
		src/native/*.c \
		$(xzlibdir)/xz_crc32.c \
		$(xzlibdir)/xz_crc64.c \
		$(xzlibdir)/xz_sha256.c \
		$(xzlibdir)/xz_dec_stream.c \
		$(xzlibdir)/xz_dec_lzma2.c

package: dist/package/xz-decompress.esm.js

dist/package/xz-decompress.esm.js: webpack.config.js src/*.js dist/native/xz-decompress.wasm
	@$(webpackcommand)

clean:
	rm -rf dist
