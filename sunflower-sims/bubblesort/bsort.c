#include "sf-types.h"
#include "sh7708.h"
#include "devscc.h"
#include "bsort-input.h"

int
main(void)
{
	volatile unsigned int *		gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int i;
	int maxindex = bsort_input_len - 1;

	while (maxindex > 0)
	{
		*gDebugLedsMemoryMappedRegister = 0xFF ^ *gDebugLedsMemoryMappedRegister;
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

	return 0;
}

