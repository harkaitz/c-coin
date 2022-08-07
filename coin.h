#ifndef TYPES_COIN_H
#define TYPES_COIN_H

#include <ctype.h>
#include <limits.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <alloca.h>
#include <strings.h>
#ifdef NO_GETTEXT
#  define COIN_T(T) (T)
#else
#  include <libintl.h>
#  define COIN_T(T) dgettext("c-coin", T)
#endif


typedef struct coin_s {
    unsigned long cents;
    char          currency[8];
} coin_t;
typedef struct coin_ss {
    char s[64];
} coin_ss;



#define COIN_SS_STORE alloca(sizeof(coin_ss))
#define COIN(FF,CC,CUR) { ((FF)*100)+(CC), CUR}

extern const char *COIN_DEFAULT_CURRENCY;
extern const char *COIN_ALLOWED_CURRENCIES[];




static inline coin_t
coin (unsigned long _cents, const char _currency[]) {
    coin_t out = {0};
    out.cents = _cents;
    if (_currency) {
        strncpy(out.currency, _currency, sizeof(out.currency)-1);
    } else {
        strncpy(out.currency, COIN_DEFAULT_CURRENCY, sizeof(out.currency)-1);
    }
    return out;
}

static inline bool
coin_same_currency (coin_t _c1, coin_t _c2) {
    return (!strcasecmp(_c1.currency, _c2.currency));
}

static inline bool
coin_equal (coin_t _c1, coin_t _c2) {
    if (_c1.cents != _c2.cents) return false;
    if (!coin_same_currency(_c1, _c2)) return false;
    return true;
}

static inline char const *
coin_currency_is_allowed(const char *_name_or_symbol, size_t len, bool symbol) {
    for (int i=0; COIN_ALLOWED_CURRENCIES[i]; i+=2) {
        const char *n   = COIN_ALLOWED_CURRENCIES[i];
        const char *s   = COIN_ALLOWED_CURRENCIES[i+1];
        size_t      nsz = strlen(n);
        size_t      ssz = strlen(s);
        if (len == nsz && !strncasecmp(_name_or_symbol,n, nsz)) {
            return (symbol)?s:n;
        }
        if (s[0] && len == ssz && !strncasecmp(_name_or_symbol,s, ssz)) {
            return (symbol)?s:n;
        }
    }
    return NULL;
}

static inline bool
coin_parse (coin_t *_opt_out, const char _value[], const char **_reason) {

    const char  *p            = _value;
    const char  *currency     = NULL;
    size_t       currency_len = 0;
    long         n1           = 0;
    long         n2           = 0;
    char        *next;

    /* Get currency from the start. */
    if (!strchr("1234567890", *p)) {
        currency = _value;
        while (!strchr("1234567890", *p)) ++p;
    }
    if (!*p/*err*/) {
        if (_reason) *_reason = COIN_T("Invalid monetary format");
        return false;
    }
    if (currency) {
        currency_len = p-currency;
    }
    
    /* Get first number. */
    n1 = strtol(p, &next, 10);
    if (next == p/*err*/) {
        if (_reason) *_reason = COIN_T("Invalid monetary format");
        return false;
    }
    if (n1 >= LONG_MAX/200 || n2 < 0/*err*/) {
        if (_reason) *_reason =  COIN_T("Invalid monetary format");
        return false;
    }
    p = next;

    /* Get cents. */
    if (strchr(".,", *p)) {
        ++p;
        char pp[4]; int ppn = 0;
        if (strchr("1234567890", *p)) pp[ppn++] = *(p++);
        if (strchr("1234567890", *p)) pp[ppn++] = *(p++);
        if (strchr("1234567890", *p)) pp[ppn++] = *(p++);
        pp[ppn] = '\0';
        n2 = strtol(pp, &next, 10);
        if (*next != '\0'/*err*/) {
            if (_reason) *_reason = COIN_T("Invalid monetary format");
            return false;
        }
        if (n2 < 0 || n2 >= 100 || (next-pp)>=3/*err*/) {
            if (_reason) *_reason = COIN_T("Unsupported monetary precision");
            return false;
        }
        p = next;
    }

    /* Get currency from the end. */
    if (*p) {
        if (currency/*err*/) {
            if (_reason) *_reason = COIN_T("Invalid monetary format");
            return false;
        }
        currency     = p;
        currency_len = strlen(currency);
    }

    /* Set default currency. */
    if (currency == NULL) {
        currency     = COIN_DEFAULT_CURRENCY;
        currency_len = strlen(COIN_DEFAULT_CURRENCY);
    } else if (currency[0]=='-'){
        currency++;
        currency_len--;
    }

    /* Check it is allowed. */
    const char *a = coin_currency_is_allowed(currency, currency_len, false);
    if (!a/*err*/) {
        if (_reason) *_reason = COIN_T("Unsupported currency");
        return false;
    }
    
    /* Set coin. */
    if (_opt_out) {
        _opt_out->cents = (n1*100)+n2;
        strcpy(_opt_out->currency,a);
    }
    return true;
}

static inline int
coin_sprintf (coin_t _c, size_t _max, char _buf[], bool _with_currency) {
    int r=0;
    unsigned long n1 = _c.cents/100;
    unsigned long n2 = _c.cents%100;
    r += snprintf(_buf, _max, "%ld.%.2ld", n1, n2);
    if (_with_currency) {
        const char *s = coin_currency_is_allowed(_c.currency, strlen(_c.currency), true);
        r += snprintf(_buf+r, _max-r, "%s", (s)?s:_c.currency);
    }
    return r;
}

static inline int
coin_fprintf (coin_t _c, FILE *_fp, bool _with_currency) {
    int r=0;
    unsigned long n1 = _c.cents/100;
    unsigned long n2 = _c.cents%100;
    r = fprintf(_fp, "%ld.%.2ld", n1, n2);
    if (_with_currency) {
        const char *s = coin_currency_is_allowed(_c.currency, strlen(_c.currency), true);
        r = fprintf(_fp, "%s", (s)?s:_c.currency);
    }
    return r;
}

static inline bool
coin_divide1 (coin_t *_o, coin_t _i, unsigned long _div, const char **_reason) {
    if (_div == 0/*err*/) {
        if (_reason) *_reason = COIN_T("Monetary division by zero");
        return false;
    }
    if (_i.cents % _div/*err*/) {
        if(_reason) *_reason = COIN_T("Monetary not divisible");
        return false;
    }
    _o->cents = _i.cents / _div;
    strcpy(_o->currency,_i.currency);
    return true;
}

static inline bool
coin_divide2 (long *_o, coin_t _i, coin_t _div, const char **_reason) {
    if (!coin_same_currency(_i,_div)/*err*/) {
        if (_reason) *_reason = COIN_T("Not the same currency");
        return false;
    }
    if (_div.cents == 0/*err*/) {
        if (_reason) *_reason = COIN_T("Monetary division by zero");
        return false;
    }
    if (_i.cents % _div.cents/*err*/) {
        if (_reason) *_reason = COIN_T("Monetary not divisible");
        return false;
    }
    *_o = _i.cents / _div.cents;
    return true;
}

static inline bool
coin_substract (coin_t *_o, coin_t _c1, coin_t _c2, const char **_reason) {
    if (!coin_same_currency(_c1,_c2)/*err*/) {
        if (_reason) *_reason = COIN_T("Not the same currency");
        return false;
    }
    if (_c2.cents > _c1.cents/*err*/) {
        if (_reason) *_reason = COIN_T("Monetary value crosses to negative");
        return false;
    }
    _o->cents = _c1.cents - _c2.cents;
    strcpy(_o->currency,_c1.currency);
    return true;
}

static inline coin_t
coin_sum (coin_t _c1, coin_t _c2) {
    coin_t out;
    out.cents = _c1.cents + _c2.cents;
    strcpy(out.currency,_c1.currency);
    return out;
}

static inline coin_t
coin_multiply (coin_t _c1, long _count) {
    coin_t out;
    out.cents = _c1.cents * _count;
    strcpy(out.currency,_c1.currency);
    return out;
}

static inline char const *
coin_str(coin_t _c, coin_ss *_cs) {
    coin_sprintf(_c, sizeof(_cs->s), _cs->s, true);
    _cs->s[sizeof(_cs->s)-1] = '\0';
    return _cs->s;
}

#endif
/**l*
 * 
 * MIT License
 * 
 * Bug reports, feature requests to gemini|https://harkadev.com/oss
 * Copyright (c) 2022 Harkaitz Agirre, harkaitz.aguirre@gmail.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **l*/
