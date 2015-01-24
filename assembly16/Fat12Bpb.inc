;;  -*-  coding: utf-8; mode: asm  -*-  ;;
;;======================================================================;;
;;                                                                      ;;
;;          Fat12Bpb.inc                                                ;;
;;                                                                      ;;
;;          Copyright (C), 2015-2015, Takahiro Itou                     ;;
;;          All Rights Reserved.                                        ;;
;;                                                                      ;;
;;========================================================================

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
