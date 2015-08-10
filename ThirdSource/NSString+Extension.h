//
//  NSString+Extension.h
//
//  Created by
//  Copyright (c)  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)md5:(NSString *)str;

- (NSString *)md5;

+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)generateUDID;
/**
 *  去除字符串左右两端空格
 *
 *  @param string 输入字符串
 *
 *  @return 返回字符串
 */
+ (NSString *)trimString:(NSString *)string;

//string to json
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

+ (NSString *)formatString:(NSString *)string;
@end
