## Introduction

### Purpose
The [KIPR Link Controller](http://www.kipr.org/hardware-software) is a robust platform, with it's uses extending from practical use, to education, to competition. KIPR seeks to provide an easy to use standard library and modular standardized parts that can be easily interted into the controller. However, the library only officially supports C. It also works with C++, as the library itself is written in C++. However, many who use the controller would like to use it with something other than C++. Many languages have a foreign function interface which allows them to interface with C. For example, the Python language has the [ctypes](http://docs.python.org/2/library/ctypes.html) library and Lua has [alien](https://github.com/mascarenhas/alien). However, they are usually not perfect and do not take full advantage of the language in question. There are projects which provide a separate library to interface with the KIPR one. One of these is [CBCJVM](https://github.com/CBCJVM) for Java. Lualink is another, bringing the KIPR library to Lua.

### Getting Started
To start using Lualink, download [Lua](http://www.lua.org/download.html) onto your Botball controller, through SSH:

    @plain
    wget http://www.lua.org/ftp/lua-5.2.3.tar.gz
    tar zxf lua-5.2.3.tar.gz
    cd lua-5.2.3
    make linux
    make install

If you're having trouble, consult the Botball forums. Next, download Lualink onto your controller and install it with `make install`.

### Your First Lua Program
To test your new install, create a file called "forward.lua" with these contents

    local motor = require "lualink.motor"
    local time = require "lualink.time"

    motor.motor(0, 80)
    motor.motor(1, 80)

    time.msleep(2000)

    motor.ao()

Now run it with `lua forward.lua`. If you have motors plugged in at ports 0 and 1, those motors will spin forward (provided they're not plugged in backwards) for 2 seconds. Otherwise, two green lights will turn on.
