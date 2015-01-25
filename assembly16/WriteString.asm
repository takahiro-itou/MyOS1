;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          WriteString.asm                                             ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

;;----------------------------------------------------------------
;;    画面に文字列を表示する。
;;
;;  @param [in] DS:SI
;;  @return     無し
;;  @attention  破壊されるレジスタ：SI
;;

WriteString:
        PUSH    BX
.WRITE_CHAR_LOOP:
        LODSB   ;   AL, [DS:SI]
        TEST    AL, AL
        JE      .WRITE_CHAR_FIN
        CALL    WriteChar
        JMP     .WRITE_CHAR_LOOP
.WRITE_CHAR_FIN:
        POP     BX
        RET

;;----------------------------------------------------------------
;;    画面に壱文字を表示する。
;;
;;  @param [in] AL    表示する文字の文字コード。
;;  @return     無し
;;  @attention  破壊されるレジスタ：BX
;;

WriteChar:
        MOV     AH, 0x0E
        MOV     BX, 15
        INT     0x10
        RET

