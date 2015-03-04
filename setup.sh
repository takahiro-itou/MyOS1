#! /bin/bash

ENVBLD='cygwin'
CURDIR=`pwd`

for dir in . BootLoader BootLoader/bootsector BootLoader/initloader \
             data src src/initkernel
do
    cd  ${dir}  &&  rm -f  Makefile  \
        &&  ln -s  Makefile.${ENVBLD}  Makefile
    cd  ${CURDIR}
done

