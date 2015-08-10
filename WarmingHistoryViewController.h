//
//  WarmingHistoryViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "WarmingHistoryTableViewCell.h"
#import "WarmingDetailViewController.h"
@interface WarmingHistoryViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@property(nonatomic,retain)UITableViewCell *tableCell;
@end
