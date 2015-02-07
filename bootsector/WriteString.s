//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          WriteString.s                                               **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

//----------------------------------------------------------------
/**   画面に文字列を表示する。
**
**  @param [in] DS:SI   表示する文字列。
**  @return     無し
**  @attention  破壊されるレジスタ：SI
**/

WriteString:
        PUSH    %BX
.WRITE_CHAR_LOOP:
        LODSB       /*  MOV  [DS:SI],   %AL */
        TESTB   %AL,  %AL
        JE      .WRITE_CHAR_FIN
        CALL    WriteChar
        JMP     .WRITE_CHAR_LOOP
.WRITE_CHAR_FIN:
        POP     %BX
        RET

//----------------------------------------------------------------
/**   画面に壱文字を表示する。
**
**  @param [in] AL    表示する文字の文字コード。
**  @return     無し。
**  @attention  破壊されるレジスタ：AX, BX
**/

WriteChar:
        MOV     $0x0E,  %AH
        MOV     $15,    %BX
        INT     $0x10
        RET
