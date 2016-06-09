#ifndef _OFDM_CONF_H_
#define _OFDM_CONF_H_

#define OFDM_USING_PILOTS 1

#define OFDM_SYM_LEN 960
#define OFDM_CYC_LEN 240
/**
 * QPSK is used in carriers.
 */
#define BITS_PER_MOD 2

#define SAMPLE_LEN 16

#define SAMPLE_NUM_PER_SYM ((OFDM_SYM_LEN) * (BITS_PER_MOD) / (2 * (SAMPLE_LEN)))

#define REF_PILOT_REAL ((double) 0.2)
#define REF_PILOT_IMAG ((double) 0.0)

#define SIG_THR ((int)(1 << 21)) // very lucky i must be

//#define HW_SOLUTION // uncomment for hardware solution


#endif /* end of include guard: _OFDM_CONF_H_ */
