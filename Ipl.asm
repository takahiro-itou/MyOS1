;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          Ipl.asm                                                     ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

        [BITS 16]
        ORG     0x1000

;;----------------------------------------------------------------
;;
;;      Entry Point.
;;

ENTRY_POINT:
        XOR     AX,  AX
        MOV     DS,  AX
        MOV     ES,  AX

        MOV     SI,  MSG_START_LOADING
        CALL    WriteString

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP


;;----------------------------------------------------------------
;;
;;      文字列表示関連。
;;

%include    "assembly16/WriteString.asm"

;;----------------------------------------------------------------
;;
;;      メッセージ。
;;

MSG_START_LOADING:
        DB      "Loading Operating System...", 0

