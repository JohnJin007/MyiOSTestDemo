//
//  NSData+XTEA.m
//  JKSecondTool
//
//  Created by v_jinlilili on 28/03/2025.
//

#import "NSData+XTEA.h"
// 引入必要的头文件
#include <stdio.h>
#include <stdint.h>

// 声明常量
static NSInteger const kUint32DataCount = 2;
static NSInteger const kUint32KeyCount = 4;
static NSInteger const kSubdataLength = 4;

@implementation NSData (XTEA)

void encipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
    unsigned int i;
    uint32_t v0=v[0], v1=v[1], sum=0, delta=0x9E3779B9;
    for (i=0; i < num_rounds; i++) {
        v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
        sum += delta;
        v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum>>11) & 3]);
    }
    v[0]=v0; v[1]=v1;
}

void decipher(unsigned int num_rounds, uint32_t v[2], uint32_t const key[4]) {
    unsigned int i;
    
    uint32_t v0=v[0], v1=v[1], delta=0x9E3779B9, sum=delta*num_rounds;
    for (i=0; i < num_rounds; i++) {
        v1 -= (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum>>11) & 3]);
        sum -= delta;
        v0 -= (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
    }
    v[0] = v0; v[1] = v1;
}

/**
 加密数据
 
 @param data 需要加密的数据 (8字节)
 @param keyData 加密的Key (16字节)
 @param rounds 循环次数
 @return 加密过的数据 (8字节)
 */
+ (NSData *)encryptData:(NSData *)data key:(NSData *)keyData rounds:(unsigned int)rounds
{
    NSAssert(data.length == 8, @"encryptData: (data length != 8)");
    NSAssert(keyData.length == 16, @"encryptData: (keyData length != 16)");
    
    // 将数据拆分成2个uint32_t数组
    uint32_t encryptData[kUint32DataCount];
    for (int i = 0; i < kUint32DataCount; i++) {
        encryptData[i] = [NSData uint32FromData:[data subdataWithRange:NSMakeRange(i * kSubdataLength, kSubdataLength)]];
    }
    
    // 将Key拆成4个uint32_t数组
    uint32_t key[kUint32KeyCount];
    for (int i = 0; i < kUint32KeyCount; i++) {
        key[i] = [NSData uint32FromData:[keyData subdataWithRange:NSMakeRange(i * kSubdataLength, kSubdataLength)]];
    }
    
    // 加密
    encipher(rounds, encryptData, key);
    
    // 返回结果
    return [NSData dataFromUInt32Array:encryptData length:data.length];
}

/**
 解密数据
 
 @param data 需要解密的数据 (8字节)
 @param keyData 解密的key (16字节)
 @param rounds 循环次数
 @return 解密过的数据 (8字节)
 */
+ (NSData *)decryptData:(NSData *)data key:(NSData *)keyData rounds:(unsigned int)rounds
{
    NSAssert(data.length == 8, @"decryptData: (data length != 8)");
    NSAssert(keyData.length == 16, @"decryptData: (keyData length != 16)");
    
    // 将数据拆分成2个uint32_t数组
    uint32_t decryptData[kUint32DataCount];
    for (int i = 0; i < kUint32DataCount; i++) {
        decryptData[i] = [NSData uint32FromData:[data subdataWithRange:NSMakeRange(i * kSubdataLength, kSubdataLength)]];
    }

    // 将Key拆成4个uint32_t数组
    uint32_t key[kUint32KeyCount];
    for (int i = 0; i < kUint32KeyCount; i++) {
        key[i] = [NSData uint32FromData:[keyData subdataWithRange:NSMakeRange(i * kSubdataLength, kSubdataLength)]];
    }

    // 解密
    decipher(rounds, decryptData, key);

    // 返回结果
    return [NSData dataFromUInt32Array:decryptData length:data.length];
}

// NSData转uint32
+ (uint32_t)uint32FromData:(NSData *)hexData
{
    NSAssert(hexData.length == 4, @"uint32FromData: (data length != 4)");
    
    Byte dataBytes[4];
    [hexData getBytes:&dataBytes length:4];
    
    uint32_t resultValue = *(uint32_t *)dataBytes ;
    return resultValue;
}

// uint32转NSData
+ (NSData *)dataFromUInt32Array:(uint32_t *)value length:(NSInteger)length
{
    Byte *result = (Byte *)value;
    return [NSData dataWithBytes:result length:length];
}

@end
