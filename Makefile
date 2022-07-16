DESTDIR    =
PREFIX     =/usr/local
CC         =gcc
CFLAGS     =-Wall -Wextra -std=gnu99 -g
PROGRAMS   =tools/coin$(EXE)
HEADERS    =coin.h
CFLAGS_ALL =$(CFLAGS) $(CPPFLAGS) $(if,$(NO_GETTEXT),-DNO_GETTEXT) -DPREFIX=\"$(PREFIX)\"

##
all: $(PROGRAMS)
install: $(PROGRAMS)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/include/types
	cp $(PROGRAMS) $(DESTDIR)$(PREFIX)/bin
	cp $(HEADERS)  $(DESTDIR)$(PREFIX)/include/types
clean:
	rm -f $(PROGRAMS)

##
tools/coin$(EXE): tools/coin.c coin.h
	$(CC) -o $@ tools/coin.c $(CFLAGS_ALL) 

## -- manpages --
ifneq ($(PREFIX),)
MAN_3=./coin.3 
install: install-man3
install-man3: $(MAN_3)
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man3
	cp $(MAN_3) $(DESTDIR)$(PREFIX)/share/man/man3
endif
## -- manpages --
## -- license --
ifneq ($(PREFIX),)
install: install-license
install-license: LICENSE
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-coin
	cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-coin
endif
## -- license --
## -- gettext --
ifneq ($(PREFIX),)
install: install-po
install-po:
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	cp locales/es/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	cp locales/eu/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
endif
## -- gettext --
