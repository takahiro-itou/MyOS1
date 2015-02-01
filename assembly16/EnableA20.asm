;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          EnableA20.asm                                               ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

        [BITS 16]

;;----------------------------------------------------------------
;;    アドレスバスの A-20 制限を解除する。
;;
;;  @return     無し
;;

EnableA20:
        ;;
        ;;  割り込みを禁止する。
        ;;
        CLI

        ;;
        ;;  キーボードを無効化する。
        ;;
        CALL    WaitKbdCommandComplete
        MOV     AL,  0xAD
        OUT     0x64,  AL
        CALL    WaitKbdCommandComplete

        ;;
        ;;  アウトプットポートの現在の値を取得する。
        ;;
        MOV     AL,  0xD0
        OUT     0x64,  AL
        CALL    WaitKbdArriveData
        IN      AL,  0x60

        ;;
        ;;  Bit 1 : A20 を有効。
        ;;
        OR      AL,  0x02
        PUSH    AX

        ;;
        ;;  アウトプットポートに新しい値を書き込む。
        ;;
        CALL    WaitKbdCommandComplete
        MOV     AL,  0xD1
        OUT     0x64,  AL
        CALL    WaitKbdCommandComplete

        POP     AX
        OUT     0x60,  AL
        CALL    WaitKbdCommandComplete

        ;;
        ;;  キーボードを有効化する。
        ;;
        MOV     AL,  0xAE
        OUT     0x64,  AL
        CALL    WaitKbdCommandComplete

        ;;
        ;;  割り込みを許可する。
        ;;
        STI
        RET

;;----------------------------------------------------------------
;;    アウトプットバッファにデータが到着するのを待つ。
;;
WaitKbdArriveData:
        IN      AL,  0x64
        TEST    AL,  0x01
        JZ      WaitKbdArriveData
        RET

;;----------------------------------------------------------------
;;    送信したコマンドが完了するのを待つ。
;;
WaitKbdCommandComplete:
        IN      AL,  0x64
        TEST    AL,  0x02
        JNZ     WaitKbdCommandComplete
        RET
