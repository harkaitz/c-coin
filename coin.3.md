# NAME

coin_t, coin_same_currency(), coin_equal(), coin_parse(), coin_sprintf(),
coin_divide1(), coin_divide2(), coin_substract(), coin_sum(), coin_multiply(),
coin_str()

# SYNOPSIS

    #include <types/coin_ss.h>
    
    typedef struct coin_s {
        unsigned long cents;
        char          currency[8];
    } coin_t;
    typedef struct coin_ss {
        char s[64];
    } coin_ss;
    typedef enum coin_err_e {
        /* See header ... */,
        COIN_ERR_MAX
    } coin_err_e;
    
    const char *g_coin_default = "eur";
    
    coin_t coin (unsigned long _cents, const char _currency[]);
    bool   coin_same_currency (coin_t _c1, coin_t _c2);
    bool   coin_equal     (coin_t _c1, coin_t _c2);
    bool   coin_parse     (coin_t *_opt_out, const char _value[], coin_err_e *_opt_reason);
    int    coin_sprintf   (coin_t  _c,  size_t _max, char _buf[_max]);
    bool   coin_divide1   (coin_t *_o,  coin_t _i,  unsigned long _div, coin_err_e *_opt_reason);
    bool   coin_divide2   (long   *_o,  coin_t _i,  coin_t        _div, coin_err_e *_opt_reason);
    bool   coin_substract (coin_t *_o,  coin_t _c1, coin_t        _c2,  coin_err_e *_opt_reason);
    coin_t coin_sum       (coin_t  _c1, coin_t _c2);
    coin_t coin_multiply  (coin_t  _c1, long _count);
    cstr   coin_str       (coin_t  _c,  coin_ss *_cs);

# DESCRIPTION

This functions help managing monetary values in a more secure way. You
can parse strings with "[CURRENCY]VALUE[.CENTS][CURRENCY]" format.

# COLLABORATING

For making bug reports, feature requests and donations visit one of the
following links:

1. [gemini://harkadev.com/oss/](gemini://harkadev.com/oss/)
2. [https://harkadev.com/oss/](https://harkadev.com/oss/)

