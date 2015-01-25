;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          ReadFat12.asm                                               ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

;;----------------------------------------------------------------
;;    ルートディレクトリ領域を検索する。
;;
;;  @param [in] DI    検索するファイル名。
;;  @param [in] CX    領域内のエントリ数。
;;  @param [in] SI    領域の先頭アドレス。
;;  @return     SI
;;      -   ファイルが見つかった場合は、
;;          そのファイルのエントリのアドレスを返す。
;;      -   ファイルが見つからない場合はゼロを返す。
;;

FindRootDirectoryEntry:
        PUSH    CX
        MOV     CX, 11
        PUSH    DI
        PUSH    SI
        REPE    CMPSB
        POP     SI
        POP     DI
        JCXZ    .FOUND_FILE
        ADD     SI, 0x0020
        POP     CX
        LOOP    FindRootDirectoryEntry
        XOR     SI, SI          ;   エラー。
        RET
.FOUND_FILE:
        POP     CX
        RET

;;----------------------------------------------------------------
;;    ファイルの内容をメモリに転送する。
;;
;;   @param [in] SI      読み込むファイルの情報。
;;       ルートディレクトリ領域内から探しておく。
;;   @param[out] ES:BX   読み込んだデータの格納先。
;;

ReadFile:
        PUSH    DS
        PUSH    SI
        PUSH    BX

        XOR     AX, AX
        MOV     DS, AX

        MOV     AX, WORD [SI + 0x001A] ;   先頭クラスタ番号。
.READ_FILE_LOOP:
        PUSH    AX              ;   この値（クラスタ番号）は、
                                ;   後で使うので保存しておく。
        SUB     AX, 0x0002
        XOR     CX, CX
        MOV     CL, BYTE [SecPerCluter]
        MUL     AX
        ADD     AX, WORD [DataSector]
        MOV     SI, AX
        CALL    ReadSectors     ;   セクタの内容を読み込む。
                                ;   保存先 BX は自動更新。

        ;;   次のクラスタを調べる。
        POP     AX
        MOV     SI, AX
        SHR     SI, 1
        ADD     SI, AX
        ADD     SI, LOAD_ADDR_FAT

        TEST    AX, 0x0001
        MOV     AX, WORD [SI]
        JZ      .CLUSTER_EVEN
.CLUSTER_ODD:
        SHR     AX, 4
.CLUSTER_EVEN:
        AND     AX, 0x0FFF

        CMP     AX, 0xFF0
        JB      .READ_FILE_LOOP
.READ_FILE_FINISH:
        POP     BX
        POP     SI
        POP     DS
        RET

