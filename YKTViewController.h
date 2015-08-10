//
//  YKTViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "YKTTableViewCell.h"
#import "ResourceTreeViewController.h"
@class CMSPInfo;
@interface YKTViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *YKTtable;
@property(nonatomic,retain)CMSPInfo *serverInfo;
@end
