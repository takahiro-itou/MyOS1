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
**      コンソール関連。
**
**      @file   common/Console32.S
**/

#define     VRAM_ADDR   0x000B8000

//----------------------------------------------------------------
/**   画面をクリアする。
**
**  @return     無し。
**  @attention  破壊されるレジスタ：eax, ecx
**/

clearConsole:
        pushl   %edi

        movl    $VRAM_ADDR,  %edi
        movw    $0x0020,     %ax
        movl    $80 * 25,    %ecx
        rep     stosw

        popl    %edi
        ret

//----------------------------------------------------------------
/**   画面をスクロールする。
**
**  @param [in] ecx   スクロール行数。
**  @return     無し。
**  @attention  破壊されるレジスタ：無し。
**/

scrollConsole:
        pushl   %eax
        pushl   %ecx
        pushl   %esi
        pushl   %edi

        /*  スクロール行数に 80 を掛ける。  */
        leal    (%ecx, %ecx, 4),  %eax
        shll    $0x04,  %eax

        movl    $VRAM_ADDR,  %edi
        leal    (%edi, %eax, 2),  %esi
        movl    $80 * 25,  %ecx
        subl    %eax,  %ecx
        rep     movsw

        movl    %eax,  %ecx
        movl    $0x0020,  %eax
        rep     stosw

        popl    %edi
        popl    %esi
        popl    %ecx
        popl    %eax
        ret

//----------------------------------------------------------------
/**   画面に文字列を表示する。
**
**  @param [in] ah        表示する文字の属性。
**  @param [in] ds:esi    表示する文字列。
**  @param [in] ebx       表示する位置（水平方向）。
**  @param [in] edx       表示する位置（垂直位置）。
**  @return     ebx       次の表示位置（水平方向）。
**  @return     edx       次の表示位置（垂直方向）。
**  @attention  破壊されるレジスタ：無し。
**/

writeText:
        pushl   %eax
        pushl   %ecx
        pushl   %edi
        pushl   %esi

        call    ._calcVramAddrToWrite

1:  //  @  .WRITE_CHAR_LOOP:
        lodsb   /*  movb    %ds:(%esi),  %al;   INC  %esi   */
        testb   %al,  %al
        je      2f      ##  .WRITE_CHAR_FIN

        testb   $0xE0,  %al
        jnz     3f      ##  .WRITE_CHAR_IMM

.WRITE_CTRL_CHAR:
        cmpb    $0x0A,  %al
        je      4f      ##  .GOTO_NEXT_LINE
        cmpb    $0x0D,  %al
        jne     3f      ##  .WRITE_CHAR_IMM
.WRITE_CTRL_CHAR_OD:
        /*  キャリッジリターン。    */
        xorl    %ebx,  %ebx
        jmp     5f      ##  .CALC_VRAM_ADDR

3:  //  @  .WRITE_CHAR_IMM:
        stosw   /*  movw    %ax,  %es:(%edi);   addl    $2,  %edi   */

        incl    %ebx
        cmpl    $80,   %ebx
        jl      1b      ##  .WRITE_CHAR_LOOP
        xorl    %ebx,  %ebx

4:  //  @  .GOTO_NEXT_LINE
        incl    %edx
        cmpl    $25,   %edx
        jl      5f      ##  .CALC_VRAM_ADDR
        movl    $1,    %ecx
        call    scrollConsole
        subl    %ecx,  %edx
5:  //  @  .CALC_VRAM_ADDR
        call    ._calcVramAddrToWrite
        jmp     1b      ##  .WRITE_CHAR_LOOP

2:  //  @  .WRITE_CHAR_FIN:
        popl    %esi
        popl    %edi
        popl    %ecx
        popl    %eax
        ret

//----------------------------------------------------------------
/**   画面にバイナリダンプを行う。
**
**  @param [in] ah        表示する文字の属性。
**  @param [in] ds:esi    表示するデータ。
**  @param [in] ebx       表示する位置（水平方向）。
**  @param [in] edx       表示する位置（垂直位置）。
**  @return     ebx       次の表示位置（水平方向）。
**  @return     edx       次の表示位置（垂直方向）。
**  @attention  破壊されるレジスタ：無し。
**/

writeHexDump:
        pushl   %eax
        pushl   %ecx
        pushl   %ebp
        pushl   %esi
        pushl   %edi

        call    ._calcVramAddrToWrite
        movl    %edx,  %ebp
        movl    %eax,  %edx

1:  //  @  .DUMP_BYTE_LOOP:
        lodsb
        call    writeByteHex
        movw    $0x20,  %ax
        stosw
        addl    $0x03,  %ebx

        cmpl    $80,   %ebx
        jl      3f      ##  .DUMP_BYTE_CONTINUE
        subl    $80,   %ebx

        pushl   %edx
        movl    %ebp,  %edx
        incl    %edx
        cmpl    $25,   %edx
        jl      2f      ##  .CALC_VRAM_ADDR

        pushl   %ecx
        movl    $1,  %ecx
        call    scrollConsole
        subl    %ecx,  %edx
        popl    %ecx
2:  //  @  .CALC_VRAM_ADDR:
        call    ._calcVramAddrToWrite
        movl    %edx,  %ebp
        popl    %edx

3:  //  @  .DUMP_BYTE_CONTINUE:
        loopl   1b      ##  .DUMP_BYTE_LOOP
        movl    %ebp,  %edx
        popl    %edi
        popl    %esi
        popl    %ebp
        popl    %ecx
        popl    %eax
        ret

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] al    表示する数値。
**  @param [in] dh    表示属性。
**  @param [in] edi   表示する位置。
**  @return     edi   次の表示位置。
**  @attention  破壊されるレジスタ：無し。
**/

writeByteHex:
        pushl   %eax
        pushl   %ecx
        xchgl   %ecx,  %eax

        movl    %ecx,  %eax
        shrl    $4,    %eax
        movb    %dh,   %ah
        call    ._writeHexValue

        movl    %ecx,  %eax
        movb    %dh,   %ah
        call    ._writeHexValue

        popl    %ecx
        popl    %eax
        ret

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] ax    表示する数値。
**  @param [in] dh    表示属性。
**  @param [in] edi   表示する位置。
**  @return     edi   次の表示位置。
**  @attention  破壊されるレジスタ：無し。
**/

writeWordHex:
        pushl   %eax
        pushl   %ecx
        xchgl   %eax,  %ecx

        movl    %ecx,  %eax
        shrl    $12,   %eax
        movb    %dh,   %ah
        call    ._writeHexValue
        movl    %ecx,  %eax
        shrl    $8,    %eax
        movb    %dh,   %ah
        call    ._writeHexValue
        movl    %ecx,  %eax
        shrl    $4,    %eax
        movb    %dh,   %ah
        call    ._writeHexValue
        movl    %ecx,  %eax
        movb    %dh,   %ah
        call    ._writeHexValue

        popl    %ecx
        popl    %eax
        ret

//----------------------------------------------------------------
/**   表示位置からデータを書き込むアドレスを計算する。
**
**  @param [in] ebx   表示する位置（水平方向）。
**  @param [in] edx   表示する位置（垂直位置）。
**  @return     edi   書き込むアドレス。
**  @attention  破壊されるレジスタ：無し。
**/
._calcVramAddrToWrite:
        pushl   %eax

        leal    (%edx, %edx, 4),  %eax
        shll    $0x04,  %eax
        addl    %ebx,   %eax
        movl    $VRAM_ADDR,  %edi
        leal    (%edi, %eax, 2),  %edi

        popl    %eax
        ret

//----------------------------------------------------------------
/**   画面に数値を表示する。
**
**  @param [in] al    表示する数値。
**  @param [in] ah    表示属性。
**  @param [in] edi   表示する位置。
**  @return     edi   次の表示位置。
**  @attention  破壊されるレジスタ：ax
**/

._writeHexValue:
        andb    $0x0F,  %al
        cmpb    $0x0A,  %al
        jl      1f

        addb    $0x41 - 0x0A,  %al
        jmp     2f
1:
        addb    $0x30,  %al
2:
        stosw
        ret
