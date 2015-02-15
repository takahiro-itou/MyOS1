//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          StartMain.s                                                 **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE32

.section    .text

        .global     _startProtet32

.equ    CODE_SEG             ,  0x0010
.equ    KERNEL_TEMP_ADDR     ,  0x00002000
.equ    KERNEL_BASE_ADDR     ,  0x00100000

//----------------------------------------------------------------
//
//      プロテクトモードの開始。
//

_startProtet32:
        MOV     $0x0A,      %AH
        XOR     %EBX,       %EBX
        MOV     $0x05,      %EDX
        MOV     $MSG_PROTECT_START, %ESI
        CALL    writeText
        MOV     $MSG_COPY_KERNEL,   %ESI
        CALL    writeText

        /*  カーネルイメージをコピーする。  */
        CLD
        MOV     $KERNEL_TEMP_ADDR,  %ESI
        MOV     $KERNEL_BASE_ADDR,  %EDI
        MOV     $512,   %ECX    /*  ダミー。    */
        SHR     $2,     %ECX
        REP     MOVSD

        CALL    .SHOW_OK_MESSAGE
        JMP     .HALT_LOOP
        LJMP    $CODE_SEG , $KERNEL_BASE_ADDR

.SHOW_ERROR_MESSAGE:
        MOV     $0x0C,          %AH
        MOV     $MSG_FAILURE,   %ESI
        CALL    writeText
.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.SHOW_OK_MESSAGE:
        MOV     $0x0B,          %AH
        MOV     $MSG_SUCCESS,   %ESI
        CALL    writeText
        RET

.include    "Console.s"

//----------------------------------------------------------------
//
//      文字列定数。
//

MSG_FAILURE:
        .STRING     " ERROR\r\n"
MSG_SUCCESS:
        .STRING     " OK\r\n"

MSG_PROTECT_START:
        .STRING     "Start 32bit Protect Mode ...\r\n"
MSG_COPY_KERNEL:
        .STRING     "Copy Kernel Image to 0x00100000 ..."
