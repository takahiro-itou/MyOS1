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
**      割り込み設定。
**
**      @file   initkernel/SetupInterrupt.c
**/

#include    "Descriptors.h"
#include    "MemoryMap.h"

typedef  struct
{
    unsigned short  ofsLow;
    unsigned short  segment;
    unsigned char   unused;
    unsigned char   gdFlags;
    unsigned short  ofsHigh;
} GateDesc;

//========================================================================


//----------------------------------------------------------------
/**
**
**/

void
setGateDesc(
        const  int  idx,
        const  int  offset,
        const  int  segment,
        const  int  flags)
{
    GateDesc *  gd  = (GateDesc *)(MM_ADDR_INTGATE_DESCRIPTOR) + idx;
    gd->ofsLow  = (offset & 0xFFFF);
    gd->segment = segment;
    gd->unused  = 0;
    gd->gdFlags = (flags & 0xFF);
    gd->ofsHigh = ((offset >> 16) & 0xFFFF);
}

//----------------------------------------------------------------

#define     INTGATE32_FLAGS     INT_GATE_FLAGS(1, 0, 1)
void  _asm_int_21_handler(void);
void  _asm_int_2c_handler(void);

void  setupIDT(void)
{
    int i;
    for ( i = 0; i < 256; ++ i ) {
        setGateDesc(i, 0, 0, 0);
    }

    setGateDesc(0x21, (int)(_asm_int_21_handler), 0x10, INTGATE32_FLAGS);
    setGateDesc(0x2c, (int)(_asm_int_2c_handler), 0x10, INTGATE32_FLAGS);

    loadKernelIDT();
}
