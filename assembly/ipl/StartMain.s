//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          StartMain.s                                                 **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE32

.section    .text

        .global     _startProtet32

.equ    CODE_SEG             ,  0x0010
.equ    KERNEL_TEMP_ADDR     ,  0x00002000
.equ    KERNEL_BASE_ADDR     ,  0x00100000

//----------------------------------------------------------------
//
//      プロテクトモードの開始。
//

_startProtet32:
        MOV     $0x0A,      %AH
        XOR     %EBX,       %EBX
        MOV     $0x05,      %EDX
        MOV     $MSG_PROTECT_START, %ESI
        CALL    writeText

        MOV     $MSG_CHECK_A20,     %ESI
        CALL    writeText
        CALL    _checkEnableA20
        TEST    %EAX,   %EAX
        JZ      .SHOW_ERROR_MESSAGE
        CALL    .SHOW_OK_MESSAGE
        JMP     .HALT_LOOP

        /*  カーネルイメージをコピーする。  */
        MOV     $MSG_COPY_KERNEL,   %ESI
        CALL    writeText

        CLD
        MOV     $KERNEL_TEMP_ADDR,  %ESI
        MOV     $KERNEL_BASE_ADDR,  %EDI
        MOV     $512,   %ECX    /*  ダミー。    */
        SHR     $2,     %ECX
        REP     MOVSD

        CALL    .SHOW_OK_MESSAGE
        JMP     .HALT_LOOP
        LJMP    $CODE_SEG , $KERNEL_BASE_ADDR

.SHOW_ERROR_MESSAGE:
        MOV     $0x0C,          %AH
        MOV     $MSG_FAILURE,   %ESI
        CALL    writeText
.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.SHOW_OK_MESSAGE:
        MOV     $0x0B,          %AH
        MOV     $MSG_SUCCESS,   %ESI
        CALL    writeText
        RET

//----------------------------------------------------------------
/**   アドレスラインの A-20 が有効になっているか確認する。
**
**  @return     EAX == 0  無効。
**  @return     EAX != 0  有効。
**/

_checkEnableA20:
        PUSH    %ECX
        PUSH    %ESI
        PUSH    %EDI

        //  有効になっていなければ、ラップしている筈。      //
        //  以下の異なる二箇所に異なる値を書き込んでみる。  //
        //  もし有効になってないなら、同じ値になる。        //
        MOV     $0x00000F00,    %ESI
        MOV     $0x00100F00,    %EDI

        //  書き込む場所の現在の値を保存しておく。  //
        MOV     (%ESI),     %EAX
        PUSH    %EAX
        MOV     (%EDI),     %EAX
        PUSH    %EAX

        //  壱番目のアドレスに適当な値を書き込む。  //
        MOV     $0x55AA55AA,    %EAX
        MOV     %EAX,       (%ESI)
        //  二番目のアドレスに別の値を書き込む。    //
        MOV     $0x12345678,    %EAX
        MOV     %EAX,       (%EDI)

        //  壱番目のアドレスから値を読み込んで、    //
        //  それを二番目のアドレスの値と比較する。  //
        MOV     (%ESI),     %ECX
        SUB     %EAX,       %ECX

        POP     %EAX
        MOV     %EAX,       (%EDI)
        POP     %EAX
        MOV     %EAX,       (%ESI)

        POP     %EDI
        POP     %ESI
        XCHG    %ECX,       %EAX
        POP     %ECX
        RET

.include    "Console.s"

//----------------------------------------------------------------
//
//      文字列定数。
//

MSG_FAILURE:
        .STRING     " ERROR\r\n"
MSG_SUCCESS:
        .STRING     " OK\r\n"

MSG_PROTECT_START:
        .STRING     "Start 32bit Protect Mode ...\r\n"
MSG_COPY_KERNEL:
        .STRING     "Copy Kernel Image to 0x00100000 ..."
MSG_CHECK_A20:
        .STRING     "Checking A-20 Line Enabled ..."
