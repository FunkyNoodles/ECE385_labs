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
volatile unsigned int* AES_PTR = (unsigned int *) 0x00000100;

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


void printMatrix(unsigned long* mat) {
    int i, j;
    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            unsigned long a = (mat[i] >> (24 - 8 * j)) & 0xFF;
            printf("%02x ", (unsigned char)a);
        }
        printf("\n");
    }
    printf("\n");
}


void SubBytes(unsigned long* state)
{
    unsigned long mask = 0x0F;
    unsigned long value;
    int row, col;
    for (row = 0; row < 4; ++row)
    {
        unsigned long test = state[row];
        state[row] = 0;
        for (col = 0; col < 4; ++col)
        {
            value = (test >> (24 - (8 * col))) & 0xFF;

            unsigned long vertical_index = (value >> 4) & mask;
            unsigned long horizontal_index = value & mask;

            unsigned long s_box_value = (unsigned long)aes_sbox[(vertical_index * 16) + horizontal_index];
            state[row] |= s_box_value << (24 - 8 * col);
        }
    }
}


void ShiftRows(unsigned long* state)
{
    int i, j;
    unsigned long temp;
    for (i = 1; i < 4; i++)
    {
        for (j = 0; j < i; j++)
        {
            temp = (state[i] >> 24) & 0xFF;
            state[i] = (state[i] << 8) | temp;
            state[i] &= 0xFFFFFFFF;
        }
    }
}


unsigned char xtime(unsigned char c)
{
    unsigned char y = (c & 0x80) >> 7;
    unsigned char t = c << 1;
    if (y)
        t ^= 0x1B;
    return t;
}


void MixColumns(unsigned long* state)
{
    unsigned char temp_storage[16];

    unsigned long one = state[0];
    unsigned long two = state[1];
    unsigned long three = state[2];
    unsigned long four = state[3];
    unsigned char a, b, c, d;
    int i,j;

    for (i = 0; i < 4; ++i)
        state[i] = 0;

    for (i = 0; i < 4; ++i)
    {
        a = ((one >> (24 - (8 * i))) & 0xFF);
        b = ((two >> (24 - (8 * i))) & 0xFF);
        c = ((three >> (24 - (8 * i))) & 0xFF);
        d = ((four >> (24 - (8 * i))) & 0xFF);
        temp_storage[i] = xtime(a) ^ (xtime(b) ^ b) ^ (c) ^ (d);
        temp_storage[i + 4] = (a) ^ (xtime(b)) ^ (xtime(c) ^ c) ^ (d);
        temp_storage[i + 8] = (a) ^ (b) ^ (xtime(c)) ^ (xtime(d) ^ d);
        temp_storage[i + 12] = (xtime(a) ^ a) ^ (b) ^ (c) ^ (xtime(d));
    }

    for (i = 0; i < 4; ++i)
    {
        unsigned long set_val = 0;
        for (j = 0; j < 4; ++j)
        {
            set_val |= temp_storage[i * 4 + j];
            if (j == 3)
                break;
            set_val = set_val << 8;
        }
        state[i] = set_val;
    }
}


void AddRoundKey(unsigned long* state, unsigned long round_key[11][4], int key_index)
{
	int i;
    for (i = 0; i < 4; ++i)
        state[i] ^= round_key[key_index][i];
}


// Puts the cipher key into the key array
void KeyToHex(unsigned char* key_asc, unsigned long* key)
{
    unsigned char temp_storage[16];
    int i,j;
    for (i = 0; i < 32; i += 2)
    {
        char char_one = key_asc[i];
        char char_two = key_asc[i + 1];
        char new_char = charsToHex(char_one, char_two);
        temp_storage[i / 2] = new_char;
    }

    unsigned long set_val = 0;
    for (i = 0; i < 4; ++i)
    {
        set_val = 0;
        for (j = 0; j < 4; ++j)
        {
            set_val |= temp_storage[(j * 4) + i];
            if (j == 3)
                break;
            set_val = set_val << 8;
        }
        key[i] = set_val;
    }
}


void KeySchedule(unsigned long key[11][4]) {
    int i, j, k;
    unsigned long first_op, new_op, back_col, new_col;
    unsigned long mask;
    unsigned long check_mask = 0xFFFFFFFF;
    int row, col, index;

    unsigned long rcon[10] = {
        0x01000000,
        0x02000000,
        0x04000000,
        0x08000000,
        0x10000000,
        0x20000000,
        0x40000000,
        0x80000000,
        0x1b000000,
        0x36000000
    };

    for (i = 0; i < 10; i++) {
        //grab first row and shift.
        first_op = 0;
        row = 0;
        col = 0;
        new_op = 0;
        back_col = 0;
        new_op = 0;
        new_col = 0;
        mask = 0xF0000000;
        for (j = 1; j < 5; j++)
            first_op |= (key[i][j % 4] & 0xFF) << (24 - (8 * (j - 1)));

        //subbytes it.
        for (j = 0; j < 8; j += 2) {
            row = (mask & first_op) >> (28 - j * 4);
            mask = mask >> 4;
            col = (mask & first_op) >> (24 - j * 4);
            mask = mask >> 4;
            index = row * 16 + col;
            new_op |= ((unsigned long)aes_sbox[index] << (24 - (8 * (j / 2)))) & check_mask;
        }

        //grab the first column from key
        mask = 0xFF000000;
        for (j = 0; j < 4; j++)
            back_col |= (key[i][j] & mask) >> (8 * (j));
        //start xoring
        new_col = new_op ^ back_col ^ rcon[i];

        //put new col back into matrix.
        for (j = 0; j < 4; j++) {
            key[i + 1][j] |= ((new_col >> (24 - (8 * j))) & 0xFF) << 24;
        }

        //xor the rest of the columns
        mask = 0x00FF0000;
        for (j = 0; j < 3; j++) {
            for (k = 0; k < 4; k++) {
                key[i + 1][k] |= (key[i][k] & mask) ^ ((key[i + 1][k] >> 8) & mask);
            }
            mask = mask >> 8;
        }

    }
}


// Perform AES Encryption in Software
void encrypt(unsigned char* plaintext_asc, unsigned char* key_asc, unsigned long* state, unsigned long* key)
{
    // Create space for the round key
    unsigned long round_key[11][4];
    int i,j;
    // Initializes the values in the array
    for (i = 0; i < 11; ++i)
    {
        for (j = 0; j < 4; ++j)
        {
            round_key[i][j] = 0;
        }
    }

    int Nr = 10;
    int round = 0;

    // Converts the key from ASCII to hex values and stores it into key pointer
    KeyToHex(key_asc, key);
    // Copies the ciphered key into the first entry of the round key
    KeyToHex(key_asc, round_key[0]);
    // Converts the plain-text from ASCII to hex values and stores it into the state array
    KeyToHex(plaintext_asc, state);

    // Initialize the round key array
    KeySchedule(round_key);

    //printf("initial State:\n");
    //printMatrix(state);
    //printf("round_key[0]:\n");
    //printMatrix(round_key[0]);
    AddRoundKey(state, round_key, 0);


    // // Follow the pseudo code in the PDF - should be VERY similar
    for (round = 1; round < Nr; ++round) {
    	//printf("State %d:\n", round);
    	//printMatrix(state);
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state, round_key, round);
    }
    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state, round_key, 10);
}

// Perform AES Decryption in Hardware
void decrypt(unsigned long* state, unsigned long* key)
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
            AES_PTR[0] = key[0];
            AES_PTR[1] = key[1];
            AES_PTR[2] = key[2];
            AES_PTR[3] = key[3];
            printf("\nEncrypted message is: \n");
            for (i = 0; i < 4; i++)
                printf("%08lX\n", state[i]);
            decrypt(state, key);
            printf("\nDecrypted message is: \n");
            for (i = 0; i < 4; i++)
                printf("%08lX\n", state[i]);
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

// 000102030405060708090a0b0c0d0e0f
