//
//  BaseViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMBProgressHUD.h"
@interface BaseViewController : UIViewController
@property(nonatomic,assign)BOOL isBack;//控制器是否有返回按钮
@property(nonatomic,assign)BOOL isCancel;//控制器是否有取消按钮
@property(nonatomic,retain)CustomMBProgressHUD *mbHUD;

//网络请求返回
- (void)handleRequestResult:(id)responseObject WithServiceName:(NSString *)name;

- (void)handleFailed:(NSError *)error;

//子类重写
- (void)refreshViews:(id)responseObject WithServiceName:(NSString *)name;

- (NSString *)formatUrl:(NSString *)serverName;

@end
