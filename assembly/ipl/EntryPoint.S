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
**      エントリポイント。
**
**      @file   assembly/ipl/EntryPoint.S
**/

        .code16

.section    .text

.equ    CODE_SEG             ,  0x0010
.equ    DATA_SEG             ,  0x0018
.equ    FONT_ASCII_ADDR      ,  0x00002000
.equ    KERNEL_TEMP_ADDR     ,  0x00004000

        jmp         ENTRY_POINT
        .byte       0x90

#include    "Fat12Bpb.inc"

        .space      0x12,   0x00

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:

        xorw    %ax,  %ax
        movw    %ax,  %ds
        movw    %ax,  %es

        movw    $MSG_START_LOADING,  %si
        call    WriteString

        movw    $MSG_FIND_KERNEL,  %si
        call    WriteString

        movw    $LOAD_ADDR_ROOTDIR,    %si
        movw    (BPB_RootEntryCount),  %cx
        movw    $.KERNEL_IMAGE_NAME,   %di
        call    FindRootDirectoryEntry
        testw   %si,  %si
        jz      .SHOW_ERROR

        pushw   %si
        call    .SHOW_OK_MESSAGE

        movw    $MSG_READ_KERNEL,  %si
        call    WriteString

        popw    %si
        movw    $KERNEL_TEMP_ADDR,  %bx
        call    ReadFile
        call    .SHOW_OK_MESSAGE

        /*  フォントファイル読み込み。  */
        movw    $MSG_FIND_FONT,  %si
        call    WriteString

        movw    $LOAD_ADDR_ROOTDIR,    %SI
        movw    (BPB_RootEntryCount),  %cx
        movw    $.FONT_ASCII_NAME,     %di
        call    FindRootDirectoryEntry
        testw   %si,  %si
        jz      .SHOW_ERROR

        pushw   %si
        call    .SHOW_OK_MESSAGE

        movw    $MSG_READ_FONT,  %si
        call    WriteString

        popw    %si
        movw    $FONT_ASCII_ADDR,  %bx
        call    ReadFile
        call    .SHOW_OK_MESSAGE

        /*  ディスプレイモードの設定。  */
        movw    $0x0013,  %ax
        int     $0x10

        /*  プロテクトモードの準備。    */
        call    _enableA20
        cli
        call    _setupGDT

        movl    %cr0,   %eax
        orl     $0x01,  %eax
        movl    %eax,   %cr0
        jmp     .PIPE_LINE_FLUSH

.PIPE_LINE_FLUSH:
        movw    $DATA_SEG,  %ax
        movw    %ax,  %ss
        movw    %ax,  %ds
        movw    %ax,  %es
        movw    %ax,  %fs
        movw    %ax,  %gs

        ljmp    $CODE_SEG , $_startProtet32

.SHOW_ERROR:
        movw    $MSG_FAILURE,   %si
        call    WriteString

.HALT_LOOP:
        hlt
        jmp     .HALT_LOOP

.SHOW_OK_MESSAGE:
        pushw   %si
        movw    $MSG_SUCCESS,   %si
        call    WriteString
        popw    %si
        ret

.KERNEL_IMAGE_NAME:
        .string     "KERNEL0 IMG"
.FONT_ASCII_NAME:
        .string     "ASCII   FNT"

//----------------------------------------------------------------
//
//      フロッピーディスク読み込み関連。
//

#include    "FloppyDisk.S"

//----------------------------------------------------------------
//
//      ファイルシステム解析関連。
//

#include    "FileSystemFat12.S"

//----------------------------------------------------------------
//
//      文字列表示関連。
//

#include    "WriteString16.S"

.section    .data

//----------------------------------------------------------------
//
//      文字列定数。
//

MSG_FAILURE:
        .string     " ERROR\r\n"
MSG_SUCCESS:
        .string     " OK\r\n"

MSG_START_LOADING:
        .string     "Loading Operating System\r\n"
MSG_FIND_KERNEL:
        .string     "Find Kernel Image ..."
MSG_READ_KERNEL:
        .string     "Read Kernel Image ..."
MSG_FIND_FONT:
        .string     "Find Font File ..."
MSG_READ_FONT:
        .string     "Read Font File ..."
