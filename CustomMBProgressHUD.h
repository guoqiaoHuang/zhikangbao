//
//  CustomMBProgressHUD.h
//  Legend
//
//  Created by frocky on 15/4/2.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <unistd.h>


@interface CustomMBProgressHUD : MBProgressHUD


+ (CustomMBProgressHUD *)sharedCustomHUD;

//显示只带活动指示器
- (void)showSimple:(UIView *)customView;

//显示带文字的提示框
- (void)showTitleHud:(UIView *)customView withTitle:(NSString *)title ;

//带圆形进度条
- (void)showProgressDialogHud:(UIView *)customView withTitle:(NSString *)title;

- (void)showProgressDialog2Hud:(UIView *)customView withTitle:(NSString *)title;

//1秒提示再消失

- (void)showCustomDialogHud:(UIView *)customView withTitle:(NSString *)title;
- (void)showAllTextDialogHud:(UIView *)customView withTitle:(NSString *)title;

//提示框消失
- (void)dismissCustomHud;

@end
