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
**      @file   kernel/SetupInterrupt.c
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
    GateDesc *  gd  = (GateDesc *)(INTGATE_DESCRIPTOR_ADDR) + idx;
    gd->ofsLow  = (offset & 0xFFFF);
    gd->segment = segment;
    gd->unused  = 0;
    gd->gdFlags = (flags & 0xFF);
    gd->ofsHigh = ((offset >> 16) & 0xFFFF);
}

//----------------------------------------------------------------

void  setupIDT(void)
{
    int i;
    for ( i = 0; i < 256; ++ i ) {
        setGateDesc(i, 0, 0, 0);
    }
    __asm__ __volatile__ ( "lidt    (_IDT_POINT)");
}
