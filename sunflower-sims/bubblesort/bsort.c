#include "bsort-input.h"

int
main(void)
{
	volatile unsigned int *		gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int i;
	int maxindex = bsort_input_len - 1;

	while (maxindex > 0)
	{
		for (i = 0; i < maxindex; i++)
		{
			if (bsort_input[i] > bsort_input[i+1])
			{
				/*		swap		*/
				bsort_input[i] ^= bsort_input[i+1];
				bsort_input[i+1] ^= bsort_input[i];
				bsort_input[i] ^= bsort_input[i+1];
			}
		}
		maxindex--;
	}
	if (bsort_input[10] == 32 && bsort_input[16] == 46 && bsort_input[32] == 105) {
		*gDebugLedsMemoryMappedRegister = 0xFF ^ *gDebugLedsMemoryMappedRegister;
	}

	return 0;
}

