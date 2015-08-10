//
//  DetailMessageViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/7/29.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "DetailMessageViewController.h"

@interface DetailMessageViewController ()

@end

@implementation DetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    // Do any additional setup after loading the view from its nib.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.urls];
    
    [self.myweb loadRequest:request];
    self.loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadIndicator.color = [UIColor blackColor];
    //设置背景透明
    self.loadIndicator.alpha = 1;
    
    //设置背景为圆角矩形
    self.loadIndicator.layer.cornerRadius = 6;
    self.loadIndicator.layer.masksToBounds = YES;
    
    //设置显示位置
    [self.loadIndicator setCenter:CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0)];//-64
    
    //    [self.view addSubview:self.loadIndicator];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.loadIndicator];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.loadIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadIndicator stopAnimating];
    
}
@end
