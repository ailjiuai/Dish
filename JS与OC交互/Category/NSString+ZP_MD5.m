//
//  NSString+ZP_MD5.m
//  JS与OC交互
//
//  Created by iLogiEMAC on 15/12/16.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "NSString+ZP_MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (ZP_MD5)
- (NSString *)toMD5ForKey
{
    const char * md5Str = [self UTF8String];
    if (md5Str == NULL) {
        md5Str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5Str, (CC_LONG)strlen(md5Str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",r[0],r[1],r[2],r[3],r[4],r[5],r[6],r[7],r[8],r[9],r[10],r[11],r[12],r[13],r[14],r[15]];
}
@end
