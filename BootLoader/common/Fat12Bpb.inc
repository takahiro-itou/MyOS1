//  -*-  coding: utf-8; mode: asm  -*-  //
/*************************************************************************
**                                                                      **
**                      --  My Operating System --                      **
**                                                                      **
**          Copyright (C), 2015-2015, Takahiro Itou                     **
**          All Rights Reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      ディスクパラメータ。
**
**      @file   common/Fat12Bpb.inc
**/

BPB_OEMName:            .ASCII  "MyOS1   "
BPB_BytesPerSector:     .WORD   512
BPB_SectorsPerCluster:  .BYTE   1
BPB_RsvdSectorCount:    .WORD   1
BPB_NumberOfFATs:       .BYTE   2
BPB_RootEntryCount:     .WORD   224
BPB_TotalSectors:       .WORD   2880
BPB_MediaType:          .BYTE   0xF0
BPB_SizeOfFAT:          .WORD   9
BPB_SectorsPerTrack:    .WORD   18
BPB_NumberOfHeads:      .WORD   2
BPB_HiddenSectors:      .INT    0
BPB_TotalSectors32:     .INT    0
BPB_DriveNumber:        .BYTE   0
BPB_Reserved1:          .BYTE   0
BPB_BootSignature:      .BYTE   0x29
BPB_VolumeSerialID:     .INT    0xFFFFFFFF
BPB_VolumeLabel:        .ASCII  "MyOS1      "
BPB_FileSystem:         .ASCII  "FAT12   "
