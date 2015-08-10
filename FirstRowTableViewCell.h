//
//  FirstRowTableViewCell.h
//  AiKangBao
//
//  Created by ydcq on 15/6/5.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstRowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UISwitch *openwitch;
- (IBAction)switchAction:(UISwitch *)sender;

@end
