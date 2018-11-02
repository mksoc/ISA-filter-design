#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define Ndel 3 // # of positions in delay line 
#define NB_old 12 // # old total number of bits -- definition not used
#define BF_old 11 // # bits for the old fractional representation, for samples and coefficients
#define NB 28   // # total number of bits in the VHDL model
#define BF 22  // # bits for the fractional rep

// Old coefficients (Q1.11 fractional format)
// const int b0 = 423;           // coefficient b0
// const int b[N] = {846, 423};  // b array
// const int a[N] = {-757, 401}; // a array

// We define the new coefficients. Remember that the source integer coefficients (Q1.11) have been derived from the original ones with
// with a 11 bit right-shift. Multiplying two of these gives us a Q2.22 coefficient. To add coherently a coefficient in Q1.11 there's
// the need for an additional 11 bits right-shift (BF-BF_old) to uniform the fractional format.
// In the end all the coefficients will be in the format Q2.22
// For practical reasons remember that an "int" is assumed to be 32 bits wide. The real format of the coefficients is then Q10.22
const int coeff_ref0 = (401 << (BF-BF_old)) - pow(-757,2); // coeff_ref0 = a2-a1^2
const int coeff_ref1 = -(-757)*401; // -a1*a2
const int b0 = (423 << (BF-BF_old)); // b0
const int coeff_pipe01 = ((846) << (BF-BF_old)) - (-757)*423; // b1-a1*b0
const int coeff_pipe02 = ((423) << (BF-BF_old)) - (-757)*846; // b2-a1*b1
const int coeff_pipe03 = -(-757)*423; // -a1*b2

// Perform fixed point filtering assuming direct form II
//\param x is the new input sample in Q1.11
//\return the new output sample
int iir_filter(int x)
{
    static long int sw[Ndel];         // w shift register
    static int first_run = 0; // for cleaning the shift register
    int x_Q1_22;                   // input sample Q1.22
    int i;                         // index
    long int w;                    // intermediate value (w)
    long int y;                    // output sample Q1.22
    int y_Q1_12;				   // output sample Q1.11
    long int fb, ff;               // feed-back and feed-forward results

    // work on samples in Q1.22 parallelism for coherence with the new samples
    x_Q1_22 = (x << (BF-BF_old));

    // clean the buffer
    if (first_run == 0)
    {
        first_run = 1;
        for (i = 0; i < Ndel; i++)
            sw[i] = 0;
    }

    // compute feed-back and feed-forward
    fb = 0;
    ff = 0;
    fb -= (sw[1] * coeff_ref0) >> (BF);
    fb -= (sw[2] * coeff_ref1) >> (BF);
    ff += (sw[0] * coeff_pipe01) >> (BF);
    ff += (sw[1] * coeff_pipe02) >> (BF);
    ff += (sw[2] * coeff_pipe03) >> (BF);

    // compute intermediate value (w) and output sample
    w = x_Q1_22 + fb;
    y = (w * b0) >> (BF);
    y += ff;

    // update the shift register
    for (i = Ndel - 1; i > 0; i--)
        sw[i] = sw[i - 1];
    sw[0] = w;

    // saturate in case of overflow wrt the VHDL model with signals in format Q(NB-BF).BF
    if (y > pow(2, NB-1) - 1)
    {
        y = pow(2, NB-1) - 1;
    }
    else if (y < - pow(2, NB-1))
    {
        y = - pow(2, NB-1);
    }

    // return to the Q1.12 format
    y_Q1_12 = y >> (BF-BF_old);

    return y_Q1_12;
}

int main(int argc, char **argv)
{
    FILE *fp_in;
    FILE *fp_out;

    int x;
    int y;

    // check the command line
    if (argc != 3)
    {
        printf("Use: %s <input_file> <output_file>\n", argv[0]);
        exit(1);
    }

    // open files
    fp_in = fopen(argv[1], "r");
    if (fp_in == NULL)
    {
        printf("Error: cannot open %s\n", argv[1]);
        exit(2);
    }
    fp_out = fopen(argv[2], "w");

    // get samples and apply filter
    fscanf(fp_in, "%d", &x);
    do
    {
        y = iir_filter(x);
        fprintf(fp_out, "%d\n", y);
        fscanf(fp_in, "%d", &x);
    } while (!feof(fp_in));

    fclose(fp_in);
    fclose(fp_out);

    return 0;
}
