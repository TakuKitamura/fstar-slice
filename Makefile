all:
	krml -verify -drop WasmSupport -tmpdir ./out -fsopt --cache_dir -fsopt ./out -o ./out/slice -no-prefix Slice slice.fst main.c && ./out/slice
exec:
	krml -drop WasmSupport -tmpdir ./out -fsopt --cache_dir -fsopt ./out -o ./out/slice -no-prefix Slice slice.fst main.c && ./out/slice