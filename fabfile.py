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

def install_lua():
    """ Install the lua interpreter on the Link """
    from os.path import basename, splitext, join
    # Set paths
    lua_url = "http://www.lua.org/ftp/lua-5.2.3.tar.gz"
    lua_archive = basename(lua_url)
    lua_dir = splitext(splitext(lua_archive)[0])[0]
    # Perform the operations
    with cd(basedir):
        with settings(warn_only=True):
            run('rm ' + lua_archive)
            run('rm -rf ' + lua_dir)
        run('wget ' + lua_url)
        run('tar xzf ' + lua_archive)
        with cd(lua_dir):
            run('make linux -j2')
            run('make install')

def install_library():
    """ Install the latest lualink library from this computer """
    from os.path import join
    run_rsync()
    with cd(join(basedir, "Lualink/lualink")):
        run('make uninstall')
        run('make install')

def stop():
    """ Stop all motors and servos on Link """
    from os.path import join
    put('stop.lua', join(basedir, 'stop.lua'))
    run('lua stop.lua')
    run('rm stop.lua')

