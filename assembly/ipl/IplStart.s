//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**          IplStart.s                                                  **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

        .CODE16

.section    .text

.equ    CODE_SEG             ,  0x0010
.equ    DATA_SEG             ,  0x0018
.equ    KERNEL_TEMP_ADDR     ,  0x00002000

        JMP         ENTRY_POINT
        .BYTE       0x90

.include    "Fat12Bpb.inc"

        .space      0x12,   0x00

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:

        XOR     %AX,    %AX
        MOV     %AX,    %DS
        MOV     %AX,    %ES

        MOV     $MSG_START_LOADING,     %SI
        CALL    WriteString

        MOV     $MSG_FIND_KERNEL,       %SI
        CALL    WriteString

        MOV     $LOAD_ADDR_ROOTDIR,     %SI
        MOVW    (BPB_RootEntryCount),   %CX
        MOV     $.KERNEL_IMAGE_NAME,    %DI
        CALL    FindRootDirectoryEntry
        TEST    %SI,    %SI
        JZ      .SHOW_ERROR

        PUSH    %SI
        CALL    .SHOW_OK_MESSAGE

        MOV     $MSG_READ_KERNEL,       %SI
        CALL    WriteString

        POP     %SI
        MOV     $KERNEL_TEMP_ADDR,      %BX
        CALL    ReadFile
        CALL    .SHOW_OK_MESSAGE

        CALL    _enableA20
        MOV     $MSG_ENABLE_A20,        %SI
        CALL    WriteString

        CLI

        CALL    _setupGDT
        MOV     $MSG_SETUP_GDT,         %SI
        CALL    WriteString

        MOV     $MSG_PROTECT_START,     %SI
        CALL    WriteString

        MOV     %CR0,   %EAX
        OR      $0x01,  %EAX
        MOV     %EAX,   %CR0
        JMP     .PIPE_LINE_FLUSH

.PIPE_LINE_FLUSH:
        MOV     $DATA_SEG,  %AX
        MOV     %AX,        %SS
        MOV     %AX,        %DS
        MOV     %AX,        %ES
        MOV     %AX,        %FS
        MOV     %AX,        %GS

        LJMP    $CODE_SEG , $_startProtet32

.SHOW_ERROR:
        MOV     $MSG_FAILURE,   %SI
        CALL    WriteString

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.SHOW_OK_MESSAGE:
        PUSH    %SI
        MOV     $MSG_SUCCESS,   %SI
        CALL    WriteString
        POP     %SI
        RET

.KERNEL_IMAGE_NAME:
        .STRING     "KERNEL0 IMG"

//----------------------------------------------------------------
//
//      ????????????????????????????????????????????????
//

.include    "ReadFloppy.s"

//----------------------------------------------------------------
//
//      ???????????????????????????????????????
//

.include    "ReadFat12.s"

//----------------------------------------------------------------
//
//      ????????????????????????
//

.include    "WriteString.s"

.section    .data

//----------------------------------------------------------------
//
//      ??????????????????
//

MSG_FAILURE:
        .STRING     " ERROR\r\n"
MSG_SUCCESS:
        .STRING     " OK\r\n"

MSG_START_LOADING:
        .STRING     "Loading Operating System\r\n"
MSG_FIND_KERNEL:
        .STRING     "Find Kernel Image ..."
MSG_READ_KERNEL:
        .STRING     "Read Kernel Image ..."
MSG_ENABLE_A20:
        .STRING     "Enabled A-20.\r\n"
MSG_SETUP_GDT:
        .STRING     "Maked Global Descriptor Table.\r\n"
MSG_PROTECT_START:
        .STRING     "Start Protect Mode ...\r\n"
