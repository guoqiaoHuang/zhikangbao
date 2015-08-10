//
//  WarmingDetailViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/6/17.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface WarmingDetailViewController : BaseViewController
@property(nonatomic,retain)NSURL *urls;
@property (weak, nonatomic) IBOutlet UIWebView *detail;
@property(nonatomic,strong)UIActivityIndicatorView *loadIndicator;
@end
