"""
Fletcher Botball Compiler.

Usage:
  compile.py auto [--output=FILE]
  compile.py manual <files>... [--output=FILE]
  compile.py -h | --help

Options:
  -o FILE --output=FILE  Output file.
  -h --help              Show this screen.
"""

import os
import sys
import subprocess
from docopt import docopt
from functools import partial

COMPILE_BASE = ['gcc', '-include', 'stdio.h', '-include', 'math.h', '-include', 'kovan/kovan.h', '-c']
LINK_BASE = ['gcc', '-lkovan', '-lm', '-lpthread']
EXCLUDE = ['./OpenCode']


# Actual action functions
def compile_manual(files, output):
    if output == None:
        output = "out"
    for f in files:
        call(COMPILE_BASE + [f])
    o_files = map(partial(change_ext, '.o'), files)
    call(LINK_BASE + ['-o', output] + o_files)
    map(os.remove, o_files)

def compile_auto(output):
    files = find_files('.', '.c')
    compile_manual(list(files), output)

# Helper functions
def change_ext(ext, name):
    """ Change extension from the current one to ext """
    return os.path.splitext(name)[0] + ext

def find_files(directory, ewith):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if basename.endswith(ewith):
                filename = os.path.join(root, basename)
                if not any(map(lambda x: filename.startswith(x), EXCLUDE)):
                    yield filename

def call(clist):
    print('Running: ' + ' '.join(clist))
    subprocess.call(clist)

# The main stuff!
def main():
    args = docopt(__doc__, sys.argv[1:], version='0.1')
    if args['auto']:
        compile_auto(args['--output'])
    elif args['manual']:
        compile_manual(args['<files>'], args['--output'])

if __name__ == '__main__':
    main()

#gcc -include stdio.h -include kovan/kovan.h -c bbstd.c 
#gcc -include stdio.h -include kovan/kovan.h -include target.h -c test.c  
#gcc -o test *.o -lkovan -lm -lpthread
