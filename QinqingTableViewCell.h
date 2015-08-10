//
//  QinqingTableViewCell.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QinqingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab0;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIButton *call;
- (IBAction)callac:(UIButton *)sender;

@end
