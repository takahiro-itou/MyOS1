//  -*-  coding: utf-8; mode: c++  -*-  //
/*************************************************************************
**                                                                      **
**                      --  My Operating System --                      **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      カーネルの定義。
**
**      @file   kernel/KernelMain.c
**/

#include    "Descriptors.h"

void  setupDescriptors()
{
    _setupGDT();
}

void  startKernel()
{
    int     i, j;
    unsigned char * ptrVRAM = (unsigned char *)(0x000A0000);

    //  画面を消去。    //
    for ( i = 0; i < 320 * 200; ++ i ) {
        ptrVRAM[i]  = 15;
    }

halt_loop:
    __asm__ __volatile__ ( "hlt" );
    goto    halt_loop;
}
