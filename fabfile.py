from __future__ import with_statement
from fabric.api import *

env.password = ''
env.user = 'root'

basedir = '/kovan/devel/lua/'

def copy_ssh():
    """ Copy SSH keys from Link to this computer, to use scrun.sh """
    from os.path import expanduser
    with settings(warn_only=True):
        if run('test -e ~/.ssh/id_rsa').failed:
            run('ssh-keygen')
    local('scp {0}@{1}:~/.ssh/id_rsa.pub .'.format(env.user, env.host_string))
    with open(expanduser('~/.ssh/authorized_keys'), 'a') as akeys:
        with open('id_rsa.pub') as keyfile:
            akeys.write(keyfile.read())
    local('rm id_rsa.pub')

def run_rsync():
    """ Copy files from this computer to the target Link """
    local('rsync -P --delete -rl -e ssh --exclude-from=.exclude --delete-excluded . {0}@{1}:{2}'.format(
        env.user, env.host_string, basedir))

def run_script(script):
    """ Copy files and run the specified script, example: fab -H host run_script:yourfile.lua """
    from os.path import split, join
    run_rsync()
    d, f = split(script)
    with cd(join(basedir, d)):
        run('lua ' + f)

def live():
    """ Run lua interactively on the remote, where the lualink library can be found in the lualink table """
    run('lua -l lualink')

