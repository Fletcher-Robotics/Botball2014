#!/bin/bash
gcc -shared -fPIC -o $(basename $1 .c).so -I/usr/local/include -llua -lkovan $1
