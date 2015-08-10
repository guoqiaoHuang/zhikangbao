//
//  BaseHttpRequestResult.m
//  Legend
//
//  Created by fuhuiqiang on 15/3/16.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "BaseHttpRequestResult.h"

@implementation BaseHttpRequestResult

+ (NSInteger)requestResultInfoBack:(NSDictionary*)infoDic{
    
    if (infoDic == nil) {
        return 100000;
    }
    NSString *infoStr;
    NSInteger code;
    code= [[infoDic objectForKey:@"code"]integerValue];
    
    switch (code) {
        case 0:
            
            infoStr= @"成功";
            break;
            
        case 1:
            infoStr= @"系统异常";
            break;
            
        case 4012:
            infoStr= @"用户名不能为空";
            break;
            
        case 502:
            infoStr= @"不存在该会员信息";
            break;
            
        case 5002:
            infoStr= @"密码错误";
            break;
            
        default:
        {
            
        }
            break;
    }
    
    return code;
}

@end
