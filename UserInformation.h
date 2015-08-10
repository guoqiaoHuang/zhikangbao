//
//  UserInformation.h
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject
+ (UserInformation *)sharedUserManager;
/*
 *
 "api_key" = 8bb921fb4623dbb73e1324200f5c28c688f05b07;接口访问api_key
 avatar = 0;头像地址
 email = "";
 id = 8;用户ID
 email = 18503039870;
 nickname = "";用户中文名称
 sex = 0;性别 1：男、0：女
 status = 1;用户状态，是否激活
 username = "";用户名
 */
@property(nonatomic,retain,setter=setapi_key:)NSString *api_key;
@property(nonatomic,retain)NSString *avatar;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *nickname;
@property(nonatomic,retain,setter=setShopNmame:)NSString *status;
@property(nonatomic,retain,setter=setusername:)NSString *username;
@property(nonatomic,retain)NSString *userid;
@property(nonatomic,assign)int sex;
@property(nonatomic,retain,setter=setperson_ID:)NSString *person_ID;
@end
