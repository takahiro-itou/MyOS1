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
**  @attention  破壊されるレジスタ：無し。
**/

writeText:
        PUSH    %EAX
        PUSH    %ECX
        PUSH    %EDI
        PUSH    %ESI

        CALL    ._calcVramAddrToWrite

1:  //  @  .WRITE_CHAR_LOOP:
        LODSB   /*  MOVB    %DS:(%ESI),  %AL;   INC  %ESI       */
        TEST    %AL,    %AL
        JE      2f      ##  .WRITE_CHAR_FIN

        TEST    $0xE0,  %AL
        JNZ     3f      ##  .WRITE_CHAR_IMM

.WRITE_CTRL_CHAR:
        CMP     $0x0A,  %AL
        JE      4f      ##  .GOTO_NEXT_LINE
        CMP     $0x0D,  %AL
        JNE     3f      ##  .WRITE_CHAR_IMM
.WRITE_CTRL_CHAR_OD:
        /*  キャリッジリターン。    */
        XOR     %EBX,   %EBX
        JMP     5f      ##  .CALC_VRAM_ADDR

3:  //  @  .WRITE_CHAR_IMM:
        STOSW   /*  MOVW    %AX,  %ES:(%EDI);   ADD  $2,  %EDI  */

        INC     %EBX
        CMP     $80,    %EBX
        JL      1b      ##  .WRITE_CHAR_LOOP
        XOR     %EBX,   %EBX

4:  //  @  .GOTO_NEXT_LINE
        INC     %EDX
        CMP     $25,    %EDX
        JL      5f      ##  .CALC_VRAM_ADDR
        MOV     $1,     %ECX
        CALL    scrollConsole
        SUB     %ECX,   %EDX
5:  //  @  .CALC_VRAM_ADDR
        CALL    ._calcVramAddrToWrite
        JMP     1b      ##  .WRITE_CHAR_LOOP

2:  //  @  .WRITE_CHAR_FIN:

        POP     %ESI
        POP     %EDI
        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面にバイナリダンプを行う。
**
**  @param [in] AH        表示する文字の属性。
**  @param [in] DS:ESI    表示するデータ。
**  @param [in] EBX       表示する位置（水平方向）。
**  @param [in] EDX       表示する位置（垂直位置）。
**  @return     EBX       次の表示位置（水平方向）。
**  @return     EDX       次の表示位置（垂直方向）。
**  @attention  破壊されるレジスタ：無し。
**/

writeHexDump:
        PUSH    %EAX
        PUSH    %ECX
        PUSH    %EBP
        PUSH    %ESI
        PUSH    %EDI

        CALL    ._calcVramAddrToWrite
        MOV     %EDX,   %EBP
        MOV     %EAX,   %EDX

1:  //  @  .DUMP_BYTE_LOOP:

        LODSB
        CALL    writeByteHex
        MOV     $0x20,  %AX
        STOSW
        ADD     $0x03,  %EBX

        CMP     $80,    %EBX
        JL      3f      ##  .DUMP_BYTE_CONTINUE

        SUB     $80,    %EBX

        PUSH    %EDX
        MOV     %EBP,   %EDX
        INC     %EDX
        CMP     $25,    %EDX
        JL      2f      ##  .CALC_VRAM_ADDR

        PUSH    %ECX
        MOV     $1,     %ECX
        CALL    scrollConsole
        SUB     %ECX,   %EDX
        POP     %ECX
2:  //  @  .CALC_VRAM_ADDR:
        CALL    ._calcVramAddrToWrite
        MOV     %EDX,   %EBP
        POP     %EDX

3:  //  @  .DUMP_BYTE_CONTINUE:
        LOOP    1b      ##  .DUMP_BYTE_LOOP

        MOV     %EBP,   %EDX
        POP     %EDI
        POP     %ESI
        POP     %EBP
        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AL    表示する数値。
**  @param [in] DH    表示属性。
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
        MOV     %DH,    %AH
        CALL    ._writeHexValue

        MOV     %ECX,   %EAX
        MOV     %DH,    %AH
        CALL    ._writeHexValue

        POP     %ECX
        POP     %EAX
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AX    表示する数値。
**  @param [in] DH    表示属性。
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
        MOV     %DH,    %AH
        CALL    ._writeHexValue
        MOV     %ECX,   %EAX
        SHR     $8,     %EAX
        MOV     %DH,    %AH
        CALL    ._writeHexValue
        MOV     %ECX,   %EAX
        SHR     $4,     %EAX
        MOV     %DH,    %AH
        CALL    ._writeHexValue
        MOV     %ECX,   %EAX
        MOV     %DH,    %AH
        CALL    ._writeHexValue

        POP     %ECX
        POP     %EAX
        RET


//----------------------------------------------------------------
/**   表示位置からデータを書き込むアドレスを計算する。
**
**  @param [in] EBX   表示する位置（水平方向）。
**  @param [in] EDX   表示する位置（垂直位置）。
**  @return     EDI   書き込むアドレス。
**  @attention  破壊されるレジスタ：無し。
**/
._calcVramAddrToWrite:
        PUSH    %EAX

        LEA     (%EDX, %EDX, 4),    %EAX
        SHL     $0x04,  %EAX
        ADD     %EBX,   %EAX
        MOV     $VRAM_ADDR,         %EDI
        LEA     (%EDI, %EAX, 2),    %EDI

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

._writeHexValue:
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
