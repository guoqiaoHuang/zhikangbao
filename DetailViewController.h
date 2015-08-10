//
//  DetailViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/25.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "DetailRecordTableViewCell.h"
@interface DetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIButton *before;
- (IBAction)beforeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *after;
- (IBAction)afterAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (retain, nonatomic)  NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *label0;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *laber21;
@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end
