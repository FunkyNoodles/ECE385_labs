/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  input: a character c (e.g. 'A')
 *  output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  input: two characters c1 and c2 (e.g. 'A' and '7')
 *  output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

// Perform AES Encryption in Software
void encrypt(unsigned char * plaintext_asc, unsigned char * key_asc, unsigned long * state, unsigned long * key)
{

}

// Perform AES Decryption in Hardware
void decrypt(unsigned long * state, unsigned long * key)
{

}

int main()
{
	// Input Message and Key as 32x 8bit ASCII Characters ([33] is for NULL terminator)
	unsigned char plaintext_asc[33];
	unsigned char key_asc[33];
	// Key and Encrypted Message in 4x 32bit Format
	unsigned long state[4];
	unsigned long key[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		while (1) {
			int i = 0;
			printf("\nEnter plain text:\n");
			scanf("%s", plaintext_asc);
			printf("\n");
			printf("\nEnter key:\n");
			scanf("%s", key_asc);
			printf("\n");
			encrypt(plaintext_asc, key_asc, state, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08lX\n", state[i])
			}
			decrypt(state, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08lX\n", state[i])
			}
		}
	}
	else {
		int i = 0;
		int size_KB = 1;
		for (i = 0; i < 32; i++) {
			plaintext_asc[i] = 'a';
			key_asc[i] = 'b';
		}

		clock_t begin = clock();
		for (i = 0; i < size_KB * 128; i++)
			encrypt(plaintext_asc, key_asc, state, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;

		printf("Software Encryption Speed: %f KB/s \n", speed);

		begin = clock();
		for (i = 0; i < size_KB * 128; i++)
			decrypt(state, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;

		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
