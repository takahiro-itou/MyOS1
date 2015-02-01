;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          SetupGdt.asm                                                ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

        [BITS 16]

NumberOfGDTs    EQU     3

SetupGDT:
        CLI
        PUSHA
        LGDT    [GDT_POINT]
        POPA
        STI
        RET

GDT_POINT:
        DW      NumberOfGDTs * 8
        DD      .GDT_ENTRY

.GDT_ENTRY:

        ;;  Null Descriptor.
        DW      0x0000          ;   Limit Low.
        DW      0x0000          ;   Base Address Low.
        DB      0x00            ;   Base Address Mid.
        DB      0x00            ;   Flags & Type.
        DB      0x00            ;   Flags & Limit High &.
        DB      0x00            ;   Base Address High.

        ;;  Code Descriptor.
        DW      0xFFFF          ;   Limit Low.
        DW      0x0000          ;   Base Address Low.
        DB      0x00            ;   Base Address Mid.
        DB      10011010b       ;   Flags & Type.
        DB      11001111b       ;   Flags & Limit High.
        DB      0x00            ;   Base Address High.

        ;;  Data Descriptor.
        DW      0xFFFF          ;   Limit Low.
        DW      0x0000          ;   Base Address Low.
        DB      0x00            ;   Base Address Mid.
        DB      10010010b       ;   Flags & Type.
        DB      11001111b       ;   Flags & Limit High &.
        DB      0x00            ;   Base Address High.

