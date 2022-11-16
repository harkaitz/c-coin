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
	@echo 'I bin/ $(PROGRAMS)'
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp $(PROGRAMS) $(DESTDIR)$(PREFIX)/bin
	@echo 'I include/types/ $(HEADERS)'
	@mkdir -p $(DESTDIR)$(PREFIX)/include/types
	@cp $(HEADERS)  $(DESTDIR)$(PREFIX)/include/types
clean:
	@echo "D $(PROGRAMS)"
	@rm -f $(PROGRAMS)

## ------------------------------------------------------
tools/coin$(EXE): tools/coin.c coin.h
	@echo "B $@ $^"
	@$(CC) -o $@ tools/coin.c $(CFLAGS_ALL) 

## -- gettext --
update: u-locales
u-locales:
	@auto-gettext update
DISABLE_GETTEXT=$(shell which msgfmt >/dev/null 2>&1 || echo y)
ifeq ($(DISABLE_GETTEXT),)
install: install-po
install-po:
	@echo 'MO share/locale/es/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	@rm -f $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES/c-coin.mo
	@msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES/c-coin.mo ./locales/es/c-coin.po
	@echo 'MO share/locale/eu/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	@rm -f $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES/c-coin.mo
	@msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES/c-coin.mo ./locales/eu/c-coin.po
	@echo 'MO share/locale/ca/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES
	@rm -f $(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES/c-coin.mo
	@msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/ca/LC_MESSAGES/c-coin.mo ./locales/ca/c-coin.po
	@echo 'MO share/locale/gl/LC_MESSAGES/c-coin.mo'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES
	@rm -f $(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES/c-coin.mo
	@msgfmt --output-file=$(DESTDIR)$(PREFIX)/share/locale/gl/LC_MESSAGES/c-coin.mo ./locales/gl/c-coin.po
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
install: install-license
install-license: LICENSE
	@echo 'I share/doc/c-coin/LICENSE'
	@mkdir -p $(DESTDIR)$(PREFIX)/share/doc/c-coin
	@cp LICENSE $(DESTDIR)$(PREFIX)/share/doc/c-coin
## -- license --
