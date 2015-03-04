//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**                      --  My Operating System --                      **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      文字列表示。
**
**      @file   common/WriteString16.S
**/

//----------------------------------------------------------------
/**   画面に文字列を表示する。
**
**  @param [in] ds:si   表示する文字列。
**  @return     無し
**  @attention  破壊されるレジスタ：si
**/

WriteString:
        pushw   %bx

1:  //  @  .WRITE_CHAR_LOOP:
        lodsb       /*  MOV  [DS:SI],   %AL */
        testb   %al,  %al
        je      2f      ##  .WRITE_CHAR_FIN
        call    WriteChar
        jmp     1b      ##  .WRITE_CHAR_LOOP

2:  //  @  .WRITE_CHAR_FIN:
        popw    %bx
        ret

//----------------------------------------------------------------
/**   画面に壱文字を表示する。
**
**  @param [in] al    表示する文字の文字コード。
**  @return     無し。
**  @attention  破壊されるレジスタ：ax, bx
**/

WriteChar:
        movb    $0x0E,  %ah
        movw    $15,    %bx
        int     $0x10
        ret
