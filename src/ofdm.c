#include "ofdm.h"
#include "complex.h"
#include "io.h"

#include <stdio.h>
#include <stdlib.h>

static fftw_complex reference = { REF_PILOT_REAL, REF_PILOT_IMAG };

void _fftw_execute ( ofdm_params *params ) {

#ifdef HW_SOLUTION
    int i, word;
    for ( i = 0; i < OFDM_SYM_LEN; i++ ) {
        write_half (params->fft_fd_in, (short) ((params->ofdm_in[i][REAL]) * pow(2, SAMPLE_LEN)));
        write_half (params->fft_fd_in, (short) ((params->ofdm_in[i][IMAG]) * pow(2, SAMPLE_LEN)));
    }

    for ( i = 0; i < OFDM_SYM_LEN; i++ ) {
        read_word (params->fft_fd_out, &word);
        params->fft_out[i][REAL] =
            (double)((short)(word >> SAMPLE_LEN)) / pow ( 2, SAMPLE_LEN );
        params->fft_out[i][IMAG] =
            (double)((short)(word & 0xFFFF)) / pow ( 2, SAMPLE_LEN );
    }
#else
    fftw_execute ( params->fft_plan );
#endif

}

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
        printf ("%d\n", ofdm->ofdm_out[i] );
    }
    exit(1);
}

void ofdm_demod ( ofdm_params *params ) {
    int i, j = 0, k = 0;
    fftw_complex *fft_out = params->fft_out;
    short *out = params->ofdm_out;
    short tmp_sample = 0;
    _fftw_execute ( params );
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
//    dump_samples(params);
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
        write_half ( ofdm->fd_out, 0 ); // Comp Left
        write_half ( ofdm->fd_out, 0 ); // Comp Right
    }
}

void process_idle ( ofdm_params *ofdm, int word ) {
    if ( word > SIG_THR ) {
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
