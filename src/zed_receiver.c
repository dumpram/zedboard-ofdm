#include <stdio.h>
#include <fcntl.h>

#include "ofdm.h"
#include "io.h"


#define XILLY_AUDIO "/dev/xillybus_audio"
#define DEMOD_OUT "out.wav"
#define FFT_FD_IN "/dev/xillybus_write_32"
#define FFT_FD_OUT "/dev/xillybus_read_32"

extern void (*ofdm_process_state[STATE_NUM])(ofdm_params *, int);

/**
 * Main function of receiver. Opens streams and configures receiver.
 * @return 0 on success, -1 otherwise
 */
int main () {
    int audio_fd = open ( XILLY_AUDIO, O_RDWR );
    int out_fd = open ( DEMOD_OUT, O_WRONLY | O_CREAT | O_TRUNC );
    int fft_in_fd = open ( FFT_FD_IN, O_WRONLY );
    int fft_out_fd = open ( FFT_FD_OUT, O_RDONLY );

    int word = 0;
    short half = 0;
    ofdm_params *p = ofdm_init( out_fd );
    p->fft_fd_in = fft_in_fd;
    p->fft_fd_out = fft_out_fd;

    perror ( "OFDM receiver start...\r\n" );

    while ( 1367 ) {
        word = read_word ( audio_fd );
        ofdm_process_state[p->state]( p, word );
    }

    return 0;
}
