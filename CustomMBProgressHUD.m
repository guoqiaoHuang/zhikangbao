//
//  CustomMBProgressHUD.m
//  Legend
//
//  Created by frocky on 15/4/2.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "CustomMBProgressHUD.h"

@implementation CustomMBProgressHUD


+ (CustomMBProgressHUD *)sharedCustomHUD
{
    //多线程并发
    static CustomMBProgressHUD *singleInstance = nil ;
    static dispatch_once_t pred ;
    
    dispatch_once(&pred, ^{
        
        singleInstance = [[CustomMBProgressHUD alloc] init];
    });
    return singleInstance;
}


- (void)showSimple:(UIView *)customView{
    
    //初始化进度框，置于当前的View当中
    [customView addSubview:self];
    
    self.mode = MBProgressHUDModeIndeterminate;
    
    //如果设置此属性则当前的view置于后台
    self.dimBackground = NO;
    [self show:YES];
}

- (void)showTitleHud:(UIView *)customView withTitle:(NSString *)title {
    
    [customView addSubview:self];
    
    self.mode = MBProgressHUDModeIndeterminate;

    //如果设置此属性则当前的view置于后台
    self.dimBackground = NO;
    //设置对话框文字
    self.labelText = title;
    [self show:YES];
//    //显示对话框
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        //对话框显示时需要执行的操作
//        sleep(3);
//    } completionBlock:^{
//        //操作执行完后取消对话框
//        [HUD removeFromSuperview];
//         HUD = nil;
//    }];
}

- (void)showProgressDialogHud:(UIView *)customView withTitle:(NSString *)title {
    
    [customView addSubview:self];
    self.labelText = @"正在加载";
    
    //设置模式为进度框形的
    self.mode = MBProgressHUDModeDeterminate;
    
    [self showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            self.progress = progress;
            usleep(50000);
        }
    } completionBlock:^{
        [self removeFromSuperview];
    }];
}


- (void)showProgressDialog2Hud:(UIView *)customView withTitle:(NSString *)title {
    
    [customView addSubview:self];
    self.labelText = @"正在加载";
    self.mode = MBProgressHUDModeAnnularDeterminate;
    [self showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            self.progress = progress;
            usleep(50000);
        }
    } completionBlock:^{
        [self removeFromSuperview];
    }];
}


- (void)showCustomDialogHud:(UIView *)customView withTitle:(NSString *)title{
    
    [customView addSubview:self];
    self.labelText = title;
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    
    [self showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self removeFromSuperview];
        [self.customView removeFromSuperview];
        
    }];
    
}

- (void)showAllTextDialogHud:(UIView *)customView withTitle:(NSString *)title{
    
    [customView addSubview:self];
    self.labelText =title;
    self.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //    HUD.yOffset = 150.0f;
    //    HUD.xOffset = 100.0f;
    
    [self showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self removeFromSuperview];
        
    }];
}


- (void)dismissCustomHud{
    
    [self removeFromSuperview];
}



@end
