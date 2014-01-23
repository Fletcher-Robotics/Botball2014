"""
Fletcher Botball Compiler.

Usage:
  compile.py auto <target>
  compile.py manual <target> [<extras>...]
  compile.py -h | --help

Options:
  -h --help    Show this screen.
"""

import os
import sys
import subprocess
from docopt import docopt
from functools import partial

COMPILE_BASE = ['gcc', '-include', 'stdio.h', '-include', 'kovan/kovan.h', '-c']
LINK_BASE = ['gcc', '-lkovan', '-lm', '-lpthread']


# Actual action functions
def compile_manual(target, extras):
    for extra in extras:
        call(COMPILE_BASE + [extra])
    call(COMPILE_BASE + ['-include', 'target.h', target])
    o_files = map(partial(change_ext, '.o'), extras + [target])
    call(LINK_BASE + ['-o', change_ext('', target)] + o_files)

def compile_auto(target):
    extras = find_files('.', '.c')
    extras.remove(target)
    compile_manual(target, extras)

# Helper functions
def change_ext(ext, name):
    """ Change extension from the current one to ext """
    return os.path.splitext(name)[0] + ext

def find_files(directory, ewith):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if basename.endswith(ewith):
                filename = os.path.join(root, basename)
                yield filename

def call(clist):
    print('Running: ' + ' '.join(clist))
    subprocess.call(clist)

# The main stuff!
def main():
    args = docopt(__doc__, sys.argv[1:], version='0.1')
    if args['auto']:
        compile_auto(args['<target>'])
    elif args['manual']:
        compile_manual(args['<target>'], args['<extras>'])

if __name__ == '__main__':
    main()

#gcc -include stdio.h -include kovan/kovan.h -c bbstd.c 
#gcc -include stdio.h -include kovan/kovan.h -include target.h -c test.c  
#gcc -o test *.o -lkovan -lm -lpthread
