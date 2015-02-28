//  -*-  coding: utf-8; mode: c++  -*-  //
/*************************************************************************
**                                                                      **
**                      --  My Operating System --                      **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      記述子。
**
**      @file   include/Descriptors.h
**/

#if !defined( MYOS1_KERNEL_INCLUDED_DESCRIPTORS_H )
#    define   MYOS1_KERNEL_INCLUDED_DESCRIPTORS_H

//========================================================================
//
//      セグメント記述子を設定するマクロ。
//

#define     SET_GDT_B5(flags, type)     \
        ( (flags & 0xF0) | (type & 0x0F) )

#define     SET_GDT_B6(flags, limit)    \
        ( ((flags >> 8) & 0xFF) | ((limit >> 28) & 0x0F) )

#define     SET_GDT_ENTRY(flags, type, base, limit)     \
        .word   ((limit >> 12) & 0xFFFF);   /*  Limit Low           */  \
        .word   (base & 0xFFFF);            /*  Base Address Low    */  \
        .byte   ((base >> 16) & 0xFF);      /*  Base Address Mid    */  \
        .byte   SET_GDT_B5(flags, type);    /*  Flags & Type        */  \
        .byte   SET_GDT_B6(flags, limit);   /*  Flags & Limit High  */  \
        .byte   ((base >> 24) & 0xFF);      /*  Base Address High   */

#define     GDT_COMBINE_FLAGS(gran, db, x64, avl, present, dpl, sys)    \
        ( (gran << 15) | (db << 14) | (x64 << 13) | (avl << 12)         \
        | (present << 7) | (dpl << 5) | (sys << 4) )


#if !defined( MYOS1_INCLUDE_FROM_ASM )

void    _setupGDT(void);
void    _setupIDT(void);

#endif  //  if !defined( MYOS1_INCLUDE_FROM_ASM )
#endif
