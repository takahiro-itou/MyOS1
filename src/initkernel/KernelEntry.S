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
**      エントリポイント。
**
**      @file   initkernel/SetupSegment.S
**/

#define     MYOS1_INCLUDE_FROM_ASM
#include    "BootInfo.h"

        .code32

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

