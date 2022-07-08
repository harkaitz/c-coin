#include "../coin.h"
#include <unistd.h>
#include <locale.h>
#include <libintl.h>

#define COPYRIGHT_LINE \
    "Bug reports, feature requests to gemini|https://harkadev.com/oss" "\n" \
    "Copyright (c) 2022 Harkaitz Agirre, harkaitz.aguirre@gmail.com" "\n" \
    ""

int main (int _argc, char *_argv[]) {

    int            opt,i,e;
    char          *input           = NULL;
    char const    *reason          = NULL;
    char           b[1024];
    coin_t         c               = {0};

    if (_argc > 1 && (!strcmp(_argv[1], "-h") || !strcmp(_argv[1], "--help"))) {
        fputs("Usage: coin [-i VALUE][-a CURR:SYM,...][< VALUES]" "\n"
              ""                                                           "\n"
              "Parse monetary values and check it has an allowed currency" "\n"
              ""                                                           "\n"
              COPYRIGHT_LINE,
              stdout);
        return 1;
    }
    
    
    while((opt = getopt (_argc, _argv, "i:a:")) != -1) {
        switch (opt) {
        case 'i':
            input = optarg;
            break;
        case 'a':
            for(i=0; i<19; i+=2) {
                char *curr = strtok((i)?0:optarg, ",");
                if (!curr) break;
                char *sym = strchr(curr, ':');
                if (sym) {
                    *sym = '\0'; sym++;
                } else {
                    sym = "";
                }
                if (i==0) {
                    COIN_DEFAULT_CURRENCY = curr;
                }
                COIN_ALLOWED_CURRENCIES[i]   = curr;
                COIN_ALLOWED_CURRENCIES[i+1] = sym;
            }
            COIN_ALLOWED_CURRENCIES[i] = NULL;
            break;
        case '?':
        default:
            return 1;
        }
    }

    setlocale(LC_ALL, "");
#   ifdef PREFIX
    bindtextdomain("c-coin", PREFIX "/share/locale/");
#   endif
    
    if (input) {

        coin_t c = {0};
        e = coin_parse(&c, input, &reason);
        if (!e/*err*/) {
            fprintf(stderr, "coin: error: %s\n", reason);
            return 1;
        }
        coin_fprintf(c, stdout, false);
        fprintf(stdout, " %s\n", c.currency);
        
    } else {
        
        while (fgets(b, sizeof(b)-1, stdin)) {
            for(input = strtok(b, "\n, ");input;input=strtok(NULL, "\n, ")) {
                if (coin_parse(&c, input, NULL)) {
                    coin_fprintf(c, stdout, false);
                    fprintf(stdout, " %s\n", c.currency);
                } else {
                    fprintf(stderr, "coin: error: %s\n", reason);
                }
            }
        }
        
    }
    
    return 0;
}
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
