/* $ gcc -D OPTIMIZE -o Lab12_opt Lab12.c
   $ time ./Lab12_opt 2 40
   ---> Optimization is set on.
   2^40 is 1099511627776
   1099511627776 log 2 is 40
   real	0m0.003s
   user	0m0.003s
   sys	0m0.000s
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#define ITERATIONS 8000
int main(int argc, char **argv){
	if (argc < 3) {
		printf("Usage: ./lab12 <base> <exp>\n");
		exit(0);
	}
    unsigned int sleep(unsigned int seconds);
	unsigned long long base = atoi(argv[1]);
	unsigned long long exp  = atoi(argv[2]);
	int i, j;
    unsigned long long exponential = 1;
	int brute;
		printf("---> Optimization is set on.\n");
		if (base == 2) {
			for (i=0; i<ITERATIONS; i++) {
				exponential = 1;
                asm (
					"movq $1, %0;"
					"movq %2, %%rcx;"
					"sal %%cl, %0;"
					: "=r"(exponential)
					: "r"(base),"r"(exp)
					: "%rcx"
				);
			}
		}
        sleep(0);
        for (i=0; i<ITERATIONS; i++) {
			exponential = 1;
			for (j=1; j<=exp; j++)
				exponential = base*exponential;
		}
	printf("%llu^%llu is %llu\n",base,exp,exponential);
    unsigned long long log = 0;
	unsigned long long dividend = exponential;	
		for (i=1; i<=ITERATIONS; i++) {
			log = 0;
			dividend = exponential;
			{
            asm(
                    "movq %1, %%rcx;"
                    "bsr %%rcx, %0;"
                    : "=r"(log)
                    : "r"(dividend)
                    : "%rcx"
               );
            }

		}
	printf("%llu log %llu is %i\n",exponential,base,log);
	return EXIT_SUCCESS;
}
