#!/bin/bash
gcc -o luarunner -I/usr/local/include -O2 -I/kovan/devel/lib -include math.h -include kovan/kovan.h -include target.c luarunner.c -llua -lm -lkovan -ldl -Wl,-E
rm /kovan/bin/luarunner/luarunner
mv luarunner /kovan/bin/luarunner/

