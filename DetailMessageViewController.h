//
//  DetailMessageViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/7/29.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailMessageViewController : BaseViewController
@property(nonatomic,retain)NSURL *urls;
@property (weak, nonatomic) IBOutlet UIWebView *detail;
@property(nonatomic,strong)UIActivityIndicatorView *loadIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *myweb;
@end
