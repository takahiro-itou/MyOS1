;;  -*-  coding: utf-8  -*-

;;========================================================================
;;
;;          Boot Sector.
;;
;;========================================================================

[BITS 16]
ORG     0x7C00

;;----------------------------------------------------------------
;;
;;      BPB (Bios Parameter Block)
;;
                JMP     entrypoint
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
DriverNumber    DB      0
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
entrypoint:
        XOR     AX, AX
        MOV     SS, AX
        MOV     SP, 0x7C00
        MOV     DS, AX
        MOV     ES, AX
        MOV     SI, msg
putloop:
        LODSB
        TEST    AL, AL
        JE      fin
        MOV     AH, 0x0E
        MOV     BX, 15
        INT     0x10
        JMP     putloop
fin:
        HLT
        JMP     fin

msg:
        DB      0x0a, 0x0a
        DB      "Hello, World"
        DB      0x0a, 0x0a
        DB      0

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
;;
;;      Signature.
;;

        TIMES   510 - ($ - $$)  DB      0
        DB      0x55, 0xaa
