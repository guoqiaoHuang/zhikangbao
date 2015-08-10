//
//  UserInformation.m
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation
+ (UserInformation *)sharedUserManager
{
    //多线程并发
    static UserInformation *singleInstance = nil ;
    static dispatch_once_t pred ;
    
    dispatch_once(&pred, ^{
        
        singleInstance = [[UserInformation alloc] init];
    });
    
    return singleInstance;
    
}
//_api_key set method
-(void)setapi_key:(NSString *)userKey{
    _api_key=userKey;
    NSLog(@"api:%@",_api_key);
    [[NSUserDefaults standardUserDefaults] setObject:_api_key forKey:@"key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//status set method
-(void)setShopNmame:(NSString *)userStatus
{
    _status=userStatus;
    [[NSUserDefaults standardUserDefaults] setObject:_status forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setusername:(NSString *)username
{
    _username=username;
    [[NSUserDefaults standardUserDefaults] setObject:_username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setperson_ID:(NSString *)person_ID
{
    _person_ID=person_ID;
    [[NSUserDefaults standardUserDefaults] setObject:_person_ID forKey:@"person_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
