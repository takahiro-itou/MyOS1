//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          KernelEntry.s                                               **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE32

.section    .text

        .global     ENTRY_POINT

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:
//        CALL    startKernel

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

