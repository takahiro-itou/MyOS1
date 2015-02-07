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
        XOR     %AX,   %AX
        MOV     %AX,   %SS
        MOV     $0x7C00,  %SP
        MOV     %AX,   %DS
        MOV     %AX,   %ES
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
//      文字列表示関連。
//

.include    "WriteString.s"
