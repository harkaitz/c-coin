DESTDIR  =
PREFIX   =/usr/local
CC       =gcc
CFLAGS   =-Wall -Wextra -std=gnu99 -g
CPPFLAGS =$(if,$(NO_GETTEXT),-DNO_GETTEXT) -DPREFIX=\"$(PREFIX)\"
COIN_EXE =tools/coin

all: $(COIN_EXE)
install: $(COIN_EXE)
	mkdir -p $(DESTDIR)$(PREFIX)/bin $(DESTDIR}$(PREFIX)/include/types
	cp $(COIN_EXE) $(DESTDIR)$(PREFIX)/bin
	cp coin.h $(DESTDIR)$(PREFIX)/include/types
clean:
	rm -f $(COIN_EXE)

$(COIN_EXE): tools/coin.c coin.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $<


## -- gettext --
install: install-po
install-po:
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	cp locales/es/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/es/LC_MESSAGES
	mkdir -p $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
	cp locales/eu/LC_MESSAGES/c-coin.mo $(DESTDIR)$(PREFIX)/share/locale/eu/LC_MESSAGES
## -- gettext --
