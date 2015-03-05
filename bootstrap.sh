#! /bin/bash -x

mkdir -p .config  \
  &&  aclocal  -I  .config  \
  &&  autoheader  \
  &&  automake  --add-missing  --copy  --foreign  \
  &&  autoconf

