DESTDIR    =
PREFIX     =/usr/local
CC         =gcc
CFLAGS     =-Wall -Wextra -std=gnu99 -g
PROGRAMS   =tools/coin$(EXE)
HEADERS    =coin.h
CFLAGS_ALL =$(CFLAGS) $(CPPFLAGS) $(if,$(NO_GETTEXT),-DNO_GETTEXT) -DPREFIX=\"$(PREFIX)\"

## ------------------------------------------------------
all: $(PROGRAMS)
install: $(PROGRAMS)
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/include/types
	cp $(PROGRAMS) $(DESTDIR)$(PREFIX)/bin
	cp $(HEADERS)  $(DESTDIR)$(PREFIX)/include/types
clean:
	rm -f $(PROGRAMS)

## ------------------------------------------------------
tools/coin$(EXE): tools/coin.c coin.h
	$(CC) -o $@ tools/coin.c $(CFLAGS_ALL) 

## -- gettext --
ifneq ($(PREFIX),)
install: install-po
install-po:
	@echo 'I share/locale/es/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	@cp locales/es/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	@echo 'I share/locale/eu/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	@cp locales/eu/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	@echo 'I share/locale/ca/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES
	@cp locales/ca/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES
	@echo 'I share/locale/gl/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES
	@cp locales/gl/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES
endif
## -- gettext --
## -- manpages --
install: install-man3
install-man3:
	@echo 'I share/man/man3/'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/man/man3
	@echo 'I share/man/man3/coin.3'
	@cp ./coin.3 $(DESTDIR)$(PREFIX)/share/man/man3
## -- manpages --
## -- license --
ifneq ($(PREFIX),)
install: install-license
install-license: LICENSE
	@echo 'I share/doc/c-coin/LICENSE'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-coin
	@cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-coin
endif
## -- license --
