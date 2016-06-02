#include <stdio.h>
#include "ofdm.h"

extern void (*ofdm_process_state[STATE_NUM])(ofdm_params *, int);

/**
 * Main function of receiver. Opens streams and configures receiver.
 * @return 0 on success, -1 otherwise
 */
int main () {
    ofdm_params *p = ofdm_init();
    //signal_state state = IDLE;
    int word = 0;

    while ( 1367 ) {
        //read
        ofdm_process_state[p->state](p, word);
        //write
    }


    return 0;
}
