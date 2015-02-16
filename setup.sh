#! /bin/bash

ENVBLD='cygwin'
CURDIR=`pwd`

for dir in . assembly assembly/bootsector assembly/ipl kernel
do
    cd  ${dir}  &&  rm -f  Makefile  \
        &&  ln -s  Makefile.${ENVBLD}  Makefile
    cd  ${CURDIR}
done

