
AC_PREREQ([2.69])

AC_INIT([MyOS1], [1.0])

AC_CONFIG_AUX_DIR([.config])

AM_INIT_AUTOMAKE

AC_CONFIG_SRCDIR([BootLoader])
AC_CONFIG_HEADER([include/config.h])

: ${AS:=/usr/bin/i686-pc-linux-gnu-as}
: ${CC:=/usr/bin/i686-pc-linux-gnu-gcc}
: ${LD:=/usr/bin/i686-pc-linux-gnu-ld}

AC_PROG_CC
AM_PROG_AS

AC_SUBST(LD)

AC_CONFIG_FILES([
    Makefile
    BootLoader/Makefile
    BootLoader/bootsector/Makefile
    BootLoader/initloader/Makefile
    data/Makefile
    src/Makefile
    src/initkernel/Makefile
])

AC_OUTPUT

