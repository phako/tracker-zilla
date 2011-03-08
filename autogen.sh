#!/bin/sh

mkdir m4
autoreconf -if
./configure --enable-vala --enable-maintainer-mode $*
