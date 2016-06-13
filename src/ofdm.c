#include "ofdm.h"
#include "complex.h"
#include "io.h"

#include <stdio.h>
#include <stdlib.h>

static fftw_complex reference = { REF_PILOT_REAL, REF_PILOT_IMAG };

void (*ofdm_process_state[STATE_NUM])( ofdm_params*, int ) = {
    process_idle,
    process_symbol,
    process_prefix
};

ofdm_params *ofdm_init ( int out_fd ) {
    ofdm_params *forExport = (ofdm_params *) malloc ( sizeof(ofdm_params) );

    forExport->fft_plan = fftw_plan_dft_1d ( OFDM_SYM_LEN , forExport->ofdm_in,\
         forExport->fft_out, FFTW_FORWARD, FFTW_ESTIMATE );
    forExport->symbol_cnt = 0;
    forExport->state = IDLE;
    forExport->fd_out = out_fd;
    return forExport;
}

void dump_samples (ofdm_params *ofdm) {
    int i;
    for ( i = 0; i < (SAMPLE_NUM_PER_SYM); i++ ) {
        printf ("%lf %lf\n", ofdm->fft_out[i][REAL], ofdm->fft_out[i][IMAG] );
    }
    exit(1);
}

void ofdm_demod ( ofdm_params *params ) {
    int i, j = 0, k = 0;
    fftw_complex *fft_out = params->fft_out;
    short *out = params->ofdm_out;
    short tmp_sample = 0;
    fftw_execute ( params->fft_plan );

    for ( i = 1; i < OFDM_SYM_LEN; i += 2 ) {
        ofdm_compensate ( fft_out[i], fft_out[i - 1] );
        qpsk_decode ( &tmp_sample, fft_out[i] );
        if ( j == (SAMPLE_LEN / BITS_PER_MOD - 1) ) {
            j = 0;
            out[k] = tmp_sample;
            tmp_sample = 0;
    //        printf ("k: %d\n", k);
            k++;

        } else {
            j++;
        }

    }
    //printf ( "k: %d", k );
    dump_samples(params);
}



void ofdm_compensate ( fftw_complex target, fftw_complex ref ) {
    fftw_complex temp;
    cmplx_div ( reference, ref, temp );
    cmplx_mul ( target, temp, target );
}

void qpsk_decode ( short *sample, fftw_complex carrier ) {
    (*sample) <<= 2;
    if ( carrier[REAL] > 0 ) {
        if ( carrier[IMAG] > 0) {
            (*sample) |= 0;
        } else {
            (*sample) |= 1;
        }
    } else {
        if ( carrier[IMAG] > 0) {
            (*sample) |= 2;
        } else {
            (*sample) |= 3;
        }
    }
}

void ofdm_dump ( ofdm_params *ofdm ) {
    int i, word;
    for ( i = 0; i < SAMPLE_NUM_PER_SYM; i++ ) {
        write_half ( ofdm->fd_out, ofdm->ofdm_out[i] ); // Left
        write_half ( ofdm->fd_out, ofdm->ofdm_out[i] ); // Right
//        write_half ( ofdm->fd_out, ofdm->ofdm_out[i] ); // Comp Left
//        write_half ( ofdm->fd_out, ofdm->ofdm_out[i] ); // Comp Right
    }
}

void process_idle ( ofdm_params *ofdm, int word ) {
    if ( word > SIG_THR * 2 ) {
        ofdm->state = SYMBOL;
        perror ("Symbol detected...");
        process_symbol ( ofdm, word );
    }
}

void process_symbol ( ofdm_params *ofdm, int word ) {
    if ( ofdm->symbol_cnt == OFDM_SYM_LEN ) {
        ofdm->state = PREFIX;
        ofdm->symbol_cnt = 0;
        ofdm_demod ( ofdm );
        ofdm_dump ( ofdm );
        process_prefix ( ofdm, word );
    } else {
        ofdm->ofdm_in[ofdm->symbol_cnt][REAL] =
            (double)((short)(word >> SAMPLE_LEN)) / pow ( 2, SAMPLE_LEN );
        ofdm->ofdm_in[ofdm->symbol_cnt][IMAG] =
            (double)((short)(word & 0xFFFF)) / pow ( 2, SAMPLE_LEN );
        ofdm->symbol_cnt++;
    }
}

void process_prefix ( ofdm_params *ofdm, int word ) {
    if ( ofdm->symbol_cnt == OFDM_CYC_LEN ) {
        ofdm->state = SYMBOL;
        ofdm->symbol_cnt = 0;
        process_symbol ( ofdm, word );
    } else {
        ofdm->symbol_cnt++;
    }
}
