#include "complex.h"

void cmplx_div ( fftw_complex a, fftw_complex b, fftw_complex c ) {
    double mag = cmplx_mag ( a ) / cmplx_mag ( b );
    double phs = cmplx_phs ( a ) - cmplx_phs ( b );
    c[REAL] = cmplx_real ( mag, phs );
    c[IMAG] = cmplx_imag ( mag, phs );
}

void cmplx_mul ( fftw_complex a, fftw_complex b, fftw_complex c ) {
    double mag = cmplx_mag ( a ) * cmplx_mag ( b );
    double phs = cmplx_phs ( a ) + cmplx_phs ( b );
    c[REAL] = cmplx_real ( mag, phs );
    c[IMAG] = cmplx_imag ( mag, phs );
}

double cmplx_mag ( fftw_complex a ) {
    return sqrt ( a[REAL] * a[REAL] + a[IMAG] * a[IMAG] );
}

double cmplx_phs ( fftw_complex a ) {
    return atan2 ( a[IMAG], a[REAL] );
}

double cmplx_real ( double mag, double phs ) {
    return mag * cos ( phs );
}

double cmplx_imag ( double mag, double phs ) {
    return mag * sin ( phs );
}
