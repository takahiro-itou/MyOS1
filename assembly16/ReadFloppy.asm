;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          ReadFloppy.asm                                              ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

;;----------------------------------------------------------------
;;    セクタを読み込む。
;;
;;  @param [in] SI      先頭セクタ番号を、LBA で指定する。
;;  @param [in] CX      読み込むセクタ数。
;;  @param[out] ES:BX   読み込んだデータを格納するアドレス。
;;  @return     BX
;;  @return     SI
;;  @attention  破壊されるレジスタ：AX, CX, DX
;;
ReadSectors:
        PUSH    DI
.READ_SECTORS_LOOP:
        MOV     DI, 0x0005
        CALL    ReadOneSector
        ADD     BX, WORD [BytesPerSec]
        INC     SI
        LOOP    .READ_SECTORS_LOOP

        POP     DI
        RET

;;----------------------------------------------------------------
;;    セクタを読み込む。
;;
;;  @param [in] SI      読み込むセクタを、LBA で指定する。
;;  @param [in] DI      最大リトライ回数。
;;  @param[out] ES:BX   読み込んだデータを格納するアドレス。
;;  @return
;;  @attention  破壊されるレジスタ：AX, DX, DI
;;
ReadOneSector:
        PUSH    BX
        PUSH    CX
.READ_RETRY_LOOP:
        MOV     AX, SI
        CALL    ConvertLBAtoCHS
        MOV     AX, 0x0201
        MOV     DL, BYTE [DriveNumber]
        INT     0x13
        JNC     .READ_SUCCESS
        XOR     AX, AX
        XOR     DX, DX
        INT     0x13            ;   フロッピーをリセット
        DEC     DI
        JNZ     .READ_RETRY_LOOP
.READ_SUCCESS:
        POP     CX
        POP     BX
        RET

;;----------------------------------------------------------------
;;    ディスクアクセス時のアドレスを変換する。
;;
;;  @param [in] AX   LBA アドレスを指定。
;;  @return     CH   シリンダ番号。
;;  @return     CL   セクタ番号。
;;  @return     DH   ヘッド番号。
;;
ConvertLBAtoCHS:
        XOR     DX, DX
        DIV     WORD [SectorPerTrack]
        INC     DL
        MOV     CL, DL          ;   セクタ番号
        XOR     DX, DX
        DIV     WORD [NumberOfHeads]
        MOV     DH, DL          ;   ヘッド番号。
        MOV     CH, AL          ;   シリンダ番号
        RET
