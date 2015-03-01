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

//========================================================================

#define     PIC0_COMMAND_PORT   0x0020
#define     PIC0_STATUS_PORT    0x0020
#define     PIC0_DATA_PORT      0x0021
#define     PIC0_IMR_PORT       0x0021

#define     PIC1_COMMAND_PORT   0x00A0
#define     PIC1_STATUS_PORT    0x00A0
#define     PIC1_IMR_PORT       0x00A1
#define     PIC1_DATA_PORT      0x00A1

#define     PIC_ICW1            0x11

#define     PIC0_ICW2           0x20
#define     PIC1_ICW2           0x28

#define     PIC0_ICW3           (1 << 2)
#define     PIC1_ICW3           0x02

#define     PIC0_ICW4           0x01
#define     PIC1_ICW4           0x01

//----------------------------------------------------------------

void  initPIC(void)
{

}

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

    __asm__ __volatile__ ( "lidt    (_IDT_POINT)");
}
