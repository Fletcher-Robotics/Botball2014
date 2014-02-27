CC=gcc                  # c compiler
CFLAGS= -fPIC -Wall -O2 # c flags
LDFLAGS= -lkovan -llua  # linking flags

all: create_c.so link_c.so
create_c.o: create_c.c
	$(CC) -c $(CFLAGS) -o $@ $<

link_c.o: link_c.c
	$(CC) -c $(CFLAGS) -o $@ $<

create_c.so: create_c.o
	$(CC) -shared $(CFLAGS) -o $@ $^ $(LDFLAGS)

link_c.so: link_c.o
	$(CC) -shared $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm create_c.o create_c.so link_c.o link_c.so
