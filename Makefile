DESTDIR    =
PREFIX     =/usr/local
CC         =gcc
CFLAGS     =-Wall -Wextra -std=gnu99 -g
PROGRAMS   =tools/coin$(EXE)
HEADERS    =coin.h
CFLAGS_ALL =$(CFLAGS) $(CPPFLAGS) $(if,$(NO_GETTEXT),-DNO_GETTEXT) -DPREFIX=\"$(PREFIX)\"
## -- targets
all: $(PROGRAMS)
install: $(PROGRAMS)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp $(PROGRAMS) $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/include/types
	cp $(HEADERS)  $(DESTDIR)$(PREFIX)/include/types
clean:
	rm -f $(PROGRAMS)
## -- programs
tools/coin$(EXE): tools/coin.c coin.h
	$(CC) -o $@ tools/coin.c $(CFLAGS_ALL) 
## -- manpages --
install: install-man3
install-man3:
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man3
	cp ./coin.3 $(DESTDIR)$(PREFIX)/share/man/man3
## -- manpages --
## -- license --
install: install-license
install-license: LICENSE
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-coin
	cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-coin
## -- license --
