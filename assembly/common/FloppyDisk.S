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
**      フロッピーディスクアクセス。
**
**      @file   assembly/common/FloppyDisk.S
**/

//----------------------------------------------------------------
/**   セクタを読み込む。
**
**  @param [in] si      先頭セクタ番号を、LBA で指定。
**  @param [in] cx      読み込むセクタ数。
**  @param[out] es:bx   読み込んだデータを格納するアドレス。
**  @return     bx
**  @return     si
**  @attention  破壊されるレジスタ：ax, cx, dx
**/

ReadSectors:
        pushw   %di
1:  //  @  .READ_SECTORS_LOOP:
        movw    $0x0005,  %di
        call    ReadOneSector
        addw    (BPB_BytesPerSector),  %bx
        inc     %si
        loop    1b      ##  .READ_SECTORS_LOOP

        pop     %di
        ret

//----------------------------------------------------------------
/**   セクタを読み込む。
**
**  @param [in] si      読み込むセクタを、LBA で指定する。
**  @param [in] di      最大リトライ回数。
**  @param[out] es:bx   読み込んだデータを格納するアドレス。
**  @return
**  @attention  破壊されるレジスタ：ax, dx, di
**/

ReadOneSector:
        pushw   %bx
        pushw   %cx

1:  //  @  .READ_RETRY_LOOP:
        movw    %si,  %ax
        call    ConvertLBAtoCHS
        movw    $0x0201,  %ax
        movb    (BPB_DriveNumber),  %dl
        int     $0x13
        jnc     2f      ##  .READ_SUCCESS

        xor     %ax,  %ax
        xor     %dx,  %dx
        int     $0x13       /*  フロッピーをリセット。  */
        dec     %di
        jnz     1b      ##  .READ_RETRY_LOOP

2:  //  @  .READ_SUCCESS:
        popw    %cx
        popw    %bx
        ret

//----------------------------------------------------------------
/**   ディスクアクセス時のアドレスを変換する。
**
**  @param [in] ax    LBA アドレスを指定。
**  @return     ch    シリンダ番号。
**  @return     cl    セクタ番号。
**  @return     dh    ヘッド番号。
**  @attention  破壊されるレジスタ：ax, dx
**/

ConvertLBAtoCHS:
        xorw    %dx,  %dx
        divw    (BPB_SectorsPerTrack)
        inc     %dl

        movb    %dl,  %cl       /*  セクタ番号。    */
        xorw    %dx,  %dx
        divw    (BPB_NumberOfHeads)

        movb    %dl,  %dh       /*  ヘッド番号。    */
        movb    %al,  %ch       /*  シリンダ番号。  */
        ret
