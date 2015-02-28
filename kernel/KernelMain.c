//  -*-  coding: utf-8; mode: c++  -*-  //
/*************************************************************************
**                                                                      **
**          KernelMain.c                                                **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

void  _setupGDT();

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

    return;
}
