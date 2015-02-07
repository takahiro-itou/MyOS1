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

.section    .text

        JMP     ENTRY_POINT

.equ    CODE_SEG     ,  0x0010
.equ    DATA_SEG     ,  0x0018

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

        CALL    _setupGDT
        MOV     $MSG_SETUP_GDT,         %SI
        CALL    WriteString

        MOV     $MSG_PROTECT_START,     %SI
        CALL    WriteString

        CLI
        MOV     %CR0,   %EAX
        OR      $0x01,  %EAX
        MOV     %EAX,   %CR0
        JMP     .PIPE_LINE_FLUSH

.PIPE_LINE_FLUSH:
        MOV     $DATA_SEG,  %AX
        MOV     %AX,        %SS
        MOV     %AX,        %DS
        MOV     %AX,        %ES
        MOV     %AX,        %FS
        MOV     %AX,        %GS

        LJMP    $CODE_SEG , $_startProtet32

_startProtet32:
        HLT
        JMP     _startProtet32

.include    "../../bootsector/WriteString.s"

.section    .data

//----------------------------------------------------------------
//
//      メッセージ。
//

MSG_FAILURE:
        .STRING     " ERROR\r\n"
MSG_SUCCESS:
        .STRING     " OK\r\n"

MSG_START_LOADING:
        .STRING     "Loading Operating System\r\n"
MSG_ENABLE_A20:
        .STRING     "Enabled A-20.\r\n"
MSG_SETUP_GDT:
        .STRING     "Maked Global Descriptor Table.\r\n"
MSG_PROTECT_START:
        .STRING     "Start Protect Mode ...\r\n"
