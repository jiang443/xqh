//
//  OCUtils.h
//  Rent
//
//  Created by jiang on 19/4/8.
//  Copyright © 2019年 tmpName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@interface OCUtils : NSObject

/**
 *  获取Sha1字符串
 */
+ (NSString *) getSha1:(NSString *)str;

/**
 *  播放音频
 */
+ (void)playSoundEffect:(NSString *)name;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString *)filterEmoji:(NSString *)string ;

//计算NSData 的MD5值
+(NSString*)getMD5WithData:(NSData*)data;

//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;

//计算大文件的MD5值
+(NSString*)getFileMD5WithPath:(NSString*)path;



@end
