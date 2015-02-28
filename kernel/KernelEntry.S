//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          KernelEntry.s                                               **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

#include    "BootInfo.h"

        .CODE32

.section    .entry

        .global     start,  _start

start:
_start:
        jmp     ENTRY_POINT

//----------------------------------------------------------------

        .align      16
        .long       MULTIBOOT_HEADER_MAGIC
        .long       MULTIBOOT_HEADER_FLAGS
        .long       - (MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:
        pushl   %ebx
        pushl   %eax
        CALL    startKernel

.HALT_LOOP:
        hlt
        jmp     .HALT_LOOP

