#include "io.h"

#include <unistd.h>

int read_word ( int fd ) {
    int i, forExport = 0;
    char temp;
    for ( i = 0; i < WORD_LEN; i++ ) {
        read ( fd, &temp, sizeof(char) );
        forExport += ((int)(temp) << (i * 8));
    }
    return forExport;
}

short read_half ( int fd ) {
    int i;
    short forExport = 0;
    char temp;
    for ( i = 0; i < HALF_LEN; i++ ) {
        read ( fd, &temp, sizeof(char) );
        forExport += ((short)(temp) << (i * 8));
    }
    return forExport;
}

void write_word ( int fd, int word ) {
    int i;
    char temp;
    for ( i = 0; i < WORD_LEN; i++ ) {
        temp = (word >> (i * 8)) & 0xFF;
        write ( fd, &temp, sizeof(char) );
    }
}

void write_half ( int fd, short half ) {
    int i;
    char temp;
    for ( i = 0; i < HALF_LEN; i++ ) {
        temp = (half >> (i * 8)) & 0xFF;
        write ( fd, &temp, sizeof(char) );
    }
}
