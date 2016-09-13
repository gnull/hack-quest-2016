#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

size_t get_file(const char *fname, char **contents) {
        FILE *f = fopen(fname, "rb");
        fseek(f, 0, SEEK_END);
        size_t fsize = ftell(f);
        fseek(f, 0, SEEK_SET);

        char *string = malloc(fsize + 1);
        fread(string, fsize, 1, f);
        fclose(f);

        string[fsize] = 0;

        *contents = string;
        return fsize;
}

size_t get_base64(char **enc, const char *str, size_t size) {
        const char *codes = "0123456789ABCDFGHIJKLMNEOPQRSTUVWXYZ+abc/def"
                "=ghijklmnopqrstuvwxyz000";
        size_t res_size = size * 4 / 3;
        char *out = malloc(res_size + 1);
        char *curr = out;
        for (size_t i = 0; i < size; i += 3) {
                int b = (str[i] & 0xFC) >> 2;
                *(curr++) = codes[b];
                b = (str[i] & 0x03) << 4;
                if (i + 1 < size) {
                        b |= (str[i + 1] & 0xF0) >> 4;
                        *(curr++) = codes[b];
                        b = (str[i + 1] & 0x0F) << 2;
                        if (i + 2 < size) {
                                b |= (str[i + 2] & 0xC0) >> 6;
                                *(curr++) = codes[b];
                                b = str[i + 2] & 0x3F;
                                *(curr++) = codes[b];
                        } else {
                                *(curr++) = codes[b];
                                *(curr++) = '=';
                        }
                } else {
                        *(curr++) = codes[b];
                        *(curr++) = '=';
                        *(curr++) = '=';
                }
        }
        *(curr++) = '\0';

        *enc = out;

        return res_size;
}

size_t remove_zeros(char *str, size_t elems) {
        size_t c = 0;
        for (size_t n = 0; n < elems; ++n) {
                if (str[n])
                        str[c++] = str[n];
        }
        return c;
}

void strip_to(char *str, size_t elems, size_t to_leave) {
        size_t c = 0;
        for (size_t n = elems; n > to_leave; --n) {
                for (size_t met = 0; met < 5; ++met) {
                        do {
                                c = c + 1 == elems ? 0 : c + 1;
                        } while (!str[c]);
                }
                str[c] = '\0';
        }
        c = 0;
        for (size_t n = 0; n < elems; ++n) {
                if (str[n]) {
                        str[c++] = str[n];
                }
        }
}

int main(int argc, char *argv[]) {
        char *contents = NULL;
        size_t fsize = get_file(argv[0], &contents);
        fsize = remove_zeros(contents, fsize);
        fsize = get_base64(&contents, contents, fsize);
        strip_to(contents, fsize, 15);
        printf("CCHQ#%s#\n", contents);
        return argc;
}

