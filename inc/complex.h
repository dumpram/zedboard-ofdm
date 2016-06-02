#ifndef _COMPLEX_H_
#define _COMPLEX_H_

#include <fftw3.h>
#include <math.h>

#define REAL 0
#define IMAG 1


void cmplx_div ( fftw_complex a, fftw_complex b, fftw_complex c );
void cmplx_mul ( fftw_complex a, fftw_complex b, fftw_complex c );
double cmplx_mag ( fftw_complex a );
double cmplx_phs ( fftw_complex a );
double cmplx_real ( double mag, double phs );
double cmplx_imag ( double mag, double phs );


#endif /* end of include guard: _COMPLEX_H_ */
