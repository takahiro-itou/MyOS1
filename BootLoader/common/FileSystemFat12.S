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
**      ファイルシステム解析。
**
**      @file   common/FileSystemFat12.S
**/

//----------------------------------------------------------------
/**   ルートディレクトリ領域内を検索する。
**
**  @param [in] di      検索するファイル名。
**  @param [in] cx      領域内のエントリ数。
**  @param [in] si      領域の先頭アドレス。
**  @param [in] bp      データ領域の先頭セクタ番号。
**  @param[out] es:bx   読み込んだデータの格納先。
**  @return     si
**      -   ファイルが見つかった場合は、
**          そのファイルのエントリのアドレスを返す。
**      -   ファイルが見つからない場合はゼロを返す。
**  @attention  破壊されるレジスタ：
**/

FindRootDirectoryEntry:
        pushw   %cx
        movw    $11,  %cx       /*  ファイル名は11バイト。  */
        pushw   %di
        pushw   %si
        repe    cmpsb
        popw    %si
        popw    %di
        jcxz    1f      ##  .FOUND_FILE
        addw    $0x0020,  %si
        pop     %cx
        loop    FindRootDirectoryEntry

        xor     %si,  %si       /*  見つからなかった。  */
        ret

1:  //  @  .FOUND_FILE:
        popw    %cx
        ret

//----------------------------------------------------------------
/**   ファイルの内容をメモリに転送する。
**
**  @param [in] si      読み込むファイルの情報。
**      ルートディレクトリ領域内から探しておく。
**  @param [in] bp      データ領域の先頭セクタ番号。
**  @param[out] es:bx   読み込んだデータの格納先。
**  @return     ax      読み込んだバイト数。
**  @attention  破壊されるレジスタ：cx
**/

ReadFile:
        pushw   %ds
        push    %si
        push    %bx

        xor     %ax,  %ax
        movw    %ax,  %ds
        movw    0x001A(%si),  %ax

1:  //  @  .READ_FILE_LOOP:
        pushw   %ax     /*  クラスタ番号は、後で使うので保存。  */
        subw    $0x0002,  %ax
        xorw    %cx,  %cx
        movb    (BPB_SectorsPerCluster),  %cl
        mul     %cx
        addw    %bp,  %ax
        movw    %ax,  %si
        call    ReadSectors     /*  読み込み先 BX の値は自動更新。  */

        /*  次のクラスタを読み込む。    */
        popw    %ax
        movw    %ax,  %si
        shr     $1,   %si
        addw    %ax,  %si
        addw    $LOAD_ADDR_FAT,  %si

        testw   $0x0001,  %ax
        movw    (%si),    %ax
        jz      3f      ##  .CLUSTER_EVEN

2:  //  @  .CLUSTER_ODD:
        shr     $4,       %ax
3:  //  @  .CLUSTER_EVEN:
        andw    $0x0FFF,  %ax

        cmpw    $0x0FF0,  %ax
        jb      1b      ##  .READ_FILE_LOOP

4:  //  @  .READ_FILE_FINISH:
        movw    %bx,  %ax
        popw    %bx
        subw    %bx,  %ax
        popw    %si
        popw    %ds
        ret
