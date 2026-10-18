#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_string>\n", argv[0]);
        return 1;
    }

    const char *text = argv[1];
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, (const Bytef *)text, strlen(text));

    unsigned int host_id = 1 + (crc % 65534);
    unsigned int octet3 = host_id / 256;
    unsigned int octet4 = host_id % 256;

    printf("%u.%u\n10.18.%u.%u\n", octet3, octet4, octet3, octet4);
    return 0;
}