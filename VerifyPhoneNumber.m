//
//  VerifyPhoneNumber.m
//  Legend
//
//  Created by frocky on 15/5/19.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "VerifyPhoneNumber.h"

@implementation VerifyPhoneNumber

//判断手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
#if 0
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
#endif
    
    NSString * PHS = @"1[3|4|5|7|8|9][0-9]{9}";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if ([regextestct evaluateWithObject:mobileNum] == YES) {
        
         return YES;
        
    }else{
        
        return NO;
    }
    
}

+ (BOOL)isMoneyNumber:(NSString *)moneyNum
{
#if 0
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d*\\.\\d*$|^0\\.\\d*[1-9]\\d*$|^[1-9]\\d*$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:moneyNum options:0 range:NSMakeRange(0, [moneyNum length])];
    if (result) {
        return YES;
    }else{
        return NO;
    }
#endif
   
    NSString * PHS = @"^[1-9]\\d*\\.\\d*$|^0\\.\\d*[1-9]\\d*$|^[1-9]\\d*$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if ([regextestct evaluateWithObject:moneyNum] == YES) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

+ (BOOL)isRegularLoginPassword:(NSString *)password
{
    NSString * PHS = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,28}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if ([regextestct evaluateWithObject:password] == YES) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}
@end
