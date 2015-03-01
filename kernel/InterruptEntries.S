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
**      割り込みハンドラのエントリポイント。
**
**      @file   kernel/InterruptEntries.S
**/

        .code32

//========================================================================
//
//      割り込みハンドラ。
//

#define     MAKE_INTERRUPT_HANDLER(number)      \
    .global  _asm_int_ ## number ## _handler;   \
_asm_int_ ## number ## _handler:                \
        pushw   %es ;                           \
        pushw   %ds ;                           \
        pusha       ;                           \
        movl    %esp,  %eax ;                   \
        pushl   %eax        ;                   \
        movw    %ss,  %ax   ;                   \
        movw    %ax,  %ds   ;                   \
        movw    %ax,  %es   ;                   \
        call    _int_ ## number ## _handler;    \
        popl    %eax ;                          \
        popa         ;                          \
        popw    %ds  ;                          \
        popw    %es  ;                          \
        iret         ;

MAKE_INTERRUPT_HANDLER(21)
MAKE_INTERRUPT_HANDLER(2c)
