//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          SetupGdt.s                                                  **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE16

        .global     _setupGDT

//========================================================================
//
//      テーブルを設定するマクロ。

.macro  SET_GDT_B5      flags,  type
        .BYTE   ((\flags & 0xF0) | (\type & 0x0F))
.endm

.macro  SET_GDT_B6      flags,  limit
        .BYTE   (((\flags >> 8) & 0xFF) | ((\limit >> 28) & 0x0F))
.endm

.macro  SET_GDT_ENTRY   flags, type, base, limit
        .WORD   ((\limit >> 12) & 0xFFFF)   /*  Limit Low           */
        .WORD   (\base & 0xFFFF)            /*  Base Address Low    */
        .BYTE   ((\base  >> 16) & 0xFF)     /*  Base Address Mid    */
        SET_GDT_B5      \flags,  \type      /*  Flags & Type.       */
        SET_GDT_B6      \flags,  \limit     /*  Flags & Limit High  */
        .BYTE   ((\base  >> 24) & 0xFF)     /*  Base Address High   */
.endm

.macro  GDT_COMBINE_FLAGS   var,  gran, db, x64, avl, present, dpl, sys
        .equ    \var,    ((\gran << 15)) | ((\db << 14)) | ((\x64 << 13)) | ((\avl << 12)) | ((\present << 7)) | ((\dpl << 5)) | ((\sys << 4))
.endm

//========================================================================

.section    .text

//----------------------------------------------------------------
/**   GDT をセットアップする。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：無し。
**/

_setupGDT:
        LGDT    (GDT_POINT)
        RET

//========================================================================
//
//      テーブル本体。
//

.section    .gdt

        /**         FLAGS:                     G, DB, 64, AV, P, LV, S */
        GDT_COMBINE_FLAGS   GDT_KERNEL_32 ,    1,  1,  0,  0, 1, 00, 1
        GDT_COMBINE_FLAGS   GDT_KERNEL_64 ,    1,  0,  1,  0, 1, 00, 1

.equ    GDT_DS   ,  0x02
.equ    GDT_CS   ,  0x0A

GDT_POINT:
        .WORD   .GDT_END - .GDT_ENTRY
        .INT    .GDT_ENTRY

        .align  32

.GDT_ENTRY:
        //  Null Descriptor.
        .WORD   0x0000          /*  Limit Low           */
        .WORD   0x0000          /*  Base Address Low    */
        .BYTE   0x00            /*  Base Address Mid    */
        .BYTE   0x00            /*  Flags & Type        */
        .BYTE   0x00            /*  Flags & Limit High  */
        .BYTE   0x00            /*  Base Address High   */

        //  Reserved.   //
        .QUAD   0
        SET_GDT_ENTRY   GDT_KERNEL_32,  GDT_CS, 0x00000000, 0xFFFFFFFF
        SET_GDT_ENTRY   GDT_KERNEL_32,  GDT_DS, 0x00000000, 0xFFFFFFFF
        SET_GDT_ENTRY   GDT_KERNEL_64,  GDT_CS, 0x00000000, 0xFFFFFFFF
        SET_GDT_ENTRY   GDT_KERNEL_64,  GDT_DS, 0x00000000, 0xFFFFFFFF
.GDT_END:
