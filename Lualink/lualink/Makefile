CC:=gcc
CFLAGS:= -fPIC -I/kovan/devel/lib -I/usr/local/include\
         -O2 -include math.h
LDFLAGS:= -lkovan -llua -shared

LUA_DIR:=/usr/local
LUA_LIBDIR:=$(LUA_DIR)/lib/lua/5.2
LUA_SHAREDIR:=$(LUA_DIR)/share/lua/5.2

TARGETS:= create.so wheel_c.so sensor.so motor.so servo.so time.so

all: $(TARGETS)

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

%.so: %.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

install: $(TARGETS)
	for f in $^; do install -D $$f $(LUA_LIBDIR)/lualink/$$f; done
	for f in *.lua; do install -D $$f $(LUA_SHAREDIR)/lualink/$$f; done

uninstall:
	rm -r $(LUA_LIBDIR)/lualink
	rm -r $(LUA_SHAREDIR)/lualink

clean:
	rm *.so

.PHONY: all clean uninstall install
