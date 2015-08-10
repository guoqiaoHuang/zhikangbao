//
//  BaseViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=YES;
        self.isCancel=NO;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mbHUD=[CustomMBProgressHUD sharedCustomHUD];
    if (self.isBack) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 35, 35);
        //当点击的时候显示为高亮
        button.showsTouchWhenHighlighted = NO;
        [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    if (self.isCancel) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
        //button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(0, 0, 35, 35);
        //当点击的时候显示为高亮
//        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
        
    }

}
/**
 *  网络请求成功后参数处理
 *
 *  @param responseObject 返回数据
 *  @param name           接口名
 */
- (void)handleRequestResult:(id)responseObject WithServiceName:(NSString *)name
{
    if (responseObject) {
        NSLog(@"responseObject:%@ %@",responseObject,[responseObject objectForKey:@"msg"]);
        int code = [[responseObject objectForKey:@"code"] intValue];
        switch (code) {
                //返回正常
            case 0:
            {
                //                 [[CustomMBProgressHUD sharedCustomHUD] dismissCustomHud];
                
                [self refreshViews:responseObject WithServiceName:name];
                
            }
                break;
                
            case 1:
            {
                //特殊情况，比如需要重新登录
            }
                break;
                //其他情况
            default:
            {
                //                [[CustomMBProgressHUD sharedCustomHUD] showAllTextDialogHud:self.view withTitle:[responseObject objectForKey:@"msg"]];
                
            }
                break;
        }
        
    }else{
        
        //        [[CustomMBProgressHUD sharedCustomHUD] showAllTextDialogHud:self.view withTitle:@"服务器异常"];
    }
    
}

//请求失败处理
- (void)handleFailed:(NSError *)error
{
    NSLog(@"error is %@",error);
    
    if (error.code == -1004) {
        
        //         [[CustomMBProgressHUD sharedCustomHUD] showAllTextDialogHud:self.view withTitle:@"无法连接服务器"];
        
    }else{
        
        //        [[CustomMBProgressHUD sharedCustomHUD]dismissCustomHud];
    }
    
}


/**
 *  网络请求成功后刷新界面
 *
 *  @param responseObject 返回数据
 *  @param name           接口名
 */
- (void)refreshViews:(id)responseObject WithServiceName:(NSString *)name
{
    //    网络请求成功后的操作，子类覆写改方法
}


- (NSString *)formatUrl:(NSString *)serverName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",nil,serverName];
    return urlString;
}
- (void)cancelButtonTapped:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
