# fstar-slice
verified slice impl

# Run
```bash
root@c949ee1731d4:~/fstar-slice# make
krml -verify -drop WasmSupport -tmpdir ./out -fsopt --cache_dir -fsopt ./out -o ./out/slice -no-prefix Slice slice.fst main.c && ./out/slice
⚙ KreMLin auto-detecting tools. Here's what we found:
readlink is: readlink
KreMLin called via: krml
KreMLin home is: /root/kremlin
⚙ KreMLin will drive F*. Here's what we found:
read FSTAR_HOME via the environment
fstar is on branch HEAD
fstar is: /root/fstar/bin/fstar.exe /root/kremlin/runtime/WasmSupport.fst /root/fstar/ulib/FStar.UInt128.fst --trace_error --cache_checked_modules --expose_interfaces --include /root/kremlin/kremlib --include /root/kremlin/include
⚡ Calling F* (use -verbose to see the output)
...

✔ [F*] ⏱️ 12s and 912ms
✔ [Monomorphization] ⏱️ 17ms
✔ [Inlining] ⏱️ 3ms
✔ [Pattern matches compilation] ⏱️ 4ms
✔ [Structs + Simplify 2] ⏱️ 3ms
✔ [Drop] ⏱️ 2ms
✔ [AstToCStar] ⏱️ 2ms
✔ [CStarToC] ⏱️ <1ms
✔ [PrettyPrinting] ⏱️ <1ms
KreMLin: wrote out .c files for Slice
KreMLin: wrote out .h files for Slice
⚙ KreMLin will drive the C compiler. Here's what we found:
gcc is: gcc-7
gcc-7 options are: -I /root/kremlin/kremlib -I /root/kremlin/include -I ./out -Wall -Werror -Wno-unused-variable -Wno-unknown-warning-option -Wno-unused-but-set-variable -g -fwrapv -fstack-check -D_BSD_SOURCE -D_DEFAULT_SOURCE -Wno-parentheses -std=c11
⚡ Generating object files
✔ [CC,./out/Slice.c] (use -verbose to see the output)
✔ [CC,main.c] (use -verbose to see the output)
✔ [LD] (use -verbose to see the output)
All files linked successfully 👍
[0, 1, 2, 3, 4]
[2, 3]
[]
root@c949ee1731d4:~/fstar-slice#
```
