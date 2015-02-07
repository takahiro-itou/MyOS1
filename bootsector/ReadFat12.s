//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          ReadFat12.s                                                 **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/


//----------------------------------------------------------------
/**   ルートディレクトリ領域内を検索する。
**
**  @param [in] DI    検索するファイル名。
**  @param [in] CX    領域内のエントリ数。
**  @param [in] SI    領域の先頭アドレス。
**  @return     SI
**      -   ファイルが見つかった場合は、
**          そのファイルのエントリのアドレスを返す。
**      -   ファイルが見つからない場合はゼロを返す。
**  @attention  破壊されるレジスタ：
**/

FindRootDirectoryEntry:
        PUSH    %CX
        MOV     $11,    %CX     /*  ファイル名は常に11バイト。  **/
        PUSH    %DI
        PUSH    %SI
        REPE    CMPSB
        POP     %SI
        POP     %DI
        JCXZ    1f      ##  .FOUND_FILE
        ADD     $0x0020,    %SI
        POP     %CX
        LOOP    FindRootDirectoryEntry

        XOR     %SI,    %SI     /*  見つからなかった。  **/
        RET

1:  //  @  .FOUND_FILE:
        POP     %CX
        RET


//----------------------------------------------------------------
/**   ファイルの内容をメモリに転送する。
**
**  @param [in] SI      読み込むファイルの情報。
**      ルートディレクトリ領域内から探しておく。
**  @param [in] BP      データ領域の先頭セクタ番号。
**  @param[out] ES:BX   読み込んだデータの格納先。
**  @return
**  @attention  破壊されるレジスタ：AX, CX
**/

ReadFile:
        PUSH    %DS
        PUSH    %SI
        PUSH    %BX

        XOR     %AX,    %AX
        MOV     %AX,    %DS

        MOVW    0x001A(%SI),    %AX

1:  //  @  .READ_FILE_LOOP:
        PUSH    %AX     /*  クラスタ番号は、後で使うので保存。  */
        SUB     $0x0002,    %AX
        XOR     %CX,        %CX
        MOVB    (BPB_SectorsPerCluster),    %CL
        MUL     %AX
        ADDW    (DataSector),   %AX
        MOV     %AX,        %SI
        CALL    ReadSectors

        /*  次のクラスタを読み込む。    */
        POP     %AX
        MOV     %AX,        %SI
        SHR     $1,         %SI
        ADD     %AX,        %SI
        ADD     $LOAD_ADDR_FAT,     %SI

        TEST    $0x0001,    %AX
        MOVW    (%SI),      %AX
        JZ      3f      ##  .CLUSTER_EVEN

2:  //  @  .CLUSTER_ODD:
        SHR     $4,         %AX
3:  //  @  .CLUSTER_EVEN:
        AND     $0x0FFF,    %AX

        CMP     $0x0FF0,    %AX
        JB      1b      ##  .READ_FILE_LOOP

4:  //  @  .READ_FILE_FINISH:
        POP     %BX
        POP     %SI
        POP     %DS
        RET
