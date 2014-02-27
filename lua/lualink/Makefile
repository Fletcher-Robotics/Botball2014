CC=gcc                                                 # c compiler
CFLAGS= -fPIC -O2 -I/usr/local/include -include math.h # c flags - use -Wall when possible
LDFLAGS= -lkovan -llua                                 # linking flags

LUA_DIR=/usr/local
LUA_LIBDIR=$(LUA_DIR)/lib/lua/5.2
LUA_SHAREDIR=$(LUA_DIR)/share/lua/5.2

all: create_c.so common_c.so wheel_c.so
create_c.o: create_c.c
	$(CC) -c $(CFLAGS) -o $@ $<

create_c.so: create_c.o
	$(CC) -shared $(CFLAGS) -o $@ $^ $(LDFLAGS)

common_c.o: common_c.c
	$(CC) -c $(CFLAGS) -o $@ $<

common_c.so: common_c.o
	$(CC) -shared $(CFLAGS) -o $@ $^ $(LDFLAGS)

wheel_c.o: wheel_c.c
	$(CC) -c $(CFLAGS) -o $@ $<

wheel_c.so: wheel_c.o
	$(CC) -shared $(CFLAGS) -o $@ $^ $(LDFLAGS)

install: create_c.so common_c.so wheel_c.so
	install -D create_c.so $(LUA_LIBDIR)/lualink/create_c.so
	install -D common_c.so $(LUA_LIBDIR)/lualink/common_c.so
	install -D wheel_c.so $(LUA_LIBDIR)/lualink/wheel_c.so
	install -D create.lua $(LUA_SHAREDIR)/lualink/create.lua
	install -D common.lua $(LUA_SHAREDIR)/lualink/common.lua
	install -D wheel.lua $(LUA_SHAREDIR)/lualink/wheel.lua

uninstall:
	rm -r $(LUA_LIBDIR)/lualink
	rm -r $(LUA_SHAREDIR)/lualink

clean:
	rm create_c.o create_c.so common_c.o common_c.so wheel_c.o wheel_c.so
