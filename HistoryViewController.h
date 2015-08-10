//
//  HistoryViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "HistoryTableViewCell.h"
#import "DetailHistoryViewController.h"
@interface HistoryViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *right;
- (IBAction)rightAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *left;
- (IBAction)leftAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *view0;

@property (weak, nonatomic) IBOutlet UITableView *historyTable;
@end
