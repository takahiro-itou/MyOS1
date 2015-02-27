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
**      プロテクモードへの移行。
**
**      @file   assembly/ipl/ProtectMode.S
**/

        .code16

        .global     _enableA20
        .global     _setupGDT

//========================================================================

.section    .text

//----------------------------------------------------------------
/**   アドレスバスの A-20 制限を解除する。
**
**  @return     無し。
**/

_enableA20:
        //
        //  割り込みを禁止する。
        //
        cli

        //
        //  キーボードを無効化する。
        //
        call    WaitKbdCommandComplete
        movb    $0xAD,  %al
        outb    %al,    $0x64
        call    WaitKbdCommandComplete

        //
        //  アウトプットポートの現在の値を取得する。
        //
        movb    $0xD0,  %al
        outb    %al,    $0x64
        call    WaitKbdArriveData
        inb     $0x60,  %al

        //
        //  Bit 1 : A20 を有効。
        //
        orb     $0x02,  %al
        pushw   %ax

        //
        //  アウトプットポートに新しい値を書き込む。
        //
        call    WaitKbdCommandComplete
        movb    $0xD1,  %al
        outb    %al,    $0x64
        call    WaitKbdCommandComplete

        popw    %ax
        outb    %al,    $0x60
        call    WaitKbdCommandComplete

        //
        //  キーボードを有効化する。
        //
        movb    $0xAE,  %al
        outb    %al,    $0x64
        call    WaitKbdCommandComplete

        //
        //  割り込みを許可する。
        //
        sti
        ret

//----------------------------------------------------------------
/**   アウトプットバッファにデータが到着するのを待つ。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：ax
**/

WaitKbdArriveData:
        inb     $0x64,  %al
        testb   $0x01,  %al
        jz      WaitKbdArriveData
        ret

//----------------------------------------------------------------
/**   送信したコマンドが完了するのを待つ。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：ax
**/

WaitKbdCommandComplete:
        inb     $0x64,  %al
        testb   $0x02,  %al
        jnz     WaitKbdCommandComplete
        ret

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
//      テーブルを設定するマクロ。
//

#define     SET_GDT_B5(flags, type)     \
        ( (flags & 0xF0) | (type & 0x0F) )

#define     SET_GDT_B6(flags, limit)    \
        ( ((flags >> 8) & 0xFF) | ((limit >> 28) & 0x0F) )

#define     SET_GDT_ENTRY(flags, type, base, limit)     \
        .word   ((limit >> 12) & 0xFFFF);   /*  Limit Low           */  \
        .word   (base & 0xFFFF);            /*  Base Address Low    */  \
        .byte   ((base >> 16) & 0xFF);      /*  Base Address Mid    */  \
        .byte   SET_GDT_B5(flags, type);    /*  Flags & Type        */  \
        .byte   SET_GDT_B6(flags, limit);   /*  Flags & Limit High  */  \
        .byte   ((base >> 24) & 0xFF);      /*  Base Address High   */

#define     GDT_COMBINE_FLAGS(gran, db, x64, avl, present, dpl, sys)    \
        ( (gran << 15) | (db << 14) | (x64 << 13) | (avl << 12)         \
        | (present << 7) | (dpl << 5) | (sys << 4) )

//========================================================================
//
//      テーブル本体。
//

.section    .gdt

        /**         FLAGS:                     G, DB, 64, AV, P, LV, S */
#define     GDT_KERNEL_32   GDT_COMBINE_FLAGS( 1,  1,  0,  0, 1, 00, 1)
#define     GDT_KERNEL_64   GDT_COMBINE_FLAGS( 1,  0,  1,  0, 1, 00, 1)

#define     GDT_DS      0x02
#define     GDT_CS      0x0A


GDT_POINT:
        .word   .GDT_END - .GDT_ENTRY
        .long   .GDT_ENTRY

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
        SET_GDT_ENTRY( GDT_KERNEL_64,  GDT_CS, 0x00000000, 0xFFFFFFFF )
        SET_GDT_ENTRY( GDT_KERNEL_64,  GDT_DS, 0x00000000, 0xFFFFFFFF )
.GDT_END:

