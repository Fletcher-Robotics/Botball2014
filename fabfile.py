from __future__ import with_statement
from fabric.api import *
from os.path import expanduser, split, join

env.password = ''
env.user = 'root'

basedir = '/kovan/devel/lua/'

def copy_ssh():
    with settings(warn_only=True):
        if run('test -e ~/.ssh/id_rsa').failed:
            run('ssh-keygen')
    local('scp {0}@{1}:~/.ssh/id_rsa.pub .'.format(env.user, env.host_string))
    with open(expanduser('~/.ssh/authorized_keys'), 'a') as akeys:
        with open('id_rsa.pub') as keyfile:
            akeys.write(keyfile.read())
    local('rm id_rsa.pub')

def run_rsync():
    local('rsync -P --delete -rl -e ssh --exclude-from=.exclude --delete-excluded . {0}@{1}:{2}'.format(
        env.user, env.host_string, basedir))

def run_script(script):
    run_rsync()
    d, f = split(script)
    with cd(join(basedir, d)):
        run('lua ' + f)
