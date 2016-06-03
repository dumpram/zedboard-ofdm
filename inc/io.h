#ifndef _IO_H_
#define _IO_H_

#define WORD_LEN 4
#define HALF_LEN 2


int read_word ( int fd );
short read_half ( int fd );
void write_word ( int fd, int word );
void write_half ( int fd, short word );


#endif /* end of include guard: _IO_H_ */
