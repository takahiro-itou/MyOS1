//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          SetupGdts.s                                                 **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE16

        .global     _setupGDT

.equ    NumberOfGDTs     ,  3

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

//========================================================================

.section    .text

//----------------------------------------------------------------
/**   GDT をセットアップする。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：無し。
**/

_setupGDT:
        CLI
        PUSHA
        LGDT    (GDT_POINT)
        POPA
        STI
        RET

.section    .gdt


GDT_POINT:
        .WORD   NumberOfGDTs * 8
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

        //  Code Descriptor.
        SET_GDT_ENTRY   0xC090, 0x0A, 0x00000000, 0xFFFFFFFF
        SET_GDT_ENTRY   0xC090, 0x02, 0x00000000, 0xFFFFFFFF
