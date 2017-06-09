#!/bin/bash
#
#  Wrapper script to compile the macro11 assembly code
#
# to be invoked as:
#	./compile.sh <filename>
#	example- ./compile.sh fib
#
echo "Compiling" $1
../bin/macro11 $1.mac -o $1.obj -l $1.lst
../bin/obj2ascii $1.obj $1.ascii
