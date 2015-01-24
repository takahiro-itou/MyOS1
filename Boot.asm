        ;;  -*-  coding: utf-8  -*-

;;========================================================================
;;
;;          Boot Sector.
;;
;;========================================================================

[BITS 16]
ORG     0x7C00

LOAD_ADDR_FAT       EQU     0x7E00
LOAD_ADDR_ROOTDIR   EQU     0xA200

DataSector          EQU     0x0F00

;;----------------------------------------------------------------
;;
;;      BPB (Bios Parameter Block)
;;
        JMP     ENTRY_POINT
        DB      0x90

%include    "assembly16/Fat12Bpb.inc"

        TIMES   2   DB  0

;;----------------------------------------------------------------
;;
;;      Entry Point.
;;
ENTRY_POINT:
        XOR     AX, AX
        MOV     SS, AX
        MOV     SP, 0x7C00
        MOV     DS, AX
        MOV     ES, AX

        PUSH    MSG_FILE_NOT_FOUND

        CALL    LoadFAT

        MOV     SI, LOAD_ADDR_ROOTDIR
        MOV     CX, WORD [RootEntryCnt]
        MOV     DI, IplImageName
        CALL    FindRootDirectoryEntry

        TEST    SI, SI
        JZ      LOAD_FAILURE

        MOV     BX, 0x1000
        PUSH    BX
        CALL    ReadFile
        POP     SI
        CALL    WriteString

        POP     SI
        PUSH    MSG_LOADING_OK
LOAD_FAILURE:
        POP     SI
        CALL    WriteString
HALT_LOOP:
        HLT
        JMP     HALT_LOOP

MSG_LOADING_OK:
        DB      "Loading OK."
        DB      0
MSG_FILE_NOT_FOUND:
        DB      "IPL Not Found."
        DB      0

IplImageName:
        DB      "IPL     BIN", 0

;;----------------------------------------------------------------
;;
;;
LoadFAT:
        MOV     AX, WORD [SizeOfFAT]
        MUL     BYTE [NumberOfFATs]
        MOV     CX, AX          ;   読み込むセクタ数。
        MOV     SI, WORD [RsvdSecCount]
        MOV     BX, LOAD_ADDR_FAT
        CALL    ReadSectors
LOAD_ROOT_DIR_ENTRY:
        MOV     AX, 0x0020
        MUL     WORD [RootEntryCnt]
        ADD     AX, WORD [BytesPerSec]
        DEC     AX
        DIV     WORD [BytesPerSec]
        MOV     CX, AX          ;   読み込むセクタ数。
        MOV     BX, LOAD_ADDR_ROOTDIR
        CALL    ReadSectors

        MOV     WORD [DataSector], SI
        RET

;;----------------------------------------------------------------
;;
;;      フロッピーディスク読み込み関連。
;;

%include    "assembly16/ReadFloppy.asm"

;;----------------------------------------------------------------
;;;   ルートディレクトリ領域を検索する。
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
        JCXZ    FOUND_FILE
        ADD     SI, 0x0020
        POP     CX
        LOOP    FindRootDirectoryEntry
        XOR     SI, SI          ;   エラー。
        RET

FOUND_FILE:
        POP     CX
        RET

;;----------------------------------------------------------------
;;;   ファイルの内容をメモリに転送する。
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
READ_FILE_LOOP:
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
        JZ      CLUSTER_EVEN
CLUSTER_ODD:
        SHR     AX, 4
CLUSTER_EVEN:
        AND     AX, 0x0FFF
        CMP     AX, 0xFF0
        JB      READ_FILE_LOOP
READ_FILE_FINISH:
        POP     BX
        POP     SI
        POP     DS
        RET

;;----------------------------------------------------------------
;;
;;      文字列表示関連。
;;

%include    "assembly16/WriteString.asm"

;;----------------------------------------------------------------
;;
;;      Signature.
;;

        TIMES   510 - ($ - $$)  DB      0
        DB      0x55, 0xaa
