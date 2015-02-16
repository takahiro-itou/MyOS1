//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          EnableA20.s                                                 **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE16

        .global     _enableA20

//----------------------------------------------------------------
/**   アドレスバスの A-20 制限を解除する。
**
**  @return     無し。
**/

_enableA20:
        //
        //  割り込みを禁止する。
        //
        CLI

        //
        //  キーボードを無効化する。
        //
        CALL    WaitKbdCommandComplete
        MOV     $0xAD,  %AL
        OUT     %AL,    $0x64
        CALL    WaitKbdCommandComplete

        //
        //  アウトプットポートの現在の値を取得する。
        //
        MOV     $0xD0,  %AL
        OUT     %AL,    $0x64
        CALL    WaitKbdArriveData
        IN      $0x60,  %AL

        //
        //  Bit 1 : A20 を有効。
        //
        OR      $0x02,  %AL
        PUSH    %AX

        //
        //  アウトプットポートに新しい値を書き込む。
        //
        CALL    WaitKbdCommandComplete
        MOV     $0xD1,  %AL
        OUT     %AL,    $0x64
        CALL    WaitKbdCommandComplete

        POP     %AX
        OUT     %AL,    $0x60
        CALL    WaitKbdCommandComplete

        //
        //  キーボードを有効化する。
        //
        MOV     $0xAE,  %AL
        OUT     %AL,    $0x64
        CALL    WaitKbdCommandComplete

        //
        //  割り込みを許可する。
        //
        STI
        RET

//----------------------------------------------------------------
/**   アウトプットバッファにデータが到着するのを待つ。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：AX
**/

WaitKbdArriveData:
        IN      $0x64,  %AL
        TEST    $0x01,  %AL
        JZ      WaitKbdArriveData
        RET

//----------------------------------------------------------------
/**   送信したコマンドが完了するのを待つ。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：AX
**/

WaitKbdCommandComplete:
        IN      $0x64,  %AL
        TEST    $0x02,  %AL
        JNZ     WaitKbdCommandComplete
        RET
