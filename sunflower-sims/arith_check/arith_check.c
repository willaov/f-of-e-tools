#include "arith_check_input.h"

void multiply(int mat1[][N], int mat2[][N], int res[][N]) {
	int i, j, k;
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			res[i][j] = 0;
			for (k = 0; k < N; k++)
				res[i][j] += mat1[i][k] * mat2[k][j];
		}
	}
}

void subtract(int mat1[][N], int mat2[][N], int res[][N]) {
	int i, j;
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			res[i][j] = 0;
			res[i][j] += mat1[i][j] - mat2[i][j];
		}
	}
}

int accumulate(int res[][N]) {
	int result = 0;
	int i, j;
	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			result = result + res[i][j];
		}
	}
	return result;
}

// void flashBinary(int res) {
// 	volatile unsigned int *		gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
// 	for (int j = 0; j < 32; j++) {
// 		if (((res >> (15 - j)) & 0b1) == 1) {
// 			*gDebugLedsMemoryMappedRegister = 0xFF;
// 			//printf("1");
// 		} else {
// 			*gDebugLedsMemoryMappedRegister = 0x00;
// 			// printf("0");
// 		}
// 		for (int j = 0; j < 100000; j++);
// 	}
// }

int main() {
	volatile unsigned int *		gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int res1[N][N]; 
	int res2[N][N];
	int a, b, c, d;

	// Do some arithmetic on input arrays
	multiply(A, B, res1);
	multiply(A, B, res1);
	multiply(A, B, res1);
	multiply(A, B, res1);
	subtract(A, B, res2);

	a = accumulate(A);
	b = accumulate(B);
	c = accumulate(res1);
	d = accumulate(res2);
	
	int result = a*b - c*d;
	// printf("%d \n", result);

	// check if result is correct
	if (result == 81468676) {
		// if a long pause with LED on is observed on first run of the program,
		// then execution was correct.
		*gDebugLedsMemoryMappedRegister = 0xFF;
		for (int j = 0; j < 2000000; j++);
	}
	
	*gDebugLedsMemoryMappedRegister = 0xFF ^ *gDebugLedsMemoryMappedRegister; // used to determine period
	return 0;
}

//sudo iceprog -S ../../verilog/hardware/processor/sail.bin