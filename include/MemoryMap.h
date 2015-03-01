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

//========================================================================
//
//      カーネルイメージ関連。
//

/**
**    フォントファイルをロードするアドレス。
**/
#define     FONT_ASCII_ADDR         0x00002000

/**
**    カーネルを壱時的にロードしておくアドレス。
**/
#define     KERNEL0_TEMP_ADDR       0x00004000

/**
**    カーネルをロードするアドレス。
**/
#define     KERNEL0_BASE_ADDR       0x00100000

/**
**    割り込み記述子を配置するアドレス。
**
**  ベース：0x00268000 - 0x002687FF
**  サイズ：0x00000800 (2048)
**/
#define     INTGATE_DESCRIPTOR_ADDR     0x00268000

#endif
