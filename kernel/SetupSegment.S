//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**                      --  My Operating System --                      **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      セグメント設定。
**
**      @file   kernel/SetupSegment.S
**/

        .code32

        .global     _setupGDT
        .global     _IDT_POINT

//----------------------------------------------------------------
/**   GDT をセットアップする。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：無し。
**/

_setupGDT:
        lgdt    (GDT_POINT)
        ret

//========================================================================
//
//      テーブル本体。
//

#define     MYOS1_INCLUDE_FROM_ASM      1
#include    "Descriptors.h"
#include    "MemoryMap.h"

        /**         FLAGS:                     G, DB, 64, AV, P, LV, S */
#define     GDT_KERNEL_32   GDT_COMBINE_FLAGS( 1,  1,  0,  0, 1, 00, 1)
#define     GDT_KERNEL_64   GDT_COMBINE_FLAGS( 1,  0,  1,  0, 1, 00, 1)

#define     GDT_DS      0x02
#define     GDT_CS      0x0A

GDT_POINT:
        .align  8
        .word   .GDT_END - .GDT_ENTRY - 1
        .long   .GDT_ENTRY

        .align  8
_IDT_POINT:
_IDT_POINT_LIMIT:
        .word   256 * 8 - 1
_IDT_POINT_BASE:
        .long   INTGATE_DESCRIPTOR_ADDR

        .align  32

.GDT_ENTRY:
        //  Null Descriptor.
        .word   0x0000          /*  Limit Low           */
        .word   0x0000          /*  Base Address Low    */
        .byte   0x00            /*  Base Address Mid    */
        .byte   0x00            /*  Flags & Type        */
        .byte   0x00            /*  Flags & Limit High  */
        .byte   0x00            /*  Base Address High   */

        //  Reserved.   //
        .quad   0

        //  Segments.   //
        SET_GDT_ENTRY( GDT_KERNEL_32,  GDT_CS, 0x00000000, 0xFFFFFFFF )
        SET_GDT_ENTRY( GDT_KERNEL_32,  GDT_DS, 0x00000000, 0xFFFFFFFF )
//        SET_GDT_ENTRY( GDT_KERNEL_64,  GDT_CS, 0x00000000, 0xFFFFFFFF )
//        SET_GDT_ENTRY( GDT_KERNEL_64,  GDT_DS, 0x00000000, 0xFFFFFFFF )
.GDT_END:
