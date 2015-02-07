//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          ReadFloppy.s                                                **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/


//----------------------------------------------------------------
/**   セクタを読み込む。
**
**  @param [in] SI      先頭セクタ番号を、LBA で指定。
**  @param [in] CX      読み込むセクタ数。
**  @param[out] ES:BX   読み込んだデータを格納するアドレス。
**  @return     BX
**  @return     SI
**  @attention  破壊されるレジスタ：AX, CX, DX
**/

ReadSectors:
        PUSH    %DI
1:  //  @  .READ_SECTORS_LOOP:
        MOV     $0x0005,    %DI
        CALL    ReadOneSector
        ADDW    (BPB_BytesPerSector),   %BX
        INC     %SI
        LOOP    1b      ##  .READ_SECTORS_LOOP

        POP     %DI
        RET

//----------------------------------------------------------------
/**   セクタを読み込む。
**
**  @param [in] SI      読み込むセクタを、LBA で指定する。
**  @param [in] DI      最大リトライ回数。
**  @param[out] ES:BX   読み込んだデータを格納するアドレス。
**  @return
**  @attention  破壊されるレジスタ：AX, DX, DI
**/

ReadOneSector:
        PUSH    %BX
        PUSH    %CX

1:  //  @  .READ_RETRY_LOOP:
        MOV     %SI,   %AX
        CALL    ConvertLBAtoCHS
        MOV     $0x0201,    %AX
        MOVB    (BPB_DriveNumber),  %DL
        INT     $0x13
        JNC     2f      ##  .READ_SUCCESS

        XOR     %AX,   %AX
        XOR     %DX,   %DX
        INT     $0x13   /*  フロッピーをリセット。  */
        DEC     %DI
        JNZ     1b      ##  .READ_RETRY_LOOP

2:  //  @  .READ_SUCCESS:
        POP     %CX
        POP     %BX
        RET

//----------------------------------------------------------------
/**   ディスクアクセス時のアドレスを変換する。
**
**  @param [in] AX    LBA アドレスを指定。
**  @return     CH    シリンダ番号。
**  @return     CL    セクタ番号。
**  @return     DH    ヘッド番号。
**/

ConvertLBAtoCHS:
        XOR     %DX,   %DX
        DIVW    (BPB_SectorsPerTrack)
        INC     %DL

        MOV     %DL,   %CL      /*  セクタ番号。    */
        XOR     %DX,   %DX
        DIVW    (BPB_NumberOfHeads)
        MOV     %DL,   %DH      /*  ヘッド番号。    */
        MOV     %AL,   %CH      /*  シリンダ番号。  */
        RET
