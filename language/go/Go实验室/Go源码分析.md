# Go源码实验室
本实验室用来记录各种Go语言的实验过程

## 查找程序入口
```
gdb test
(gdb) info files
Symbols from "/Users/donson/Documents/MyLib/mygithub/singleregistry/language/go/Go源码分析/test".
Local exec file:
        `/Users/donson/Documents/MyLib/mygithub/singleregistry/language/go/Go源码分析/test', file type mach-o-x86-64.
        Entry point: 0x1047da0
        0x0000000001001000 - 0x000000000104c3d3 is .text
        0x000000000104c3e0 - 0x0000000001074284 is __TEXT.__rodata
        0x0000000001074284 - 0x0000000001074284 is __TEXT.__symbol_stub1
        0x00000000010742a0 - 0x0000000001074928 is __TEXT.__typelink
        0x0000000001074928 - 0x0000000001074930 is __TEXT.__itablink
        0x0000000001074930 - 0x0000000001074930 is __TEXT.__gosymtab
        0x0000000001074940 - 0x00000000010a244a is __TEXT.__gopclntab
        0x00000000010a3000 - 0x00000000010a3000 is __DATA.__nl_symbol_ptr
        0x00000000010a3000 - 0x00000000010a39e8 is __DATA.__noptrdata
        0x00000000010a3a00 - 0x00000000010a51b0 is .data
        0x00000000010a51c0 - 0x00000000010c1448 is .bss
        0x00000000010c1460 - 0x00000000010c37d8 is __DATA.__noptrbss
(gdb) b *0x1047da0
Breakpoint 1 at 0x1047da0: file /usr/local/Cellar/go/1.10/libexec/src/runtime/rt0_darwin_amd64.s, line 8.
(gdb) q
```

