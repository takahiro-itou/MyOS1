
AC_PREREQ([2.69])

AC_INIT([MyOS1], [1.0])

AC_CONFIG_AUX_DIR([.config])

AM_INIT_AUTOMAKE

AC_CONFIG_SRCDIR([BootLoader])
AC_CONFIG_HEADER([include/config.h])

AC_PROG_CC
AM_PROG_AS

AC_CONFIG_FILES([
    Makefile
    BootLoader/Makefile
    BootLoader/bootsector/Makefile
    BootLoader/initloader/Makefile
    src/Makefile
])

AC_OUTPUT

