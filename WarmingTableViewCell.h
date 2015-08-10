//
//  WarmingTableViewCell.h
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarmingTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UITextField *valueText;
@property(nonatomic,retain)NSString *string1;
@property(nonatomic,retain)NSString *string2;
@property(nonatomic,retain)NSString *string3;
@end
