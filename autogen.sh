#!/bin/sh

mkdir -p m4
autoreconf -if
./configure --enable-vala --enable-maintainer-mode $*
