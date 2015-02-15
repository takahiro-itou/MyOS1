//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          Consoley.s                                                  **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

.equ    VRAM_ADDR    ,  0x000B8000

//----------------------------------------------------------------
/**   画面をクリアする。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：EAX, ECX
**/

clearConsole:
        PUSH    %EDI

        MOV     $VRAM_ADDR, %EDI
        MOV     $0x0020,    %AX
        MOV     $80 * 25,   %ECX
        REP     STOSW

        POP     %EDI
        RET

//----------------------------------------------------------------
/**   画面をスクロールする。
**
**  @param [in] ECX   スクロール行数。
**  @return     無し。
**  @attention  破壊されるレジスタ：無し。
**/

scrollConsole:
        PUSH    %EAX
        PUSH    %ECX
        PUSH    %ESI
        PUSH    %EDI

        /*  スクロール行数に 80 を掛ける。  */
        LEA     (%ECX, %ECX, 4),    %EAX
        SHL     $0x04,      %EAX

        MOV     $VRAM_ADDR, %EDI
        LEA     (%EDI, %EAX, 2),    %ESI
        MOV     $80 * 25,   %ECX
        SUB     %EAX,       %ECX
        REP     MOVSW

        MOV     %EAX,       %ECX
        MOV     $0x0020,    %EAX
        REP     STOSW

        POP     %EDI
        POP     %ESI
        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に文字列を表示する。
**
**  @param [in] AH        表示する文字の属性。
**  @param [in] DS:ESI    表示する文字列。
**  @param [in] EBX       表示する位置（水平方向）。
**  @param [in] EDX       表示する位置（垂直位置）。
**  @return     EBX       次の表示位置（水平方向）。
**  @return     EDX       次の表示位置（垂直方向）。
**  @attention  破壊されるレジスタ：AX
**/

writeText:
        PUSH    %EAX
        PUSH    %EDI

        MOV     $VRAM_ADDR,     %EDI

1:  //  @  .WRITE_CHAR_LOOP:
        LODSB   /*  MOVB    %DS:(%ESI),  %AL;   INC  %ESI       */
        TEST    %AL,    %AL
        JE      2f      ##  .WRITE_CHAR_FIN

        STOSW   /*  MOVW    %AX,  %ES:(%EDI);   ADD  $2,  %EDI  */

        JMP     1b      ##  .WRITE_CHAR_LOOP

2:  //  @  .WRITE_CHAR_FIN:

        POP     %EDI
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AL    表示する数値。
**  @param [in] BH    表示属性。
**  @param [in] EDI   表示する位置。
**  @return     EDI   次の表示位置。
**  @attention  破壊されるレジスタ：無し。
**/

writeByteHex:
        PUSH    %EAX
        PUSH    %ECX
        XCHG    %EAX,   %ECX

        MOV     %ECX,   %EAX
        SHR     $4,     %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue

        MOV     %ECX,   %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue

        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AX    表示する数値。
**  @param [in] BH    表示属性。
**  @param [in] EDI   表示する位置。
**  @return     EDI   次の表示位置。
**  @attention  破壊されるレジスタ：無し。
**/

writeWordHex:
        PUSH    %EAX
        PUSH    %ECX
        XCHG    %EAX,   %ECX

        MOV     %ECX,   %EAX
        SHR     $12,    %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        SHR     $8,     %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        SHR     $4,     %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        MOV     %BH,    %AH
        CALL    writeHexValue

        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AL    表示する数値。
**  @param [in] AH    表示属性。
**  @param [in] EDI   表示する位置。
**  @return     EDI   次の表示位置。
**  @attention  破壊されるレジスタ：AX
**/

writeHexValue:
        AND     $0x0F,  %AL
        CMP     $10,    %AL
        JL      1f

        ADD     $55,    %AL
        JMP     2f
1:
        ADD     $0x30,  %AL
2:
        STOSW

        RET
