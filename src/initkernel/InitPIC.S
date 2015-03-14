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
**      割り込みコントローラ設定。
**
**      @file   initkernel/InitPIC.S
**/

        .code32

        .global     initPIC

#define     PIC_MASTER_PORT_CMD     0x0020
#define     PIC_MASTER_PORT_STAT    0x0020
#define     PIC_MASTER_PORT_DATA    0x0021
#define     PIC_MASTER_PORT_IMR     0x0021

#define     PIC_SLAVE_PORT_CMD      0x00A0
#define     PIC_SLAVE_PORT_STAT     0x00A0
#define     PIC_SLAVE_PORT_DATA     0x00A1
#define     PIC_SLAVE_PORT_IMR      0x00A1

#define     PIC0_IMR_PORT           PIC_MASTER_PORT_IMR
#define     PIC0_ICW1_PORT          PIC_MASTER_PORT_CMD
#define     PIC0_ICW2_PORT          PIC_MASTER_PORT_DATA
#define     PIC0_ICW3_PORT          PIC_MASTER_PORT_DATA
#define     PIC0_ICW4_PORT          PIC_MASTER_PORT_DATA

#define     PIC1_IMR_PORT           PIC_SLAVE_PORT_IMR
#define     PIC1_ICW1_PORT          PIC_SLAVE_PORT_CMD
#define     PIC1_ICW2_PORT          PIC_SLAVE_PORT_DATA
#define     PIC1_ICW3_PORT          PIC_SLAVE_PORT_DATA
#define     PIC1_ICW4_PORT          PIC_SLAVE_PORT_DATA

#define     PIC0_ICW1_DATA          0x11
#define     PIC1_ICW1_DATA          0x11

#define     PIC0_ICW2_DATA          0x20
#define     PIC1_ICW2_DATA          0x28

#define     PIC0_ICW3_DATA          (1 << 2)
#define     PIC1_ICW3_DATA          0x02

#define     PIC0_ICW4_DATA          0x01
#define     PIC1_ICW4_DATA          0x01

//----------------------------------------------------------------
/**
**
**/

initPIC:
        pushl   %eax
        pushl   %edx
        cli

        movb    $0xFF,  %al
        movw    $PIC0_IMR_PORT,  %dx
        outb    %al,  %dx

        movb    $0xFF,  %al
        movw    $PIC1_IMR_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC0_ICW1_DATA,  %al
        movw    $PIC0_ICW1_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC0_ICW2_DATA,  %al
        movw    $PIC0_ICW2_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC0_ICW3_DATA,  %al
        movw    $PIC0_ICW3_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC0_ICW4_DATA,  %al
        movw    $PIC0_ICW4_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC1_ICW1_DATA,  %al
        movw    $PIC1_ICW1_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC1_ICW2_DATA,  %al
        movw    $PIC1_ICW2_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC1_ICW3_DATA,  %al
        movw    $PIC1_ICW3_PORT,  %dx
        outb    %al,  %dx

        movb    $PIC1_ICW4_DATA,  %al
        movw    $PIC1_ICW4_PORT,  %dx
        outb    %al,  %dx

        movb    $0b11111001,     %al
        movw    $PIC0_IMR_PORT,  %dx
        outb    %al,  %dx

        movb    $0b11101111,     %al
        movw    $PIC1_IMR_PORT,  %dx
        outb    %al,  %dx

        popl    %edx
        popl    %eax
        ret
