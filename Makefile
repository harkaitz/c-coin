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
## -- gettext --
update: u-locales
u-locales:
	auto-gettext update
DISABLE_GETTEXT=$(shell which msgfmt >/dev/null 2>&1 || echo y)
ifeq ($(DISABLE_GETTEXT),)
install: install-po
install-po:
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	rm -f $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES/c-coin.mo
	msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES/c-coin.mo ./locales/es/c-coin.po
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	rm -f $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES/c-coin.mo
	msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES/c-coin.mo ./locales/eu/c-coin.po
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES
	rm -f $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES/c-coin.mo
	msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES/c-coin.mo ./locales/ca/c-coin.po
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES
	rm -f $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES/c-coin.mo
	msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES/c-coin.mo ./locales/gl/c-coin.po
endif
## -- gettext --
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
