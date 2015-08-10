//
//  ConsumptionViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/20.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface ConsumptionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *consumptionTable;
@property (weak, nonatomic) IBOutlet UIWebView *consumption;
@property(nonatomic,retain)NSURL *urls;
@end
