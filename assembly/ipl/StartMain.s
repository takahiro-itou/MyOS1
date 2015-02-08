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

//----------------------------------------------------------------
//
//      プロテクトモードの開始。
//

_startProtet32:
        ////    CALL    _startIplMain

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP
