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
/**   画面に文字列を表示する。
**
**  @param [in] AH        表示する文字の属性。
**  @param [in] DS:ESI    表示する文字列。
**  @return
**  @attention  破壊されるレジスタ：AX
**/

writeText:
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
        RET

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] AX    表示する値。
**  @param [in] DI    表示する位置。
**  @return     DI
**  @attention
**/

writeByteHex:
        PUSH    %EAX
        PUSH    %ECX
        XCHG    %EAX,   %ECX

        MOV     %ECX,   %EAX
        SHR     $4,     %EAX
        CALL    writeHexValue

        MOV     %ECX,   %EAX
        CALL    writeHexValue

        POP     %ECX
        POP     %EAX
        RET

writeWordHex:
        PUSH    %EAX
        PUSH    %ECX
        XCHG    %EAX,   %ECX

        MOV     %ECX,   %EAX
        SHR     $12,    %EAX
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        SHR     $8,     %EAX
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        SHR     $4,     %EAX
        CALL    writeHexValue
        MOV     %ECX,   %EAX
        CALL    writeHexValue

        POP     %ECX
        POP     %EAX
        RET

writeHexValue:
        AND     $0x0F,  %AL
        CMP     $10,    %AL
        JL      1f

        ADD     $55,    %AL
        JMP     2f
1:
        ADD     $0x30,  %AL
2:
        MOV     $0x0B,  %AH
        STOSW

        RET
