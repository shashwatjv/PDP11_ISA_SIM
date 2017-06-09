#!/bin/bash

$file=
echo "Compiling" $1
../bin/macro11 $1.mac -o $1.obj -l $1.lst
../bin/obj2ascii $1.obj $1.ascii
