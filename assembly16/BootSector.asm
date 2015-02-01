;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          BootSector.asm                                              ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
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

        TIMES   0x12    DB  0

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

        CALL    LoadFAT

        MOV     SI, LOAD_ADDR_ROOTDIR
        MOV     CX, WORD [RootEntryCnt]
        MOV     DI, .IPL_IMAGE_NAME
        CALL    FindRootDirectoryEntry

        TEST    SI, SI
        JZ      .LOAD_FAILURE

        MOV     BX, 0x1000
        PUSH    BX
        CALL    ReadFile
        JMP     BX
.LOAD_FAILURE:
        MOV     SI, .MSG_FILE_NOT_FOUND
        CALL    WriteString
.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.MSG_FILE_NOT_FOUND:
        DB      "IPL Not Found.", 0

.IPL_IMAGE_NAME:
        DB      "IPLF12  BIN", 0

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
.LOAD_ROOT_DIR_ENTRY:
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
;;
;;      ファイルシステム解析関連。
;;

%include    "assembly16/ReadFat12.asm"

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
