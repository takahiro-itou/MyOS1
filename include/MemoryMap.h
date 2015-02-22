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
**      メモリマップ。
**
**      @file   include/MemoryMap.h
**/

#if !defined( MYOS1_KERNEL_INCLUDED_MEMORY_MAP_H )
#    define   MYOS1_KERNEL_INCLUDED_MEMORY_MAP_H

//========================================================================
//
//      ファイルシステム関連。
//

/**
**    ファイルアロケーションテーブルをロードするアドレス。
**/
#define     LOAD_ADDR_FAT           0x7E00

/**
**    ルートディレクトリ領域をロードするアドレス。
**/
#define     LOAD_ADDR_ROOTDIR       0xA200

#endif
