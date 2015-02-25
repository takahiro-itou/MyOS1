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
**      ブートセクタ。
**
**      @file   assembly/bootsector/BootSector.S
**/

#include    "MemoryMap.h"

        .code16
        .org    0x0000

.section    .text

//----------------------------------------------------------------
//
//      BPB (Bios Parameter Block).
//

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
        movw    %ax,  %ss
        movw    $0x7C00,  %sp
        movw    %ax,  %ds
        movw    %ax,  %es

        /*  ファイルアロケーションテーブルを読み込み。  */
        movw    (BPB_SizeOfFAT),  %ax
        mulb    (BPB_NumberOfFATs)
        movw    %ax,  %cx       /*  読み込むセクタ数。  */
        movw    (BPB_RsvdSectorCount),  %si
        movw    $LOAD_ADDR_FAT,   %bx
        call    ReadSectors

        movw    $0x0020,  %ax
        mulw    (BPB_RootEntryCount)
        addw    (BPB_BytesPerSector),  %ax
        dec     %ax
        divw    (BPB_BytesPerSector)
        movw    %ax,  %cx       /*  読み込むセクタ数。  */
        movw    $LOAD_ADDR_ROOTDIR,    %bx
        call    ReadSectors

        /*  この時点で SI レジスタに、          **
        **  データ領域の先頭セクタ番号が入る。  **
        **  後で使うので、保存しておく。        */
        movw    %si,  %bp

        /*  ファイルシステムの解析。    */
        movw    $LOAD_ADDR_ROOTDIR,    %si
        movw    (BPB_RootEntryCount),  %cx
        movw    $.IPL_IMAGE_NAME,      %di
        call    FindRootDirectoryEntry
        test    %si,  %si
        jz      .LOAD_FAILURE

        movw    $0x1000,  %bx
        call    ReadFile
        cmpw    $0x1000,  %ax       /*  IPL は 4 KB 以内。  */
        ja      .IPL_SIZE_ERROR
        jmp     * %bx

.LOAD_FAILURE:
        movw    $.MSG_FILE_NOT_FOUND,   %si
        call    WriteString
        jmp     .HALT_LOOP
.IPL_SIZE_ERROR:
        movw    $.MSG_IPL_TOO_LARGE,    %si
        call    WriteString
        jmp     .HALT_LOOP
.HALT_LOOP:
        hlt
        jmp     .HALT_LOOP

.MSG_FILE_NOT_FOUND:
        .STRING     "IPL Not Found."
.MSG_IPL_TOO_LARGE:
        .STRING     "FATAL: IPL Too Large"
.IPL_IMAGE_NAME:
        .STRING     "IPLF12  BIN"

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
