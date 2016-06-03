#include <stdio.h>
#include <fcntl.h>

#include "ofdm.h"
#include "io.h"


#define XILLY_AUDIO "temp.wav"
#define DEMOD_OUT "out.wav"

extern void (*ofdm_process_state[STATE_NUM])(ofdm_params *, int);

/**
 * Main function of receiver. Opens streams and configures receiver.
 * @return 0 on success, -1 otherwise
 */
int main () {
    ofdm_params *p = ofdm_init();
    int audio_fd = open ( XILLY_AUDIO, O_RDONLY );
    int out_fd = open ( DEMOD_OUT, O_WRONLY );

    int word = 0;

    while ( 1367 ) {
        word = read_word ( audio_fd );

        ofdm_process_state[p->state](p, word);

        //if ( p-> fft_acq ) {
        //    // if fft done, write to output
        //}

        write_word ( out_fd, word );
    }

    return 0;
}
