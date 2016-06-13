#ifndef _OFDM_H_
#define _OFDM_H_

#include <fftw3.h>
/**
 * OFDM configuration header file.
 */
#include "ofdm-conf.h"

#define STATE_NUM 3

typedef struct ofdm_params ofdm_params;
typedef enum ofdm_state ofdm_state;

enum ofdm_state {
    IDLE,
    SYMBOL,
    PREFIX
};

struct ofdm_params {
    fftw_complex ofdm_in[OFDM_SYM_LEN];
    fftw_complex fft_out[OFDM_SYM_LEN];
    fftw_plan fft_plan;
    short ofdm_out[SAMPLE_NUM_PER_SYM];
    int raw_word[OFDM_SYM_LEN];
    ofdm_state state;
    int symbol_cnt;
    int fd_out;
    int fft_fd_in;
    int fft_fd_out;
};


ofdm_params *ofdm_init ( int out_fd );
void ofdm_demod ( ofdm_params *ofdm );
void ofdm_compensate ( fftw_complex target, fftw_complex ref );
int qpsk_decode ( short *sample, fftw_complex carrier );
void ofdm_dump ( ofdm_params *ofdm );

void process_idle ( ofdm_params *ofdm, int word );
void process_symbol ( ofdm_params *ofdm, int word );
void process_prefix ( ofdm_params *ofdm, int word );


#endif /* end of include guard: _OFDM_H_ */
