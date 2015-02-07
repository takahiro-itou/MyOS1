//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          BootSector.s                                                **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE16
        .ORG    0x0000

.section    .text

.equ    LOAD_ADDR_FAT        ,  0x7E00
.equ    LOAD_ADDR_ROOTDIR    ,  0xA200

//----------------------------------------------------------------
//
//      BPB (Bios Parameter Block).
//

        JMP         ENTRY_POINT
        .BYTE       0x90

.include    "Fat12Bpb.inc"

        .space      0x12,   0x00

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:
        XOR     %AX,        %AX
        MOV     %AX,        %SS
        MOV     $0x7C00,    %SP
        MOV     %AX,        %DS
        MOV     %AX,        %ES

        /*  ファイルアロケーションテーブルを読み込み。  */
        MOVW    (BPB_SizeOfFAT),        %AX
        MULB    (BPB_NumberOfFATs)
        MOV     %AX,    %CX     /*  読み込むセクタ数。  */
        MOVW    (BPB_RsvdSectorCount),  %SI
        MOV     $LOAD_ADDR_FAT,         %BX
        CALL    ReadSectors

        MOV     $0x0020,                %AX
        MULW    (BPB_RootEntryCount)
        ADDW    (BPB_BytesPerSector),   %AX
        DEC     %AX
        DIVW    (BPB_BytesPerSector)
        MOV     %AX,    %CX     /*  読み込むセクタ数。  */
        MOV     $LOAD_ADDR_ROOTDIR,     %BX
        CALL    ReadSectors

        /*  この時点で SI レジスタに、          **
        **  データ領域の先頭セクタ番号が入る。  **
        **  後で使うので、保存しておく。        */
        MOVW    %SI,        %BP

        /*  ファイルシステムの解析。    */
        MOV     $LOAD_ADDR_ROOTDIR,     %SI
        MOVW    (BPB_RootEntryCount),   %CX
        MOV     $.IPL_IMAGE_NAME,       %DI
        CALL    FindRootDirectoryEntry
        TEST    %SI,        %SI
        JZ      .LOAD_FAILURE

        MOV     $0x1000,    %BX
        CALL    ReadFile
        JMP     * %BX

.LOAD_FAILURE:
        MOV     $.MSG_FILE_NOT_FOUND,   %SI
        CALL    WriteString
.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.MSG_FILE_NOT_FOUND:
        .STRING     "IPL Not Found."
.IPL_IMAGE_NAME:
        .STRING     "IPLF12  BIN"

//----------------------------------------------------------------
//
//      フロッピーディスク読み込み関連。
//

.include    "ReadFloppy.s"

//----------------------------------------------------------------
//
//      ファイルシステム解析関連。
//

.include    "ReadFat12.s"

//----------------------------------------------------------------
//
//      文字列表示関連。
//

.include    "WriteString.s"
