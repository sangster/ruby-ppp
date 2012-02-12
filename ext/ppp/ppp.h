#ifndef PPP_H
#define PPP_H


#include "rijndael.h"
#include "sha2.h"

#ifdef __cplusplus
extern "C" {
#endif

#pragma pack(push,1)

typedef unsigned char Byte;
typedef unsigned long long SixtyFour;

typedef union __OneTwoEight {
  struct {
    SixtyFour low;
    SixtyFour high;
  } sixtyfour;
  Byte byte[16];
} OneTwoEight;

typedef struct __SequenceKey {
  Byte byte[SHA256_DIGEST_SIZE];
} SequenceKey;

#pragma pack(pop)

#define KEY_BITS (int)256

int ConvertHexToKey( char * hex, SequenceKey * key );
void GenerateRandomSequenceKey( SequenceKey * sequenceKey );
void GenerateSequenceKeyFromString( char * string, SequenceKey * sequenceKey );
char * RetrievePasscodes( OneTwoEight firstPasscodeNumber, int passcodeCount, SequenceKey * sequenceKey,
                          const char * sourceAlphabet, int passcodeLength );


#ifdef __cplusplus
}
#endif

#endif /* PPP_H */
