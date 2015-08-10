//
//  AddDeviceViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/5.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDeviceViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (retain, nonatomic)  UITableView *familyTable;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)checkAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *relationLab;

@end
