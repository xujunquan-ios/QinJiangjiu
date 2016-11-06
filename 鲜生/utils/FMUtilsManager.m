//
//  FMUtilsManager.m
//  FreshMan
//
//  Created by VictorXiong on 15/8/18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "FMUtilsManager.h"
#import <CommonCrypto/CommonDigest.h>
@implementation FMUtilsManager

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
@end
