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
**      カーネルの起動。
**
**      @file   initloader/StartKernel.S
**/

#include    "MemoryMap.h"

        .code32

.section    .text

        .global     _startProtet32

.equ    CODE_SEG             ,  0x0010

//----------------------------------------------------------------
//
//      プロテクトモードの開始。
//

_startProtet32:
        movb    $0x0A,  %ah
        xorl    %ebx,   %ebx
        movl    $0x05,  %edx
        movl    $MSG_PROTECT_START,  %esi
        call    writeText

        movl    $MSG_CHECK_A20,  %esi
        call    writeText
        call    _checkEnableA20
        testl   %eax,  %eax
        jz      .SHOW_ERROR_MESSAGE
        call    .SHOW_OK_MESSAGE

        /*  カーネルイメージをコピーする。  */
        movl    $MSG_COPY_KERNEL,  %esi
        call    writeText

        cld
        movl    $KERNEL0_TEMP_ADDR,  %esi
        movl    $KERNEL0_BASE_ADDR,  %edi
        movl    $512,   %ecx    /*  ダミー。    */
        shrl    $2,     %ecx
        rep     movsd

        call    .SHOW_OK_MESSAGE

        /*  読み込んだカーネルへジャンプ。  */
        ljmp    $CODE_SEG , $KERNEL0_BASE_ADDR

.SHOW_ERROR_MESSAGE:
        movb    $0x0C,  %ah
        movl    $MSG_FAILURE,  %esi
        call    writeText
.HALT_LOOP:
        hlt
        jmp     .HALT_LOOP

.SHOW_OK_MESSAGE:
        movb    $0x0B,  %ah
        movl    $MSG_SUCCESS,  %esi
        call    writeText
        ret

//----------------------------------------------------------------
/**   アドレスラインの A-20 が有効になっているか確認する。
**
**  @return     EAX == 0  無効。
**  @return     EAX != 0  有効。
**/

_checkEnableA20:
        pushl   %ecx
        pushl   %esi
        pushl   %edi

        //  有効になっていなければ、ラップしている筈。      //
        //  以下の異なる二箇所に異なる値を書き込んでみる。  //
        //  もし有効になってないなら、同じ値になる。        //
        movl    $0x00000F00,  %esi
        movl    $0x00100F00,  %edi

        //  書き込む場所の現在の値を保存しておく。  //
        movl    (%esi),  %eax
        pushl   %eax
        movl    (%edi),  %eax
        pushl   %eax

        //  壱番目のアドレスに適当な値を書き込む。  //
        movl    $0x55AA55AA,  %eax
        movl    %eax,  (%esi)
        //  二番目のアドレスに別の値を書き込む。    //
        movl    $0x12345678,  %eax
        movl    %eax,  (%edi)

        //  壱番目のアドレスから値を読み込んで、    //
        //  それを二番目のアドレスの値と比較する。  //
        movl    (%esi),  %ecx
        subl    %eax,    %ecx

        popl    %eax
        movl    %eax,  (%edi)
        popl    %eax
        movl    %eax,  (%esi)

        popl    %edi
        popl    %esi
        xchgl   %ecx,  %eax
        popl    %ecx
        ret

#include    "Console32.S"

//----------------------------------------------------------------
//
//      文字列定数。
//

MSG_FAILURE:
        .string     " ERROR\r\n"
MSG_SUCCESS:
        .string     " OK\r\n"

MSG_PROTECT_START:
        .string     "Start 32bit Protect Mode ...\r\n"
MSG_COPY_KERNEL:
        .string     "Copy Kernel Image to 0x00100000 ..."
MSG_CHECK_A20:
        .string     "Checking A-20 Line Enabled ..."
