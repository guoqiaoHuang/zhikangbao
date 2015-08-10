//
//  LeftViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftTableViewCell.h"
#import "LoginViewController.h"
#import "GenerateViewController.h"
#import "MyDeviceViewController.h"
#import "MessageViewController.h"
@interface LeftViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property(assign)int message;
@end
