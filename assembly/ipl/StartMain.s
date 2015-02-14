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
        /*  カーネルイメージをコピーする。  */
        CLD
        MOV     $KERNEL_TEMP_ADDR,  %ESI
        MOV     $KERNEL_BASE_ADDR,  %EDI
        MOV     $512,   %ECX    /*  ダミー。    */
        SHR     $2,     %ECX
        REP     MOVSD

        JMP     .HALT_LOOP
        LJMP    $CODE_SEG , $KERNEL_BASE_ADDR

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP
