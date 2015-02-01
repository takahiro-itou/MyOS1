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
        JMP     ENTRY_POINT

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

        CALL    EnableA20
        MOV     SI,  MSG_ENABLE_A20
        CALL    WriteString

        CALL    SetupGDT
        MOV     SI,  MSG_SETUP_GDT
        CALL    WriteString

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP


;;----------------------------------------------------------------
;;
;;      プロテクトモード関連。
;;

%include    "assembly16/EnableA20.asm"
%include    "assembly16/SetupGdt.asm"

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
        DB      "Loading Operating System ...", 0x0d, 0x0a, 0

MSG_ENABLE_A20:
        DB      "Enabled A-20.", 0x0d, 0x0a, 0

MSG_SETUP_GDT:
        DB      "Maked Global Descriptor Table.", 0x0d, 0x0a, 0
