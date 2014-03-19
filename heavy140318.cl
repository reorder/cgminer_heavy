#define ROL32(x, n) rotate(x, (uint) n)
#define SWAP32(a) (as_uint(as_uchar4(a).wzyx))
#define SWAP64(n)       (as_ulong(as_uchar8(n).s76543210))

#define rol64hackl(n) \
inline ulong rol64_ ## n  (ulong l) \
{ \
    uint2 t = rotate(as_uint2(l), (n)); \
    return as_ulong((uint2)(bitselect(t.s0, t.s1, (uint)(1 << (n)) - 1), bitselect(t.s0, t.s1, (uint)(~((1 << (n)) - 1))))); \
}

#define rol64hackr(n) \
inline ulong rol64_ ## n  (ulong l) \
{ \
    uint2 t = rotate(as_uint2(l), (n - 32)); \
    return as_ulong((uint2)(bitselect(t.s1, t.s0, (uint)(1 << (n - 32)) - 1), bitselect(t.s1, t.s0, (uint)(~((1 << (n - 32)) - 1))))); \
}

#define rol64_32(l) as_ulong(as_uint2(l).yx)

rol64hackl(1)
rol64hackl(2)
rol64hackl(3)
rol64hackl(6)
rol64hackl(8)
rol64hackl(10)
rol64hackl(14)
rol64hackl(15)
rol64hackl(18)
rol64hackl(20)
rol64hackl(21)
rol64hackl(25)
rol64hackl(27)
rol64hackl(28)
rol64hackr(36)
rol64hackr(39)
rol64hackr(41)
rol64hackr(43)
rol64hackr(44)
rol64hackr(45)
rol64hackr(48)
rol64hackr(53)
rol64hackr(55)
rol64hackr(56)
rol64hackr(61)
rol64hackr(62)

__constant uint K[] = {
    0x428a2f98UL, 0x71374491UL, 0xb5c0fbcfUL, 0xe9b5dba5UL,
    0x3956c25bUL, 0x59f111f1UL, 0x923f82a4UL, 0xab1c5ed5UL,
    0xd807aa98UL, 0x12835b01UL, 0x243185beUL, 0x550c7dc3UL,
    0x72be5d74UL, 0x80deb1feUL, 0x9bdc06a7UL, 0xc19bf174UL,
    0xe49b69c1UL, 0xefbe4786UL, 0x0fc19dc6UL, 0x240ca1ccUL,
    0x2de92c6fUL, 0x4a7484aaUL, 0x5cb0a9dcUL, 0x76f988daUL,
    0x983e5152UL, 0xa831c66dUL, 0xb00327c8UL, 0xbf597fc7UL,
    0xc6e00bf3UL, 0xd5a79147UL, 0x06ca6351UL, 0x14292967UL,
    0x27b70a85UL, 0x2e1b2138UL, 0x4d2c6dfcUL, 0x53380d13UL,
    0x650a7354UL, 0x766a0abbUL, 0x81c2c92eUL, 0x92722c85UL,
    0xa2bfe8a1UL, 0xa81a664bUL, 0xc24b8b70UL, 0xc76c51a3UL,
    0xd192e819UL, 0xd6990624UL, 0xf40e3585UL, 0x106aa070UL,
    0x19a4c116UL, 0x1e376c08UL, 0x2748774cUL, 0x34b0bcb5UL,
    0x391c0cb3UL, 0x4ed8aa4aUL, 0x5b9cca4fUL, 0x682e6ff3UL,
    0x748f82eeUL, 0x78a5636fUL, 0x84c87814UL, 0x8cc70208UL,
    0x90befffaUL, 0xa4506cebUL, 0xbef9a3f7UL, 0xc67178f2UL
};

#define S0(x) (ROL32(x, 25) ^ ROL32(x, 14) ^  (x >> 3))
#define S1(x) (ROL32(x, 15) ^ ROL32(x, 13) ^  (x >> 10))

#define S2(x) (ROL32(x, 30) ^ ROL32(x, 19) ^ ROL32(x, 10))
#define S3(x) (ROL32(x, 26) ^ ROL32(x, 21) ^ ROL32(x, 7))

#define P(a,b,c,d,e,f,g,h,x,K)                  \
{                                               \
    temp1 = h + S3(e) + F1(e,f,g) + (K + x);      \
    d += temp1; h = temp1 + S2(a) + F0(a,b,c);  \
}

#define PLAST(a,b,c,d,e,f,g,h,x,K)                  \
{                                               \
    d += h + S3(e) + F1(e,f,g) + (x + K);              \
}

#define F0(y, x, z) bitselect(z, y, z ^ x)
#define F1(x, y, z) bitselect(z, y, x)

#define R0 (W[0] = S1(W[14]) + W[9] + S0(W[1]) + W[0])
#define R1 (W[1] = S1(W[15]) + W[10] + S0(W[2]) + W[1])
#define R2 (W[2] = S1(W[0]) + W[11] + S0(W[3]) + W[2])
#define R3 (W[3] = S1(W[1]) + W[12] + S0(W[4]) + W[3])
#define R4 (W[4] = S1(W[2]) + W[13] + S0(W[5]) + W[4])
#define R5 (W[5] = S1(W[3]) + W[14] + S0(W[6]) + W[5])
#define R6 (W[6] = S1(W[4]) + W[15] + S0(W[7]) + W[6])
#define R7 (W[7] = S1(W[5]) + W[0] + S0(W[8]) + W[7])
#define R8 (W[8] = S1(W[6]) + W[1] + S0(W[9]) + W[8])
#define R9 (W[9] = S1(W[7]) + W[2] + S0(W[10]) + W[9])
#define R10 (W[10] = S1(W[8]) + W[3] + S0(W[11]) + W[10])
#define R11 (W[11] = S1(W[9]) + W[4] + S0(W[12]) + W[11])
#define R12 (W[12] = S1(W[10]) + W[5] + S0(W[13]) + W[12])
#define R13 (W[13] = S1(W[11]) + W[6] + S0(W[14]) + W[13])
#define R14 (W[14] = S1(W[12]) + W[7] + S0(W[15]) + W[14])
#define R15 (W[15] = S1(W[13]) + W[8] + S0(W[0]) + W[15])

inline uint sha256_116_last(const uint *data)
{
    uint temp1;
    uint W[16];
    for (int i = 0; i < 16; i++)
        W[i] = data[i];

    uint s7;

    uint v0 = 0x6A09E667;
    uint v1 = 0xBB67AE85;
    uint v2 = 0x3C6EF372;
    uint v3 = 0xA54FF53A;
    uint v4 = 0x510E527F;
    uint v5 = 0x9B05688C;
    uint v6 = 0x1F83D9AB;
    uint v7 = 0x5BE0CD19;

    P( v0, v1, v2, v3, v4, v5, v6, v7, W[0], 0x428A2F98 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, W[1], 0x71374491 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, W[2], 0xB5C0FBCF );
    P( v5, v6, v7, v0, v1, v2, v3, v4, W[3], 0xE9B5DBA5 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, W[4], 0x3956C25B );
    P( v3, v4, v5, v6, v7, v0, v1, v2, W[5], 0x59F111F1 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, W[6], 0x923F82A4 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, W[7], 0xAB1C5ED5 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, W[8], 0xD807AA98 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, W[9], 0x12835B01 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, W[10], 0x243185BE );
    P( v5, v6, v7, v0, v1, v2, v3, v4, W[11], 0x550C7DC3 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, W[12], 0x72BE5D74 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, W[13], 0x80DEB1FE );
    P( v2, v3, v4, v5, v6, v7, v0, v1, W[14], 0x9BDC06A7 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, W[15], 0xC19BF174 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0, 0xE49B69C1 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1, 0xEFBE4786 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2, 0x0FC19DC6 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3, 0x240CA1CC );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4, 0x2DE92C6F );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5, 0x4A7484AA );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6, 0x5CB0A9DC );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7, 0x76F988DA );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8, 0x983E5152 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9, 0xA831C66D );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xB00327C8 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xBF597FC7 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xC6E00BF3 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD5A79147 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R14, 0x06CA6351 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x14292967 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0,  0x27B70A85 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1,  0x2E1B2138 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x4D2C6DFC );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x53380D13 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x650A7354 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x766A0ABB );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x81C2C92E );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x92722C85 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8,  0xA2BFE8A1 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9,  0xA81A664B );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xC24B8B70 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xC76C51A3 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xD192E819 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD6990624 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R14, 0xF40E3585 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x106AA070 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0,  0x19A4C116 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1,  0x1E376C08 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x2748774C );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x34B0BCB5 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x391C0CB3 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x4ED8AA4A );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x5B9CCA4F );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x682E6FF3 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8,  0x748F82EE );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9,  0x78A5636F );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0x84C87814 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0x8CC70208 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0x90BEFFFA );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xA4506CEB );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R14, 0xBEF9A3F7 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R15, 0xC67178F2 );

    v0 += 0x6A09E667;
    v1 += 0xBB67AE85;
    v2 += 0x3C6EF372;
    v3 += 0xA54FF53A;
    v4 += 0x510E527F;
    v5 += 0x9B05688C;
    v6 += 0x1F83D9AB;
    v7 += 0x5BE0CD19;

    s7 = v7;

    for (int i = 16; i < 29; i++)
        W[i - 16] = data[i];
    W[13] = 0x80000000;
    W[14] = 0;
    W[15] = 116*8;

    P( v0, v1, v2, v3, v4, v5, v6, v7, W[0], 0x428A2F98 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, W[1], 0x71374491 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, W[2], 0xB5C0FBCF );
    P( v5, v6, v7, v0, v1, v2, v3, v4, W[3], 0xE9B5DBA5 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, W[4], 0x3956C25B );
    P( v3, v4, v5, v6, v7, v0, v1, v2, W[5], 0x59F111F1 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, W[6], 0x923F82A4 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, W[7], 0xAB1C5ED5 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, W[8], 0xD807AA98 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, W[9], 0x12835B01 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, W[10], 0x243185BE );
    P( v5, v6, v7, v0, v1, v2, v3, v4, W[11], 0x550C7DC3 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, W[12], 0x72BE5D74 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, W[13], 0x80DEB1FE );
    P( v2, v3, v4, v5, v6, v7, v0, v1, W[14], 0x9BDC06A7 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, W[15], 0xC19BF174 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0, 0xE49B69C1 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1, 0xEFBE4786 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2, 0x0FC19DC6 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3, 0x240CA1CC );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4, 0x2DE92C6F );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5, 0x4A7484AA );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6, 0x5CB0A9DC );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7, 0x76F988DA );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8, 0x983E5152 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9, 0xA831C66D );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xB00327C8 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xBF597FC7 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xC6E00BF3 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD5A79147 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R14, 0x06CA6351 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x14292967 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0,  0x27B70A85 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1,  0x2E1B2138 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x4D2C6DFC );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x53380D13 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x650A7354 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x766A0ABB );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x81C2C92E );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x92722C85 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8,  0xA2BFE8A1 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9,  0xA81A664B );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0xC24B8B70 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0xC76C51A3 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0xD192E819 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R13, 0xD6990624 );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R14, 0xF40E3585 );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R15, 0x106AA070 );

    P( v0, v1, v2, v3, v4, v5, v6, v7, R0,  0x19A4C116 );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R1,  0x1E376C08 );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R2,  0x2748774C );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R3,  0x34B0BCB5 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R4,  0x391C0CB3 );
    P( v3, v4, v5, v6, v7, v0, v1, v2, R5,  0x4ED8AA4A );
    P( v2, v3, v4, v5, v6, v7, v0, v1, R6,  0x5B9CCA4F );
    P( v1, v2, v3, v4, v5, v6, v7, v0, R7,  0x682E6FF3 );
    P( v0, v1, v2, v3, v4, v5, v6, v7, R8,  0x748F82EE );
    P( v7, v0, v1, v2, v3, v4, v5, v6, R9,  0x78A5636F );
    P( v6, v7, v0, v1, v2, v3, v4, v5, R10, 0x84C87814 );
    P( v5, v6, v7, v0, v1, v2, v3, v4, R11, 0x8CC70208 );
    P( v4, v5, v6, v7, v0, v1, v2, v3, R12, 0x90BEFFFA );
    v7 += s7;
    return SWAP32(v7);
}

#define BLAKE_CST0 0x243F6A8885A308D3UL
#define BLAKE_CST1 0x13198A2E03707344UL
#define BLAKE_CST2 0xA4093822299F31D0UL
#define BLAKE_CST3 0x082EFA98EC4E6C89UL
#define BLAKE_CST4 0x452821E638D01377UL
#define BLAKE_CST5 0xBE5466CF34E90C6CUL
#define BLAKE_CST6 0xC0AC29B7C97C50DDUL
#define BLAKE_CST7 0x3F84D5B5B5470917UL
#define BLAKE_CST8 0x9216D5D98979FB1BUL
#define BLAKE_CST9 0xD1310BA698DFB5ACUL
#define BLAKE_CSTA 0x2FFD72DBD01ADFB7UL
#define BLAKE_CSTB 0xB8E1AFED6A267E96UL
#define BLAKE_CSTC 0xBA7C9045F12C7F99UL
#define BLAKE_CSTD 0x24A19947B3916CF7UL
#define BLAKE_CSTE 0x0801F2E2858EFC16UL
#define BLAKE_CSTF 0x636920D871574E69UL

#define blake512_mut00_0(V, MSG) V##0 += (MSG##0 ^ BLAKE_CST1) + V##4; V##1 += (MSG##2 ^ BLAKE_CST3) + V##5; V##2 += (MSG##4 ^ BLAKE_CST5) + V##6; V##3 += (MSG##6 ^ BLAKE_CST7) + V##7;
#define blake512_mut00_1(V, MSG) V##0 += (MSG##E ^ BLAKE_CSTA) + V##4; V##1 += (MSG##4 ^ BLAKE_CST8) + V##5; V##2 += (MSG##9 ^ BLAKE_CSTF) + V##6; V##3 += (MSG##D ^ BLAKE_CST6) + V##7;
#define blake512_mut00_2(V, MSG) V##0 += (MSG##B ^ BLAKE_CST8) + V##4; V##1 += (MSG##C ^ BLAKE_CST0) + V##5; V##2 += (MSG##5 ^ BLAKE_CST2) + V##6; V##3 += (MSG##F ^ BLAKE_CSTD) + V##7;
#define blake512_mut00_3(V, MSG) V##0 += (MSG##7 ^ BLAKE_CST9) + V##4; V##1 += (MSG##3 ^ BLAKE_CST1) + V##5; V##2 += (MSG##D ^ BLAKE_CSTC) + V##6; V##3 += (MSG##B ^ BLAKE_CSTE) + V##7;
#define blake512_mut00_4(V, MSG) V##0 += (MSG##9 ^ BLAKE_CST0) + V##4; V##1 += (MSG##5 ^ BLAKE_CST7) + V##5; V##2 += (MSG##2 ^ BLAKE_CST4) + V##6; V##3 += (MSG##A ^ BLAKE_CSTF) + V##7;
#define blake512_mut00_5(V, MSG) V##0 += (MSG##2 ^ BLAKE_CSTC) + V##4; V##1 += (MSG##6 ^ BLAKE_CSTA) + V##5; V##2 += (MSG##0 ^ BLAKE_CSTB) + V##6; V##3 += (MSG##8 ^ BLAKE_CST3) + V##7;
#define blake512_mut00_6(V, MSG) V##0 += (MSG##C ^ BLAKE_CST5) + V##4; V##1 += (MSG##1 ^ BLAKE_CSTF) + V##5; V##2 += (MSG##E ^ BLAKE_CSTD) + V##6; V##3 += (MSG##4 ^ BLAKE_CSTA) + V##7;
#define blake512_mut00_7(V, MSG) V##0 += (MSG##D ^ BLAKE_CSTB) + V##4; V##1 += (MSG##7 ^ BLAKE_CSTE) + V##5; V##2 += (MSG##C ^ BLAKE_CST1) + V##6; V##3 += (MSG##3 ^ BLAKE_CST9) + V##7;
#define blake512_mut00_8(V, MSG) V##0 += (MSG##6 ^ BLAKE_CSTF) + V##4; V##1 += (MSG##E ^ BLAKE_CST9) + V##5; V##2 += (MSG##B ^ BLAKE_CST3) + V##6; V##3 += (MSG##0 ^ BLAKE_CST8) + V##7;
#define blake512_mut00_9(V, MSG) V##0 += (MSG##A ^ BLAKE_CST2) + V##4; V##1 += (MSG##8 ^ BLAKE_CST4) + V##5; V##2 += (MSG##7 ^ BLAKE_CST6) + V##6; V##3 += (MSG##1 ^ BLAKE_CST5) + V##7;

#define blake512_mut01_0(V, MSG) V##0 += (MSG##1 ^ BLAKE_CST0) + V##4; V##1 += (MSG##3 ^ BLAKE_CST2) + V##5; V##2 += (MSG##5 ^ BLAKE_CST4) + V##6; V##3 += (MSG##7 ^ BLAKE_CST6) + V##7;
#define blake512_mut01_1(V, MSG) V##0 += (MSG##A ^ BLAKE_CSTE) + V##4; V##1 += (MSG##8 ^ BLAKE_CST4) + V##5; V##2 += (MSG##F ^ BLAKE_CST9) + V##6; V##3 += (MSG##6 ^ BLAKE_CSTD) + V##7;
#define blake512_mut01_2(V, MSG) V##0 += (MSG##8 ^ BLAKE_CSTB) + V##4; V##1 += (MSG##0 ^ BLAKE_CSTC) + V##5; V##2 += (MSG##2 ^ BLAKE_CST5) + V##6; V##3 += (MSG##D ^ BLAKE_CSTF) + V##7;
#define blake512_mut01_3(V, MSG) V##0 += (MSG##9 ^ BLAKE_CST7) + V##4; V##1 += (MSG##1 ^ BLAKE_CST3) + V##5; V##2 += (MSG##C ^ BLAKE_CSTD) + V##6; V##3 += (MSG##E ^ BLAKE_CSTB) + V##7;
#define blake512_mut01_4(V, MSG) V##0 += (MSG##0 ^ BLAKE_CST9) + V##4; V##1 += (MSG##7 ^ BLAKE_CST5) + V##5; V##2 += (MSG##4 ^ BLAKE_CST2) + V##6; V##3 += (MSG##F ^ BLAKE_CSTA) + V##7;
#define blake512_mut01_5(V, MSG) V##0 += (MSG##C ^ BLAKE_CST2) + V##4; V##1 += (MSG##A ^ BLAKE_CST6) + V##5; V##2 += (MSG##B ^ BLAKE_CST0) + V##6; V##3 += (MSG##3 ^ BLAKE_CST8) + V##7;
#define blake512_mut01_6(V, MSG) V##0 += (MSG##5 ^ BLAKE_CSTC) + V##4; V##1 += (MSG##F ^ BLAKE_CST1) + V##5; V##2 += (MSG##D ^ BLAKE_CSTE) + V##6; V##3 += (MSG##A ^ BLAKE_CST4) + V##7;
#define blake512_mut01_7(V, MSG) V##0 += (MSG##B ^ BLAKE_CSTD) + V##4; V##1 += (MSG##E ^ BLAKE_CST7) + V##5; V##2 += (MSG##1 ^ BLAKE_CSTC) + V##6; V##3 += (MSG##9 ^ BLAKE_CST3) + V##7;
#define blake512_mut01_8(V, MSG) V##0 += (MSG##F ^ BLAKE_CST6) + V##4; V##1 += (MSG##9 ^ BLAKE_CSTE) + V##5; V##2 += (MSG##3 ^ BLAKE_CSTB) + V##6; V##3 += (MSG##8 ^ BLAKE_CST0) + V##7;
#define blake512_mut01_9(V, MSG) V##0 += (MSG##2 ^ BLAKE_CSTA) + V##4; V##1 += (MSG##4 ^ BLAKE_CST8) + V##5; V##2 += (MSG##6 ^ BLAKE_CST7) + V##6; V##3 += (MSG##5 ^ BLAKE_CST1) + V##7;

#define blake512_mut10_0(V, MSG) V##0 += (MSG##8 ^ BLAKE_CST9) + V##5; V##1 += (MSG##A ^ BLAKE_CSTB) + V##6; V##2 += (MSG##C ^ BLAKE_CSTD) + V##7; V##3 += (MSG##E ^ BLAKE_CSTF) + V##4;
#define blake512_mut10_1(V, MSG) V##0 += (MSG##1 ^ BLAKE_CSTC) + V##5; V##1 += (MSG##0 ^ BLAKE_CST2) + V##6; V##2 += (MSG##B ^ BLAKE_CST7) + V##7; V##3 += (MSG##5 ^ BLAKE_CST3) + V##4;
#define blake512_mut10_2(V, MSG) V##0 += (MSG##A ^ BLAKE_CSTE) + V##5; V##1 += (MSG##3 ^ BLAKE_CST6) + V##6; V##2 += (MSG##7 ^ BLAKE_CST1) + V##7; V##3 += (MSG##9 ^ BLAKE_CST4) + V##4;
#define blake512_mut10_3(V, MSG) V##0 += (MSG##2 ^ BLAKE_CST6) + V##5; V##1 += (MSG##5 ^ BLAKE_CSTA) + V##6; V##2 += (MSG##4 ^ BLAKE_CST0) + V##7; V##3 += (MSG##F ^ BLAKE_CST8) + V##4;
#define blake512_mut10_4(V, MSG) V##0 += (MSG##E ^ BLAKE_CST1) + V##5; V##1 += (MSG##B ^ BLAKE_CSTC) + V##6; V##2 += (MSG##6 ^ BLAKE_CST8) + V##7; V##3 += (MSG##3 ^ BLAKE_CSTD) + V##4;
#define blake512_mut10_5(V, MSG) V##0 += (MSG##4 ^ BLAKE_CSTD) + V##5; V##1 += (MSG##7 ^ BLAKE_CST5) + V##6; V##2 += (MSG##F ^ BLAKE_CSTE) + V##7; V##3 += (MSG##1 ^ BLAKE_CST9) + V##4;
#define blake512_mut10_6(V, MSG) V##0 += (MSG##0 ^ BLAKE_CST7) + V##5; V##1 += (MSG##6 ^ BLAKE_CST3) + V##6; V##2 += (MSG##9 ^ BLAKE_CST2) + V##7; V##3 += (MSG##8 ^ BLAKE_CSTB) + V##4;
#define blake512_mut10_7(V, MSG) V##0 += (MSG##5 ^ BLAKE_CST0) + V##5; V##1 += (MSG##F ^ BLAKE_CST4) + V##6; V##2 += (MSG##8 ^ BLAKE_CST6) + V##7; V##3 += (MSG##2 ^ BLAKE_CSTA) + V##4;
#define blake512_mut10_8(V, MSG) V##0 += (MSG##C ^ BLAKE_CST2) + V##5; V##1 += (MSG##D ^ BLAKE_CST7) + V##6; V##2 += (MSG##1 ^ BLAKE_CST4) + V##7; V##3 += (MSG##A ^ BLAKE_CST5) + V##4;
#define blake512_mut10_9(V, MSG) V##0 += (MSG##F ^ BLAKE_CSTB) + V##5; V##1 += (MSG##9 ^ BLAKE_CSTE) + V##6; V##2 += (MSG##3 ^ BLAKE_CSTC) + V##7; V##3 += (MSG##D ^ BLAKE_CST0) + V##4;

#define blake512_mut11_0(V, MSG) V##0 += (MSG##9 ^ BLAKE_CST8) + V##5; V##1 += (MSG##B ^ BLAKE_CSTA) + V##6; V##2 += (MSG##D ^ BLAKE_CSTC) + V##7; V##3 += (MSG##F ^ BLAKE_CSTE) + V##4;
#define blake512_mut11_1(V, MSG) V##0 += (MSG##C ^ BLAKE_CST1) + V##5; V##1 += (MSG##2 ^ BLAKE_CST0) + V##6; V##2 += (MSG##7 ^ BLAKE_CSTB) + V##7; V##3 += (MSG##3 ^ BLAKE_CST5) + V##4;
#define blake512_mut11_2(V, MSG) V##0 += (MSG##E ^ BLAKE_CSTA) + V##5; V##1 += (MSG##6 ^ BLAKE_CST3) + V##6; V##2 += (MSG##1 ^ BLAKE_CST7) + V##7; V##3 += (MSG##4 ^ BLAKE_CST9) + V##4;
#define blake512_mut11_3(V, MSG) V##0 += (MSG##6 ^ BLAKE_CST2) + V##5; V##1 += (MSG##A ^ BLAKE_CST5) + V##6; V##2 += (MSG##0 ^ BLAKE_CST4) + V##7; V##3 += (MSG##8 ^ BLAKE_CSTF) + V##4;
#define blake512_mut11_4(V, MSG) V##0 += (MSG##1 ^ BLAKE_CSTE) + V##5; V##1 += (MSG##C ^ BLAKE_CSTB) + V##6; V##2 += (MSG##8 ^ BLAKE_CST6) + V##7; V##3 += (MSG##D ^ BLAKE_CST3) + V##4;
#define blake512_mut11_5(V, MSG) V##0 += (MSG##D ^ BLAKE_CST4) + V##5; V##1 += (MSG##5 ^ BLAKE_CST7) + V##6; V##2 += (MSG##E ^ BLAKE_CSTF) + V##7; V##3 += (MSG##9 ^ BLAKE_CST1) + V##4;
#define blake512_mut11_6(V, MSG) V##0 += (MSG##7 ^ BLAKE_CST0) + V##5; V##1 += (MSG##3 ^ BLAKE_CST6) + V##6; V##2 += (MSG##2 ^ BLAKE_CST9) + V##7; V##3 += (MSG##B ^ BLAKE_CST8) + V##4;
#define blake512_mut11_7(V, MSG) V##0 += (MSG##0 ^ BLAKE_CST5) + V##5; V##1 += (MSG##4 ^ BLAKE_CSTF) + V##6; V##2 += (MSG##6 ^ BLAKE_CST8) + V##7; V##3 += (MSG##A ^ BLAKE_CST2) + V##4;
#define blake512_mut11_8(V, MSG) V##0 += (MSG##2 ^ BLAKE_CSTC) + V##5; V##1 += (MSG##7 ^ BLAKE_CSTD) + V##6; V##2 += (MSG##4 ^ BLAKE_CST1) + V##7; V##3 += (MSG##5 ^ BLAKE_CSTA) + V##4;
#define blake512_mut11_9(V, MSG) V##0 += (MSG##B ^ BLAKE_CSTF) + V##5; V##1 += (MSG##E ^ BLAKE_CST9) + V##6; V##2 += (MSG##C ^ BLAKE_CST3) + V##7; V##3 += (MSG##0 ^ BLAKE_CSTD) + V##4;

#define blake512GV(i, V, MSG)                    \
    blake512_mut00_##i(V, MSG) \
    V##C = rol64_32(V##C ^ V##0);              \
    V##D = rol64_32(V##D ^ V##1);              \
    V##E = rol64_32(V##E ^ V##2);              \
    V##F = rol64_32(V##F ^ V##3);              \
    V##8 += V##C; V##9 += V##D; V##A += V##E; V##B += V##F;                     \
    V##4 ^= V##8; V##5 ^= V##9; V##6 ^= V##A; V##7 ^= V##B;                     \
    V##4 = rol64_39(V##4);              \
    V##5 = rol64_39(V##5);              \
    V##6 = rol64_39(V##6);              \
    V##7 = rol64_39(V##7);              \
    blake512_mut01_##i(V, MSG)   \
    V##C ^= V##0; V##D ^= V##1; V##E ^= V##2; V##F ^= V##3; \
    V##C = rol64_48(V##C);              \
    V##D = rol64_48(V##D);              \
    V##E = rol64_48(V##E);              \
    V##F = rol64_48(V##F);              \
    V##8 += V##C; V##9 += V##D; V##A += V##E; V##B += V##F;                     \
    V##4 ^= V##8; V##5 ^= V##9; V##6 ^= V##A; V##7 ^= V##B; \
    V##4 = rol64_53(V##4); \
    V##5 = rol64_53(V##5); \
    V##6 = rol64_53(V##6); \
    V##7 = rol64_53(V##7); \
    blake512_mut10_##i(V, MSG) \
    V##C = rol64_32(V##C ^ V##1);              \
    V##D = rol64_32(V##D ^ V##2);              \
    V##E = rol64_32(V##E ^ V##3);              \
    V##F = rol64_32(V##F ^ V##0);              \
    V##8 += V##D; V##9 += V##E; V##A += V##F; V##B += V##C;                     \
    V##4 ^= V##9; V##5 ^= V##A; V##6 ^= V##B; V##7 ^= V##8; \
    V##4 = rol64_39(V##4);              \
    V##5 = rol64_39(V##5);              \
    V##6 = rol64_39(V##6);              \
    V##7 = rol64_39(V##7);              \
    blake512_mut11_##i(V, MSG)  \
    V##C ^= V##1; V##D ^= V##2; V##E ^= V##3; V##F ^= V##0; \
    V##C = rol64_48(V##C);              \
    V##D = rol64_48(V##D);              \
    V##E = rol64_48(V##E);              \
    V##F = rol64_48(V##F);              \
    V##8 += V##D; V##9 += V##E; V##A += V##F; V##B += V##C;                     \
    V##5 ^= V##A; V##6 ^= V##B; V##7 ^= V##8; V##4 ^= V##9; \
    V##4 = rol64_53(V##4); \
    V##5 = rol64_53(V##5); \
    V##6 = rol64_53(V##6); \
    V##7 = rol64_53(V##7);

inline uint blake512_116_last(const uint *msg)
{
    ulong MSG0, MSG1, MSG2, MSG3, MSG4, MSG5, MSG6, MSG7, MSG8, MSG9, MSGA, MSGB, MSGC, MSGD, MSGE, MSGF;
    ulong V0, V1, V2, V3, V4, V5, V6, V7, V8, V9, VA, VB, VC, VD, VE, VF;
    ulong H3;

    MSG0 = as_ulong((uint2)(msg[1], msg[0]));
    MSG1 = as_ulong((uint2)(msg[3], msg[2]));
    MSG2 = as_ulong((uint2)(msg[5], msg[4]));
    MSG3 = as_ulong((uint2)(msg[7], msg[6]));
    MSG4 = as_ulong((uint2)(msg[9], msg[8]));
    MSG5 = as_ulong((uint2)(msg[11], msg[10]));
    MSG6 = as_ulong((uint2)(msg[13], msg[12]));
    MSG7 = as_ulong((uint2)(msg[15], msg[14]));
    MSG8 = as_ulong((uint2)(msg[17], msg[16]));
    MSG9 = as_ulong((uint2)(msg[19], msg[18]));
    MSGA = as_ulong((uint2)(msg[21], msg[20]));
    MSGB = as_ulong((uint2)(msg[23], msg[22]));
    MSGC = as_ulong((uint2)(msg[25], msg[24]));
    MSGD = as_ulong((uint2)(msg[27], msg[26]));
    MSGE = as_ulong((uint2)(0x80000000, msg[28]));

    MSGF = 0;

    V0 = 0x6A09E667F3BCC908UL;
    V1 = 0xBB67AE8584CAA73BUL;
    V2 = 0x3C6EF372FE94F82BUL;
    V3 = 0xA54FF53A5F1D36F1UL;
    V4 = 0x510E527FADE682D1UL;
    V5 = 0x9B05688C2B3E6C1FUL;
    V6 = 0x1F83D9ABFB41BD6BUL;
    V7 = 0x5BE0CD19137E2179UL;
    V8 = 0x243F6A8885A308D3UL;
    V9 = 0x13198A2E03707344UL;
    VA = 0xA4093822299F31D0UL;
    VB = 0x082EFA98EC4E6C89UL;
    VC = 0x452821E638D01377UL ^ 0x3A0UL;
    VD = 0xBE5466CF34E90C6CUL ^ 0x3A0UL;
    VE = 0xC0AC29B7C97C50DDUL;
    VF = 0x3F84D5B5B5470917UL;

    blake512GV(0, V, MSG);
    blake512GV(1, V, MSG);
    blake512GV(2, V, MSG);
    blake512GV(3, V, MSG);
    blake512GV(4, V, MSG);
    blake512GV(5, V, MSG);
    blake512GV(6, V, MSG);
    blake512GV(7, V, MSG);
    blake512GV(8, V, MSG);
    blake512GV(9, V, MSG);

    blake512GV(0, V, MSG);
    blake512GV(1, V, MSG);
    blake512GV(2, V, MSG);
    blake512GV(3, V, MSG);
    blake512GV(4, V, MSG);
    blake512GV(5, V, MSG);

    V0 ^= V8 ^ 0x6A09E667F3BCC908UL;
    V1 ^= V9 ^ 0xBB67AE8584CAA73BUL;
    V2 ^= VA ^ 0x3C6EF372FE94F82BUL;
    H3 = V3 ^= VB ^ 0xA54FF53A5F1D36F1UL;
    V4 ^= VC ^ 0x510E527FADE682D1UL;
    V5 ^= VD ^ 0x9B05688C2B3E6C1FUL;
    V6 ^= VE ^ 0x1F83D9ABFB41BD6BUL;
    V7 ^= VF ^ 0x5BE0CD19137E2179UL;

    MSG0 = MSG1 = MSG2 = MSG3 = MSG4 = MSG5 = MSG6 = MSG7 = MSG8 = MSG9 = MSGA = MSGB = MSGC = 0;
    MSGD = 1UL;
    MSGE = 0;
    MSGF = 0x3A0;

    V8 = 0x243F6A8885A308D3UL;
    V9 = 0x13198A2E03707344UL;
    VA = 0xA4093822299F31D0UL;
    VB = 0x082EFA98EC4E6C89UL;
    VC = 0x452821E638D01377UL;
    VD = 0xBE5466CF34E90C6CUL;
    VE = 0xC0AC29B7C97C50DDUL;
    VF = 0x3F84D5B5B5470917UL;

    blake512GV(0, V, MSG);
    blake512GV(1, V, MSG);
    blake512GV(2, V, MSG);
    blake512GV(3, V, MSG);
    blake512GV(4, V, MSG);
    blake512GV(5, V, MSG);
    blake512GV(6, V, MSG);
    blake512GV(7, V, MSG);
    blake512GV(8, V, MSG);
    blake512GV(9, V, MSG);

    blake512GV(0, V, MSG);
    blake512GV(1, V, MSG);
    blake512GV(2, V, MSG);
    blake512GV(3, V, MSG);
    blake512GV(4, V, MSG);
    blake512GV(5, V, MSG);

    H3 ^= V3 ^ VB;
    return as_uint2(SWAP64(H3)).y;
}

__constant ulong GROESTL_T0[256] = {
    0xC6A597F4A5F432C6UL,0xF884EB9784976FF8UL,0xEE99C7B099B05EEEUL,0xF68DF78C8D8C7AF6UL,
    0xFF0DE5170D17E8FFUL,0xD6BDB7DCBDDC0AD6UL,0xDEB1A7C8B1C816DEUL,0x915439FC54FC6D91UL,
    0x6050C0F050F09060UL,0x0203040503050702UL,0xCEA987E0A9E02ECEUL,0x567DAC877D87D156UL,
    0xE719D52B192BCCE7UL,0xB56271A662A613B5UL,0x4DE69A31E6317C4DUL,0xEC9AC3B59AB559ECUL,
    0x8F4505CF45CF408FUL,0x1F9D3EBC9DBCA31FUL,0x894009C040C04989UL,0xFA87EF92879268FAUL,
    0xEF15C53F153FD0EFUL,0xB2EB7F26EB2694B2UL,0x8EC90740C940CE8EUL,0xFB0BED1D0B1DE6FBUL,
    0x41EC822FEC2F6E41UL,0xB3677DA967A91AB3UL,0x5FFDBE1CFD1C435FUL,0x45EA8A25EA256045UL,
    0x23BF46DABFDAF923UL,0x53F7A602F7025153UL,0xE496D3A196A145E4UL,0x9B5B2DED5BED769BUL,
    0x75C2EA5DC25D2875UL,0xE11CD9241C24C5E1UL,0x3DAE7AE9AEE9D43DUL,0x4C6A98BE6ABEF24CUL,
    0x6C5AD8EE5AEE826CUL,0x7E41FCC341C3BD7EUL,0xF502F1060206F3F5UL,0x834F1DD14FD15283UL,
    0x685CD0E45CE48C68UL,0x51F4A207F4075651UL,0xD134B95C345C8DD1UL,0xF908E9180818E1F9UL,
    0xE293DFAE93AE4CE2UL,0xAB734D9573953EABUL,0x6253C4F553F59762UL,0x2A3F54413F416B2AUL,
    0x080C10140C141C08UL,0x955231F652F66395UL,0x46658CAF65AFE946UL,0x9D5E21E25EE27F9DUL,
    0x3028607828784830UL,0x37A16EF8A1F8CF37UL,0x0A0F14110F111B0AUL,0x2FB55EC4B5C4EB2FUL,
    0x0E091C1B091B150EUL,0x2436485A365A7E24UL,0x1B9B36B69BB6AD1BUL,0xDF3DA5473D4798DFUL,
    0xCD26816A266AA7CDUL,0x4E699CBB69BBF54EUL,0x7FCDFE4CCD4C337FUL,0xEA9FCFBA9FBA50EAUL,
    0x121B242D1B2D3F12UL,0x1D9E3AB99EB9A41DUL,0x5874B09C749CC458UL,0x342E68722E724634UL,
    0x362D6C772D774136UL,0xDCB2A3CDB2CD11DCUL,0xB4EE7329EE299DB4UL,0x5BFBB616FB164D5BUL,
    0xA4F65301F601A5A4UL,0x764DECD74DD7A176UL,0xB76175A361A314B7UL,0x7DCEFA49CE49347DUL,
    0x527BA48D7B8DDF52UL,0xDD3EA1423E429FDDUL,0x5E71BC937193CD5EUL,0x139726A297A2B113UL,
    0xA6F55704F504A2A6UL,0xB96869B868B801B9UL,0x0000000000000000UL,0xC12C99742C74B5C1UL,
    0x406080A060A0E040UL,0xE31FDD211F21C2E3UL,0x79C8F243C8433A79UL,0xB6ED772CED2C9AB6UL,
    0xD4BEB3D9BED90DD4UL,0x8D4601CA46CA478DUL,0x67D9CE70D9701767UL,0x724BE4DD4BDDAF72UL,
    0x94DE3379DE79ED94UL,0x98D42B67D467FF98UL,0xB0E87B23E82393B0UL,0x854A11DE4ADE5B85UL,
    0xBB6B6DBD6BBD06BBUL,0xC52A917E2A7EBBC5UL,0x4FE59E34E5347B4FUL,0xED16C13A163AD7EDUL,
    0x86C51754C554D286UL,0x9AD72F62D762F89AUL,0x6655CCFF55FF9966UL,0x119422A794A7B611UL,
    0x8ACF0F4ACF4AC08AUL,0xE910C9301030D9E9UL,0x0406080A060A0E04UL,0xFE81E798819866FEUL,
    0xA0F05B0BF00BABA0UL,0x7844F0CC44CCB478UL,0x25BA4AD5BAD5F025UL,0x4BE3963EE33E754BUL,
    0xA2F35F0EF30EACA2UL,0x5DFEBA19FE19445DUL,0x80C01B5BC05BDB80UL,0x058A0A858A858005UL,
    0x3FAD7EECADECD33FUL,0x21BC42DFBCDFFE21UL,0x7048E0D848D8A870UL,0xF104F90C040CFDF1UL,
    0x63DFC67ADF7A1963UL,0x77C1EE58C1582F77UL,0xAF75459F759F30AFUL,0x426384A563A5E742UL,
    0x2030405030507020UL,0xE51AD12E1A2ECBE5UL,0xFD0EE1120E12EFFDUL,0xBF6D65B76DB708BFUL,
    0x814C19D44CD45581UL,0x1814303C143C2418UL,0x26354C5F355F7926UL,0xC32F9D712F71B2C3UL,
    0xBEE16738E13886BEUL,0x35A26AFDA2FDC835UL,0x88CC0B4FCC4FC788UL,0x2E395C4B394B652EUL,
    0x93573DF957F96A93UL,0x55F2AA0DF20D5855UL,0xFC82E39D829D61FCUL,0x7A47F4C947C9B37AUL,
    0xC8AC8BEFACEF27C8UL,0xBAE76F32E73288BAUL,0x322B647D2B7D4F32UL,0xE695D7A495A442E6UL,
    0xC0A09BFBA0FB3BC0UL,0x199832B398B3AA19UL,0x9ED12768D168F69EUL,0xA37F5D817F8122A3UL,
    0x446688AA66AAEE44UL,0x547EA8827E82D654UL,0x3BAB76E6ABE6DD3BUL,0x0B83169E839E950BUL,
    0x8CCA0345CA45C98CUL,0xC729957B297BBCC7UL,0x6BD3D66ED36E056BUL,0x283C50443C446C28UL,
    0xA779558B798B2CA7UL,0xBCE2633DE23D81BCUL,0x161D2C271D273116UL,0xAD76419A769A37ADUL,
    0xDB3BAD4D3B4D96DBUL,0x6456C8FA56FA9E64UL,0x744EE8D24ED2A674UL,0x141E28221E223614UL,
    0x92DB3F76DB76E492UL,0x0C0A181E0A1E120CUL,0x486C90B46CB4FC48UL,0xB8E46B37E4378FB8UL,
    0x9F5D25E75DE7789FUL,0xBD6E61B26EB20FBDUL,0x43EF862AEF2A6943UL,0xC4A693F1A6F135C4UL,
    0x39A872E3A8E3DA39UL,0x31A462F7A4F7C631UL,0xD337BD5937598AD3UL,0xF28BFF868B8674F2UL,
    0xD532B156325683D5UL,0x8B430DC543C54E8BUL,0x6E59DCEB59EB856EUL,0xDAB7AFC2B7C218DAUL,
    0x018C028F8C8F8E01UL,0xB16479AC64AC1DB1UL,0x9CD2236DD26DF19CUL,0x49E0923BE03B7249UL,
    0xD8B4ABC7B4C71FD8UL,0xACFA4315FA15B9ACUL,0xF307FD090709FAF3UL,0xCF25856F256FA0CFUL,
    0xCAAF8FEAAFEA20CAUL,0xF48EF3898E897DF4UL,0x47E98E20E9206747UL,0x1018202818283810UL,
    0x6FD5DE64D5640B6FUL,0xF088FB83888373F0UL,0x4A6F94B16FB1FB4AUL,0x5C72B8967296CA5CUL,
    0x3824706C246C5438UL,0x57F1AE08F1085F57UL,0x73C7E652C7522173UL,0x975135F351F36497UL,
    0xCB238D652365AECBUL,0xA17C59847C8425A1UL,0xE89CCBBF9CBF57E8UL,0x3E217C6321635D3EUL,
    0x96DD377CDD7CEA96UL,0x61DCC27FDC7F1E61UL,0x0D861A9186919C0DUL,0x0F851E9485949B0FUL,
    0xE090DBAB90AB4BE0UL,0x7C42F8C642C6BA7CUL,0x71C4E257C4572671UL,0xCCAA83E5AAE529CCUL,
    0x90D83B73D873E390UL,0x06050C0F050F0906UL,0xF701F5030103F4F7UL,0x1C12383612362A1CUL,
    0xC2A39FFEA3FE3CC2UL,0x6A5FD4E15FE18B6AUL,0xAEF94710F910BEAEUL,0x69D0D26BD06B0269UL,
    0x17912EA891A8BF17UL,0x995829E858E87199UL,0x3A2774692769533AUL,0x27B94ED0B9D0F727UL,
    0xD938A948384891D9UL,0xEB13CD351335DEEBUL,0x2BB356CEB3CEE52BUL,0x2233445533557722UL,
    0xD2BBBFD6BBD604D2UL,0xA9704990709039A9UL,0x07890E8089808707UL,0x33A766F2A7F2C133UL,
    0x2DB65AC1B6C1EC2DUL,0x3C22786622665A3CUL,0x15922AAD92ADB815UL,0xC92089602060A9C9UL,
    0x874915DB49DB5C87UL,0xAAFF4F1AFF1AB0AAUL,0x5078A0887888D850UL,0xA57A518E7A8E2BA5UL,
    0x038F068A8F8A8903UL,0x59F8B213F8134A59UL,0x0980129B809B9209UL,0x1A1734391739231AUL,
    0x65DACA75DA751065UL,0xD731B553315384D7UL,0x84C61351C651D584UL,0xD0B8BBD3B8D303D0UL,
    0x82C31F5EC35EDC82UL,0x29B052CBB0CBE229UL,0x5A77B4997799C35AUL,0x1E113C3311332D1EUL,
    0x7BCBF646CB463D7BUL,0xA8FC4B1FFC1FB7A8UL,0x6DD6DA61D6610C6DUL,0x2C3A584E3A4E622CUL,
};

#define GROESTL_EXT_BYTE(var,n) as_uchar8(var).s##n

#define GROESTL_COLUMN(gx, gy, gi, c0, c1, c2, c3, c4, c5, c6, c7)           \
  gy##gi = groestl_lt0[GROESTL_EXT_BYTE(gx##c0,0)]             \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c1,1)]).s70123456) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c2,2)]).s67012345) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c3,3)]).s56701234) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c4,4)]).s45670123) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c5,5)]).s34567012) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c6,6)]).s23456701) \
    ^ as_ulong(as_uchar8(groestl_lt0[GROESTL_EXT_BYTE(gx##c7,7)]).s12345670)

#define GROESTL_RND1024Q(X, Y, R)                     \
    X##0 ^= 0xFFFFFFFFFFFFFFFFUL ^ R; \
    X##1 ^= 0xEFFFFFFFFFFFFFFFUL ^ R; \
    X##2 ^= 0xDFFFFFFFFFFFFFFFUL ^ R; \
    X##3 ^= 0xCFFFFFFFFFFFFFFFUL ^ R; \
    X##4 ^= 0xBFFFFFFFFFFFFFFFUL ^ R; \
    X##5 ^= 0xAFFFFFFFFFFFFFFFUL ^ R; \
    X##6 ^= 0x9FFFFFFFFFFFFFFFUL ^ R; \
    X##7 ^= 0x8FFFFFFFFFFFFFFFUL ^ R; \
    X##8 ^= 0x7FFFFFFFFFFFFFFFUL ^ R; \
    X##9 ^= 0x6FFFFFFFFFFFFFFFUL ^ R; \
    X##A ^= 0x5FFFFFFFFFFFFFFFUL ^ R; \
    X##B ^= 0x4FFFFFFFFFFFFFFFUL ^ R; \
    X##C ^= 0x3FFFFFFFFFFFFFFFUL ^ R; \
    X##D ^= 0x2FFFFFFFFFFFFFFFUL ^ R; \
    X##E ^= 0x1FFFFFFFFFFFFFFFUL ^ R; \
    X##F ^= 0x0FFFFFFFFFFFFFFFUL ^ R; \
    GROESTL_COLUMN(X, Y, F, 0, 2, 4, A, F, 1, 3, 5);         \
    GROESTL_COLUMN(X, Y, E, F, 1, 3, 9, E, 0, 2, 4);         \
    GROESTL_COLUMN(X, Y, D, E, 0, 2, 8, D, F, 1, 3);         \
    GROESTL_COLUMN(X, Y, C, D, F, 1, 7, C, E, 0, 2);         \
    GROESTL_COLUMN(X, Y, B, C, E, 0, 6, B, D, F, 1);         \
    GROESTL_COLUMN(X, Y, A, B, D, F, 5, A, C, E, 0);         \
    GROESTL_COLUMN(X, Y, 9, A, C, E, 4, 9, B, D, F);         \
    GROESTL_COLUMN(X, Y, 8, 9, B, D, 3, 8, A, C, E);         \
    GROESTL_COLUMN(X, Y, 7, 8, A, C, 2, 7, 9, B, D);         \
    GROESTL_COLUMN(X, Y, 6, 7, 9, B, 1, 6, 8, A, C);         \
    GROESTL_COLUMN(X, Y, 5, 6, 8, A, 0, 5, 7, 9, B);         \
    GROESTL_COLUMN(X, Y, 4, 5, 7, 9, F, 4, 6, 8, A);         \
    GROESTL_COLUMN(X, Y, 3, 4, 6, 8, E, 3, 5, 7, 9);         \
    GROESTL_COLUMN(X, Y, 2, 3, 5, 7, D, 2, 4, 6, 8);         \
    GROESTL_COLUMN(X, Y, 1, 2, 4, 6, C, 1, 3, 5, 7);         \
    GROESTL_COLUMN(X, Y, 0, 1, 3, 5, B, 0, 2, 4, 6);

#define GROESTL_RND1024P(X, Y, R)             \
    X##0 ^= R; \
    X##1 ^= 0x10UL ^ R; \
    X##2 ^= 0x20UL ^ R; \
    X##3 ^= 0x30UL ^ R; \
    X##4 ^= 0x40UL ^ R; \
    X##5 ^= 0x50UL ^ R; \
    X##6 ^= 0x60UL ^ R; \
    X##7 ^= 0x70UL ^ R; \
    X##8 ^= 0x80UL ^ R; \
    X##9 ^= 0x90UL ^ R; \
    X##A ^= 0xA0UL ^ R; \
    X##B ^= 0xB0UL ^ R; \
    X##C ^= 0xC0UL ^ R; \
    X##D ^= 0xD0UL ^ R; \
    X##E ^= 0xE0UL ^ R; \
    X##F ^= 0xF0UL ^ R; \
    GROESTL_COLUMN(X, Y, F, F, 0, 1, 2, 3, 4, 5, A); \
    GROESTL_COLUMN(X, Y, E, E, F, 0, 1, 2, 3, 4, 9); \
    GROESTL_COLUMN(X, Y, D, D, E, F, 0, 1, 2, 3, 8); \
    GROESTL_COLUMN(X, Y, C, C, D, E, F, 0, 1, 2, 7); \
    GROESTL_COLUMN(X, Y, B, B, C, D, E, F, 0, 1, 6); \
    GROESTL_COLUMN(X, Y, A, A, B, C, D, E, F, 0, 5); \
    GROESTL_COLUMN(X, Y, 9, 9, A, B, C, D, E, F, 4); \
    GROESTL_COLUMN(X, Y, 8, 8, 9, A, B, C, D, E, 3); \
    GROESTL_COLUMN(X, Y, 7, 7, 8, 9, A, B, C, D, 2); \
    GROESTL_COLUMN(X, Y, 6, 6, 7, 8, 9, A, B, C, 1); \
    GROESTL_COLUMN(X, Y, 5, 5, 6, 7, 8, 9, A, B, 0); \
    GROESTL_COLUMN(X, Y, 4, 4, 5, 6, 7, 8, 9, A, F); \
    GROESTL_COLUMN(X, Y, 3, 3, 4, 5, 6, 7, 8, 9, E); \
    GROESTL_COLUMN(X, Y, 2, 2, 3, 4, 5, 6, 7, 8, D); \
    GROESTL_COLUMN(X, Y, 1, 1, 2, 3, 4, 5, 6, 7, C); \
    GROESTL_COLUMN(X, Y, 0, 0, 1, 2, 3, 4, 5, 6, B);

#define GROESTL_RND1024PSHORT(X, Y, R)             \
    X##0 ^= R; \
    X##1 ^= 0x10UL ^ R; \
    X##6 ^= 0x60UL ^ R; \
    X##B ^= 0xB0UL ^ R; \
    X##C ^= 0xC0UL ^ R; \
    X##D ^= 0xD0UL ^ R; \
    X##E ^= 0xE0UL ^ R; \
    X##F ^= 0xF0UL ^ R; \
    GROESTL_COLUMN(X, Y, B, B, C, D, E, F, 0, 1, 6);

inline void groestl_load_tables(__local ulong* tables)
{
    for (int i = 0; i < 16; i++)
        vstore16(vload16(i, GROESTL_T0), i, tables);
    barrier(CLK_LOCAL_MEM_FENCE);
}

inline uint groestl512_116_last(uint * restrict msg, __local ulong *tables)
{
#if 0
    __constant ulong* groestl_lt0 = GROESTL_T0;
#else
    groestl_load_tables(tables);
    __local ulong* groestl_lt0 = tables;
#endif

    ulong Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, ZA, ZB, ZC, ZD, ZE, ZF;
    ulong H0, H1, H2, H3, H4, H5, H6, H7, H8, H9, HA, HB, HC, HD, HE, HF;
    ulong Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7, Y8, Y9, YA, YB, YC, YD, YE, YF;
    uint TB;

    Z0 = as_ulong((uint2)(SWAP32(msg[0]), SWAP32(msg[1])));
    Z1 = as_ulong((uint2)(SWAP32(msg[2]), SWAP32(msg[3])));
    Z2 = as_ulong((uint2)(SWAP32(msg[4]), SWAP32(msg[5])));
    Z3 = as_ulong((uint2)(SWAP32(msg[6]), SWAP32(msg[7])));
    Z4 = as_ulong((uint2)(SWAP32(msg[8]), SWAP32(msg[9])));
    Z5 = as_ulong((uint2)(SWAP32(msg[10]), SWAP32(msg[11])));
    Z6 = as_ulong((uint2)(SWAP32(msg[12]), SWAP32(msg[13])));
    Z7 = as_ulong((uint2)(SWAP32(msg[14]), SWAP32(msg[15])));
    Z8 = as_ulong((uint2)(SWAP32(msg[16]), SWAP32(msg[17])));
    Z9 = as_ulong((uint2)(SWAP32(msg[18]), SWAP32(msg[19])));
    ZA = as_ulong((uint2)(SWAP32(msg[20]), SWAP32(msg[21])));
    ZB = as_ulong((uint2)(SWAP32(msg[22]), SWAP32(msg[23])));
    ZC = as_ulong((uint2)(SWAP32(msg[24]), SWAP32(msg[25])));
    ZD = as_ulong((uint2)(SWAP32(msg[26]), SWAP32(msg[27])));
    ZE = as_ulong((uint2)(SWAP32(msg[28]), 0x80));

    ZF = 0x0100000000000000UL;

    GROESTL_RND1024Q(Z, Y, 0);
    GROESTL_RND1024Q(Y, Z, 0x0100000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0200000000000000UL);
    GROESTL_RND1024Q(Y, Z, 0x0300000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0400000000000000UL);
    GROESTL_RND1024Q(Y, Z, 0x0500000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0600000000000000UL);
    GROESTL_RND1024Q(Y, Z, 0x0700000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0800000000000000UL);
    GROESTL_RND1024Q(Y, Z, 0x0900000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0a00000000000000UL);
    GROESTL_RND1024Q(Y, Z, 0x0b00000000000000UL);
    GROESTL_RND1024Q(Z, Y, 0x0c00000000000000UL);

    GROESTL_RND1024Q(Y, H, 0x0d00000000000000UL);

    Y0 = as_ulong((uint2)(SWAP32(msg[0]), SWAP32(msg[1])));
    Y1 = as_ulong((uint2)(SWAP32(msg[2]), SWAP32(msg[3])));
    Y2 = as_ulong((uint2)(SWAP32(msg[4]), SWAP32(msg[5])));
    Y3 = as_ulong((uint2)(SWAP32(msg[6]), SWAP32(msg[7])));
    Y4 = as_ulong((uint2)(SWAP32(msg[8]), SWAP32(msg[9])));
    Y5 = as_ulong((uint2)(SWAP32(msg[10]), SWAP32(msg[11])));
    Y6 = as_ulong((uint2)(SWAP32(msg[12]), SWAP32(msg[13])));
    Y7 = as_ulong((uint2)(SWAP32(msg[14]), SWAP32(msg[15])));
    Y8 = as_ulong((uint2)(SWAP32(msg[16]), SWAP32(msg[17])));
    Y9 = as_ulong((uint2)(SWAP32(msg[18]), SWAP32(msg[19])));
    YA = as_ulong((uint2)(SWAP32(msg[20]), SWAP32(msg[21])));
    YB = as_ulong((uint2)(SWAP32(msg[22]), SWAP32(msg[23])));
    YC = as_ulong((uint2)(SWAP32(msg[24]), SWAP32(msg[25])));
    YD = as_ulong((uint2)(SWAP32(msg[26]), SWAP32(msg[27])));
    YE = as_ulong((uint2)(SWAP32(msg[28]), 0x80));

    YF = 0x0100000000000000UL ^ 0x0002000000000000UL;

    GROESTL_RND1024P(Y, Z, 0);
    GROESTL_RND1024P(Z, Y, 1UL);
    GROESTL_RND1024P(Y, Z, 2UL);
    GROESTL_RND1024P(Z, Y, 3UL);
    GROESTL_RND1024P(Y, Z, 4UL);
    GROESTL_RND1024P(Z, Y, 5UL);
    GROESTL_RND1024P(Y, Z, 6UL);
    GROESTL_RND1024P(Z, Y, 7UL);
    GROESTL_RND1024P(Y, Z, 8UL);
    GROESTL_RND1024P(Z, Y, 9UL);
    GROESTL_RND1024P(Y, Z, 10UL);
    GROESTL_RND1024P(Z, Y, 11UL);
    GROESTL_RND1024P(Y, Z, 12UL);
    GROESTL_RND1024P(Z, Y, 13UL);

    H0 ^= Y0; H1 ^= Y1; H2 ^= Y2; H3 ^= Y3;
    H4 ^= Y4; H5 ^= Y5; H6 ^= Y6; H7 ^= Y7;
    H8 ^= Y8; H9 ^= Y9; HA ^= YA; HB ^= YB;
    HC ^= YC; HD ^= YD; HE ^= YE; HF ^= YF ^ 0x0002000000000000UL;

    TB = as_uint2(HB).y;

    GROESTL_RND1024P(H, Y, 0);
    GROESTL_RND1024P(Y, Z, 1UL);
    GROESTL_RND1024P(Z, Y, 2UL);
    GROESTL_RND1024P(Y, Z, 3UL);
    GROESTL_RND1024P(Z, Y, 4UL);
    GROESTL_RND1024P(Y, Z, 5UL);
    GROESTL_RND1024P(Z, Y, 6UL);
    GROESTL_RND1024P(Y, Z, 7UL);
    GROESTL_RND1024P(Z, Y, 8UL);
    GROESTL_RND1024P(Y, Z, 9UL);
    GROESTL_RND1024P(Z, Y, 10UL);
    GROESTL_RND1024P(Y, Z, 11UL);
    GROESTL_RND1024P(Z, Y, 12UL);
    GROESTL_RND1024PSHORT(Y, H, 13UL);

    return as_uint2(HB).y ^ TB;
}

inline uint2 rolv2_1(const uint2 x, const uint y)
{
    return (uint2)((x.x << y) ^ (x.y >> (32 - y)), (x.y << y) ^ (x.x >> (32 - y)));
}
inline uint2 rolv2_2(const uint2 x, const uint y)
{
    return (uint2)((x.y << y) ^ (x.x >> (32 - y)), (x.x << y) ^ (x.y >> (32 - y)));
}

#define keccak_round(const0, const1) \
{ \
        BCa = Aba^Aga^Aka^Ama^Asa; BCe = Abe^Age^Ake^Ame^Ase; \
        BCi = Abi^Agi^Aki^Ami^Asi; BCo = Abo^Ago^Ako^Amo^Aso; BCu = Abu^Agu^Aku^Amu^Asu; \
        Da = BCu ^ rolv2_1(BCe, 1); De = BCa ^ rolv2_1(BCi, 1); \
        Di = BCe ^ rolv2_1(BCo, 1); Do = BCi ^ rolv2_1(BCu, 1); \
        Du = BCo ^ rolv2_1(BCa, 1); \
        Aba ^= Da; BCa = Aba; Age ^= De; BCe = rolv2_2(Age, 44); \
        Aki ^= Di; BCi = rolv2_2(Aki, 43); \
        Amo ^= Do; BCo = rolv2_1(Amo, 21); \
        Asu ^= Du; BCu = rolv2_1(Asu, 14); \
        Eba = bitselect(BCa ^ BCi, BCa, BCe) ^ const0; \
        Ebe = bitselect(BCe ^ BCo, BCe, BCi); \
        Ebi = bitselect(BCi ^ BCu, BCi, BCo); \
        Ebo = bitselect(BCo ^ BCa, BCo, BCu); \
        Ebu = bitselect(BCu ^ BCe, BCu, BCa); \
        Abo ^= Do; \
        BCa = rolv2_1(Abo, 28); \
        Agu ^= Du; \
        BCe = rolv2_1(Agu, 20); \
        Aka ^= Da; \
        BCi = rolv2_1(Aka, 3); \
        Ame ^= De; \
        BCo = rolv2_2(Ame, 45); \
        Asi ^= Di; \
        BCu = rolv2_2(Asi, 61); \
        Ega = bitselect(BCa ^ BCi, BCa, BCe); \
        Ege = bitselect(BCe ^ BCo, BCe, BCi); \
        Egi = bitselect(BCi ^ BCu, BCi, BCo); \
        Ego = bitselect(BCo ^ BCa, BCo, BCu); \
        Egu = bitselect(BCu ^ BCe, BCu, BCa); \
        Abe ^= De; \
        BCa = rolv2_1(Abe, 1); \
        Agi ^= Di; \
        BCe = rolv2_1(Agi, 6); \
        Ako ^= Do; \
        BCi = rolv2_1(Ako, 25); \
        Amu ^= Du; \
        BCo = rolv2_1(Amu, 8); \
        Asa ^= Da; \
        BCu = rolv2_1(Asa, 18); \
        Eka = bitselect(BCa ^ BCi, BCa, BCe); \
        Eke = bitselect(BCe ^ BCo, BCe, BCi); \
        Eki = bitselect(BCi ^ BCu, BCi, BCo); \
        Eko = bitselect(BCo ^ BCa, BCo, BCu); \
        Eku = bitselect(BCu ^ BCe, BCu, BCa); \
        Abu ^= Du; BCa = rolv2_1(Abu, 27); \
        Aga ^= Da; BCe = rolv2_2(Aga, 36); \
        Ake ^= De; BCi = rolv2_1(Ake, 10); \
        Ami ^= Di; BCo = rolv2_1(Ami, 15); \
        Aso ^= Do; BCu = rolv2_2(Aso, 56); \
        Ema = bitselect(BCa ^ BCi, BCa, BCe); \
        Eme = bitselect(BCe ^ BCo, BCe, BCi); \
        Emi = bitselect(BCi ^ BCu, BCi, BCo); \
        Emo = bitselect(BCo ^ BCa, BCo, BCu); \
        Emu = bitselect(BCu ^ BCe, BCu, BCa); \
        Abi ^= Di; BCa = rolv2_2(Abi, 62); \
        Ago ^= Do; BCe = rolv2_2(Ago, 55); \
        Aku ^= Du; BCi = rolv2_2(Aku, 39); \
        Ama ^= Da; BCo = rolv2_2(Ama, 41); \
        Ase ^= De; BCu = rolv2_1(Ase, 2); \
        Esa = bitselect(BCa ^ BCi, BCa, BCe); \
        Ese = bitselect(BCe ^ BCo, BCe, BCi); \
        Esi = bitselect(BCi ^ BCu, BCi, BCo); \
        Eso = bitselect(BCo ^ BCa, BCo, BCu); \
        Esu = bitselect(BCu ^ BCe, BCu, BCa); \
        BCa = Eba^Ega^Eka^Ema^Esa; \
        BCe = Ebe^Ege^Eke^Eme^Ese; \
        BCi = Ebi^Egi^Eki^Emi^Esi; \
        BCo = Ebo^Ego^Eko^Emo^Eso; \
        BCu = Ebu^Egu^Eku^Emu^Esu; \
        Da = BCu ^ rolv2_1(BCe, 1); \
        De = BCa ^ rolv2_1(BCi, 1); \
        Di = BCe ^ rolv2_1(BCo, 1); \
        Do = BCi ^ rolv2_1(BCu, 1); \
        Du = BCo ^ rolv2_1(BCa, 1); \
        Eba ^= Da; BCa = Eba; \
        Ege ^= De; BCe = rolv2_2(Ege, 44); \
        Eki ^= Di; BCi = rolv2_2(Eki, 43); \
        Emo ^= Do; BCo = rolv2_1(Emo, 21); \
        Esu ^= Du; BCu = rolv2_1(Esu, 14); \
        Aba = bitselect(BCa ^ BCi, BCa, BCe) ^ const1; \
        Abe = bitselect(BCe ^ BCo, BCe, BCi); \
        Abi = bitselect(BCi ^ BCu, BCi, BCo); \
        Abo = bitselect(BCo ^ BCa, BCo, BCu); \
        Abu = bitselect(BCu ^ BCe, BCu, BCa); \
        Ebo ^= Do; BCa = rolv2_1(Ebo, 28); \
        Egu ^= Du; BCe = rolv2_1(Egu, 20); \
        Eka ^= Da; BCi = rolv2_1(Eka, 3); \
        Eme ^= De; BCo = rolv2_2(Eme, 45); \
        Esi ^= Di; BCu = rolv2_2(Esi, 61); \
        Aga = bitselect(BCa ^ BCi, BCa, BCe); \
        Age = bitselect(BCe ^ BCo, BCe, BCi); \
        Agi = bitselect(BCi ^ BCu, BCi, BCo); \
        Ago = bitselect(BCo ^ BCa, BCo, BCu); \
        Agu = bitselect(BCu ^ BCe, BCu, BCa); \
        Ebe ^= De; BCa = rolv2_1(Ebe, 1); \
        Egi ^= Di; BCe = rolv2_1(Egi, 6); \
        Eko ^= Do; BCi = rolv2_1(Eko, 25); \
        Emu ^= Du; BCo = rolv2_1(Emu, 8); \
        Esa ^= Da; BCu = rolv2_1(Esa, 18); \
        Aka = bitselect(BCa ^ BCi, BCa, BCe); \
        Ake = bitselect(BCe ^ BCo, BCe, BCi); \
        Aki = bitselect(BCi ^ BCu, BCi, BCo); \
        Ako = bitselect(BCo ^ BCa, BCo, BCu); \
        Aku = bitselect(BCu ^ BCe, BCu, BCa); \
        Ebu ^= Du; BCa = rolv2_1(Ebu, 27); \
        Ega ^= Da; BCe = rolv2_2(Ega, 36); \
        Eke ^= De; BCi = rolv2_1(Eke, 10); \
        Emi ^= Di; BCo = rolv2_1(Emi, 15); \
        Eso ^= Do; BCu = rolv2_2(Eso, 56); \
        Ama = bitselect(BCa ^ BCi, BCa, BCe); \
        Ame = bitselect(BCe ^ BCo, BCe, BCi); \
        Ami = bitselect(BCi ^ BCu, BCi, BCo); \
        Amo = bitselect(BCo ^ BCa, BCo, BCu); \
        Amu = bitselect(BCu ^ BCe, BCu, BCa); \
        Ebi ^= Di; BCa = rolv2_2(Ebi, 62); \
        Ego ^= Do; BCe = rolv2_2(Ego, 55); \
        Eku ^= Du; BCi = rolv2_2(Eku, 39); \
        Ema ^= Da; BCo = rolv2_2(Ema, 41); \
        Ese ^= De; BCu = rolv2_1(Ese, 2); \
        Asa = bitselect(BCa ^ BCi, BCa, BCe); \
        Ase = bitselect(BCe ^ BCo, BCe, BCi); \
        Asi = bitselect(BCi ^ BCu, BCi, BCo); \
        Aso = bitselect(BCo ^ BCa, BCo, BCu); \
        Asu = bitselect(BCu ^ BCe, BCu, BCa); \
}

inline uint keccak512_116_last(uint * restrict msg)
{
    uint2 Aba, Abe, Abi, Abo, Abu;
    uint2 Aga, Age, Agi, Ago, Agu;
    uint2 Aka, Ake, Aki, Ako, Aku;
    uint2 Ama, Ame, Ami, Amo, Amu;
    uint2 Asa, Ase, Asi, Aso, Asu;
    uint2 BCa, BCe, BCi, BCo, BCu;
    uint2 Da, De, Di, Do, Du;
    uint2 Eba, Ebe, Ebi, Ebo, Ebu;
    uint2 Ega, Ege, Egi, Ego, Egu;
    uint2 Eka, Eke, Eki, Eko, Eku;
    uint2 Ema, Eme, Emi, Emo, Emu;
    uint2 Esa, Ese, Esi, Eso, Esu;

    Aba = (uint2)(SWAP32(msg[0]), SWAP32(msg[1]));
    Abe = (uint2)(SWAP32(msg[2]), SWAP32(msg[3]));
    Abi = (uint2)(SWAP32(msg[4]), SWAP32(msg[5]));
    Abo = (uint2)(SWAP32(msg[6]), SWAP32(msg[7]));
    Abu = (uint2)(SWAP32(msg[8]), SWAP32(msg[9]));
    Aga = (uint2)(SWAP32(msg[10]), SWAP32(msg[11]));
    Age = (uint2)(SWAP32(msg[12]), SWAP32(msg[13]));
    Agi = (uint2)(SWAP32(msg[14]), SWAP32(msg[15]));
    Ago = (uint2)(SWAP32(msg[16]), SWAP32(msg[17]));
    Agu = 0; Aka = 0; Ake = 0; Aki = 0; Ako = 0; Aku = 0; Ama = 0; Ame = 0;
    Ami = 0; Amo = 0; Amu = 0; Asa = 0; Ase = 0; Asi = 0; Aso = 0; Asu = 0;

    keccak_round((uint2)(1, 0), (uint2)(0x00008082, 0))
    keccak_round((uint2)(0x0000808AU, 0x80000000U), (uint2)(0x80008000U, 0x80000000U))
    keccak_round((uint2)(0x0000808BU, 0), (uint2)(0x80000001U, 0))
    keccak_round((uint2)(0x80008081U, 0x80000000U), (uint2)(0x00008009U, 0x80000000U))
    keccak_round((uint2)(0x0000008AU, 0), (uint2)(0x00000088U, 0))
    keccak_round((uint2)(0x80008009U, 0), (uint2)(0x8000000AU, 0))
    keccak_round((uint2)(0x8000808BU, 0), (uint2)(0x0000008BU, 0x80000000U))
    keccak_round((uint2)(0x00008089U, 0x80000000U), (uint2)(0x00008003U, 0x80000000U))
    keccak_round((uint2)(0x00008002U, 0x80000000U), (uint2)(0x00000080U, 0x80000000U))
    keccak_round((uint2)(0x0000800AU, 0), (uint2)(0x8000000AU, 0x80000000U))
    keccak_round((uint2)(0x80008081U, 0x80000000U), (uint2)(0x00008080U, 0x80000000U))
    keccak_round((uint2)(0x80000001U, 0), (uint2)(0x80008008U, 0x80000000U))

    Aba ^= (uint2)(SWAP32(msg[18]), SWAP32(msg[19]));
    Abe ^= (uint2)(SWAP32(msg[20]), SWAP32(msg[21]));
    Abi ^= (uint2)(SWAP32(msg[22]), SWAP32(msg[23]));
    Abo ^= (uint2)(SWAP32(msg[24]), SWAP32(msg[25]));
    Abu ^= (uint2)(SWAP32(msg[26]), SWAP32(msg[27]));
    Aga ^= (uint2)(SWAP32(msg[28]), 1);

    Ago ^= (uint2)(0, 0x80000000U);

    keccak_round((uint2)(1, 0), (uint2)(0x00008082, 0))
    keccak_round((uint2)(0x0000808AU, 0x80000000U), (uint2)(0x80008000U, 0x80000000U))
    keccak_round((uint2)(0x0000808BU, 0), (uint2)(0x80000001U, 0))
    keccak_round((uint2)(0x80008081U, 0x80000000U), (uint2)(0x00008009U, 0x80000000U))
    keccak_round((uint2)(0x0000008AU, 0), (uint2)(0x00000088U, 0))
    keccak_round((uint2)(0x80008009U, 0), (uint2)(0x8000000AU, 0))
    keccak_round((uint2)(0x8000808BU, 0), (uint2)(0x0000008BU, 0x80000000U))
    keccak_round((uint2)(0x00008089U, 0x80000000U), (uint2)(0x00008003U, 0x80000000U))
    keccak_round((uint2)(0x00008002U, 0x80000000U), (uint2)(0x00000080U, 0x80000000U))
    keccak_round((uint2)(0x0000800AU, 0), (uint2)(0x8000000AU, 0x80000000U))
    keccak_round((uint2)(0x80008081U, 0x80000000U), (uint2)(0x00008080U, 0x80000000U))
    keccak_round((uint2)(0x80000001U, 0), (uint2)(0x80008008U, 0x80000000U))
    return Abo.y;
}

#define RoundFunc(sponge, th, W, K)           \
        brG = Br(sponge, th.s6);                                      \
        tmp1 = F1(th.s4, Br(sponge, th.s5), brG) + th.s7 + W + K;             \
        tmp2 = tmp1 + Sigma1(Br(sponge, th.s4));                      \
        brC = Br(sponge, th.s2);                                      \
        brB = Br(sponge, th.s1);                                      \
        tmp3 = Ma(Br(sponge, th.s0), brB, brC);                       \
        tmp4 = tmp3 + Sigma0(Br(sponge, th.s0));                      \
        th = shuffle(th, (uint8)(7, 0, 1, 2, 3, 4, 5, 6)); \
        th.s4 += Br(sponge, tmp2); \
        th.s0 = tmp2 + tmp4;

inline uint Ma(uint x, uint y, uint z) { return bitselect(x, y, z ^ x); }
inline uint Sigma1(uint E) { return S3(E); }
inline uint sigma1(uint X) { return rotate(X, 15U) ^ rotate(X, 13U) ^ (X >> 10); }
inline uint Sigma0(uint A) { return rotate(A, 30U) ^ rotate(A, 19U) ^ rotate(A, 10U); }
inline uint sigma0(uint X) { return rotate(X, 25U) ^ rotate(X, 14U) ^ (X >> 3); }

inline uint Smoosh2(uint X) {
    X ^= X >> 16;
    X ^= X >> 8;
    X ^= X >> 4;
    return (X ^ X >> 2) & 3;
}

inline void Mangle(uint4 *S)
{
    uchar4 vr = as_uchar4(((*S).x ^ ((*S).x >> 4)) & 0x0f0f0f0f);

    (*S).y ^= rotate((int)(*S).x, 32 - vr.w);
    uint tmp = (*S).y;
    uint sw = Smoosh2(tmp);

    (*S).z = select( select( select((*S).z ^ rotate((*S).x, (uint)(31 - vr.x)), (*S).z & rotate(~((*S).x), (uint)(31 - vr.y)), (uint)(sw == 2)),
                (*S).z + rotate(~((*S).x), (uint)(31 - vr.z)), sw == 1), (*S).z ^ rotate((*S).x, (uint)(31 - vr.w)), sw == 0);
    tmp ^= (*S).z;
    sw = Smoosh2(tmp);
    (*S).w = select( select( select((*S).w ^ rotate((*S).x, (uint)(30 - vr.x)), (*S).w & rotate(~((*S).x), (uint)(30 - vr.y)), (uint)(sw == 2)),
                (*S).w + rotate(~((*S).x), (uint)(30 - vr.z)), sw == 1), (*S).w ^ rotate((*S).x, (uint)(30 - vr.w)), sw == 0);

    (*S).x ^= (((*S).y ^ (*S).z) + (*S).w);
}

inline void Absorb(uint4 *S, uint X)
{
    (*S).x ^= X;
    Mangle(S);
}

inline uint Br(uint4 *sponge, uint X)
{
    uint R = (*sponge).x;
    Mangle(sponge);

    uint r0 = R >> 8;
    uint r1 = R & 3;

    uint Y = 1 << (r0 & 31);

    return select(X, select(select(X ^ Y, X | Y, r1 == 2), X & ~Y, r1 == 1), r1);
}

#define HR(i) (W[i % 16] = sigma1(W[(i + 14) % 16]) + W[(i + 9) % 16] + sigma0(W[(i + 1) % 16]) + W[i % 16])

#define HHALF1(i, k) Absorb(sponge, th.s3 ^ th.s7); RoundFunc(sponge, th, W[i], k);
#define HHALF2(i, w, k) Absorb(sponge, th.s3 + th.s7); RoundFunc(sponge, th, w, k);

inline uint8 HeftyBlock(uint W[16], uint4 *sponge, uint8 h)
{
    uint8 th = h;
    uint brG, tmp1, tmp2, brC, brB, tmp3, tmp4;

    for (int i = 0; i < 16; i++) {
        Absorb(sponge, W[i] ^ K[i]);
    }
    for (int i = 0; i < 16; i++) {
        HHALF1(i, K[i]);
    }
    for (int i = 16; i < 64; i++) {
        HHALF2(i, HR(i), K[i]);
    }
    return h + th;
}

inline uint8 hefty84(const uint* msg)
{
    uint4 sponge = 0;
    uint8 h = (uint8)(0x6a09e667U, 0xbb67ae85U, 0x3c6ef372U, 0xa54ff53aU, 0x510e527fU, 0x9b05688cU, 0x1f83d9abU, 0x5be0cd19U);
    uint W[16];
    for (int i = 0; i < 16; i++)
        W[i] = msg[i];
    h = HeftyBlock(W, &sponge, h);
    W[0] = msg[16];
    W[1] = msg[17];
    W[2] = msg[18];
    W[3] = msg[19];
    W[4] = msg[20];
    W[5] = 0x80000000U;
    W[6] = W[7] = W[8] = W[9] = W[10] = W[11] = W[12] = W[13] = W[14] = 0;
    W[15] = 0x2a0;
    return HeftyBlock(W, &sponge, h);
}

#define RESULT_MASK 0xFC000000U

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global const uint*restrict msg, __global uint*restrict output)
{
    __local ulong groestl_tables[256];
    uint nonce = get_global_id(0);
    uint hashx[21 + 8];
    for (int i = 0; i < 21; i++)
        hashx[i] = msg[i];
#ifndef NOLOCAL
    hashx[19] = SWAP32(nonce);
#endif

    vstore8(hefty84(hashx), 0, hashx + 21);

    if ((sha256_116_last(hashx) & RESULT_MASK) != 0)
        return;
    if ((blake512_116_last(hashx) & RESULT_MASK) != 0)
        return;
    if ((keccak512_116_last(hashx) & RESULT_MASK) != 0)
        return;
    if ((groestl512_116_last(hashx, groestl_tables) & RESULT_MASK) != 0)
        return;

#define FOUND (0x0F)
#define SETFOUND(Xnonce) output[output[FOUND]++] = Xnonce
    SETFOUND(nonce);
}
