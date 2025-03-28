//
//  NSData+XTEA.h
//  JKSecondTool
//
//  Created by v_jinlilili on 28/03/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XTEA)

/**
 加密数据
 
 @param data 需要加密的数据 (8字节)
 @param keyData 加密的Key (16字节)
 @param rounds 循环次数
 @return 加密过的数据 (8字节)
 */
+ (NSData *)encryptData:(NSData *)data key:(NSData *)keyData rounds:(unsigned int)rounds;

/**
 解密数据
 
 @param data 需要解密的数据 (8字节)
 @param keyData 解密的key (16字节)
 @param rounds 循环次数
 @return 解密过的数据 (8字节)
 */
+ (NSData *)decryptData:(NSData *)data key:(NSData *)keyData rounds:(unsigned int)rounds;

@end

NS_ASSUME_NONNULL_END
