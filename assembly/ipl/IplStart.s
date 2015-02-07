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
        .ORG    0x0000

//----------------------------------------------------------------
//
//      Entry Point.
//

ENTRY_POINT:

        //  ダミーのエントリポイント。
        MOV     $MSG_START_LOADING,     %SI
        CALL    WriteString

.HALT_LOOP:
        HLT
        JMP     .HALT_LOOP

.include    "../../bootsector/WriteString.s"

MSG_START_LOADING:
        .STRING     "Hello, World!\r\n"
