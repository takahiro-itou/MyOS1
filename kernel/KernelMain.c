//  -*-  coding: utf-8; mode: c++  -*-  //
/*************************************************************************
**                                                                      **
**          KernelMain.c                                                **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

void  startKernel()
{
    int     i, j;
    short * ptrVRAM = (short *)(0x000B8000);
    const  char  *  buf = "Hello, World";

    //  画面を消去。    //
    for ( i = 0; i < 80 * 25; ++ i ) {
        ptrVRAM[i]  = 0x0020;
    }

    //  文字列を表示。  //
    for ( j = 0; j < 16; ++ j ) {
        short * ptr = ptrVRAM + (j * 80);
        for ( i = 0; buf[i] != '\0'; ++ i ) {
            ptr[i]  = (j << 8) | (buf[i]);
        }
    }

    return;
}
