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

ClusterID           EQU     0x0FF0
DataSector          EQU     0x0FF2

;;----------------------------------------------------------------
;;
;;      BPB (Bios Parameter Block)
;;
                JMP     ENTRY_POINT
                DB      0x90

OEMName         DB      "MyOS1   "
BytesPerSec     DW      512
SecPerCluter    DB      1
RsvdSecCount    DW      1
NumberOfFATs    DB      2
RootEntryCnt    DW      224
TotalSectors    DW      2880
MediaType       DB      0xF0
SizeOfFAT       DW      9
SectorPerTrack  DW      18
NumberOfHeads   DW      2
HiddenSectors   DD      0
TotalSector32   DD      0
DriveNumber     DB      0
Reserved1       DB      0
BootSignature   DB      0x29
VolSerialID     DD      0xFFFFFFFF
VolLabel        DB      "MyOS1      "
FileSystem      DB      "FAT12   "
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

        PUSH    DS
        PUSH    ES
        MOV     AX, 0x0100
        XOR     DI, DI
        MOV     DS, AX
        MOV     ES, AX
        MOV     BX, SI
        CALL    ReadFile
        XOR     SI, SI
        CALL    PutString
        POP     ES
        POP     DS

        POP     SI
        PUSH    MSG_LOADING_OK
LOAD_FAILURE:
        POP     SI
        CALL    PutString
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
;;;   セクタを読み込む。
;;
;;  @param [in,out] SI      先頭セクタ番号を、LBA で指定する。
;;  @param [in,out] CX      読み込むセクタ数。
;;  @param    [out] ES:BX   読み込んだデータを格納するアドレス。
;;
ReadSectors:
        PUSH    DI
READ_SECTORS_LOOP:
        MOV     DI, 0x0005
        CALL    ReadOneSector
        ADD     BX, WORD [BytesPerSec]
        INC     SI
        LOOP    READ_SECTORS_LOOP

        POP     DI
        RET

;;----------------------------------------------------------------
;;;   セクタを読み込む。
;;
;;  @param [in]     SI      読み込むセクタを、LBA で指定する。
;;  @param [in,out] DI      最大リトライ回数。
;;  @param    [out] ES:BX   読み込んだデータを格納するアドレス。
;;
ReadOneSector:
        PUSH    BX
        PUSH    CX
READ_RETRY_LOOP:
        MOV     AX, SI
        CALL    ConvertLBAtoCHS
        MOV     AX, 0x0201
        MOV     DL, BYTE [DriveNumber]
        INT     0x13
        JNC     READ_SUCCESS
        XOR     AX, AX
        XOR     DX, DX
        INT     0x13            ;   フロッピーをリセット
        DEC     DI
        JNZ     READ_RETRY_LOOP
READ_SUCCESS:
        POP     CX
        POP     BX
        RET

;;----------------------------------------------------------------
;;;   ディスクアクセス時のアドレスを変換する。
;;
;;  @param [in] AX   LBA アドレスを指定。
;;  @param[out] CH   シリンダ番号。
;;  @param[out] CL   セクタ番号。
;;  @param[out] DH   ヘッド番号。
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
;;   @param [in] BX      読み込むファイルの情報。
;;       ルートディレクトリ領域内から探しておく。
;;   @param[out] ES:DI   読み込んだデータの格納先。
;;
ReadFile:
        PUSH    DS
        PUSH    DI
        PUSH    BX

        XOR     AX, AX
        MOV     DS, AX

        MOV     AX, WORD [BX + 0x001A] ;   先頭クラスタ番号。
        MOV     [ClusterID], AX
        MOV     BX, DI
READ_FILE_LOOP:
        MOV     AX, WORD [ClusterID]
        SUB     AX, 0x0002
        XOR     CX, CX
        MOV     CL, BYTE [SecPerCluter]
        MUL     AX
        ADD     AX, WORD [DataSector]
        MOV     SI, AX
        CALL    ReadSectors     ;   セクタの内容を読み込む。
                                ;   データの保存先は自動更新。

        ;;   次のクラスタを調べる。
        MOV     AX, WORD [ClusterID]
        MOV     DI, AX
        SHR     DI, 1
        ADD     DI, AX
        ADD     DI, LOAD_ADDR_FAT

        MOV     DX, WORD [DI]
        TEST    AX, 0x0001
        JZ      CLUSTER_EVEN
CLUSTER_ODD:
        SHR     DX, 4
CLUSTER_EVEN:
        AND     DX, 0x0FFF
        MOV     WORD [ClusterID], DX
        CMP     DX, 0xFF0
        JB      READ_FILE_LOOP
READ_FILE_FINISH:
        POP     BX
        POP     DI
        POP     DS
        RET

;;----------------------------------------------------------------
;;;     画面に文字列を表示する。
;;
;;
PutString:
        PUSH    BX
PUT_CHAR_LOOP:
        LODSB
        TEST    AL, AL
        JE      PUT_CHAR_FIN
        CALL    PutChar
        JMP     PUT_CHAR_LOOP
PUT_CHAR_FIN:
        POP     BX
        RET

;;----------------------------------------------------------------
;;;     画面に壱文字を表示する。
;;
;;  @param [in] AL
;;
PutChar:
        MOV     AH, 0x0E
        MOV     BX, 15
        INT     0x10
        RET

;;----------------------------------------------------------------
;;
;;      Signature.
;;

        TIMES   510 - ($ - $$)  DB      0
        DB      0x55, 0xaa
