//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          IplStart.s                                                  **
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
//      Entry Point.
//

ENTRY_POINT:

        XOR     %AX,    %AX
        MOV     %AX,    %DS
        MOV     %AX,    %ES

        MOV     $MSG_START_LOADING,     %SI
        CALL    WriteString

        CALL    _enableA20
        MOV     $MSG_ENABLE_A20,        %SI
        CALL    WriteString

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.include    "../../bootsector/WriteString.s"


.section    .data

//----------------------------------------------------------------
//
//      メッセージ。
//

MSG_START_LOADING:
        .STRING     "Loading Operating System\r\n"
MSG_ENABLE_A20:
        .STRING     "Enabled A-20.\r\n"
MSG_SETUP_GDT:
        .STRING     "Maked Global Descriptor Table.\r\n"
MSG_PROTECT32_START:
        .STRING     "Start 32bit Protect Mode...\r\n"
