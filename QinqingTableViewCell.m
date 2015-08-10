//
//  QinqingTableViewCell.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "QinqingTableViewCell.h"

@implementation QinqingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lab0.textColor=[UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0];
    self.lab1.textColor=[UIColor colorWithRed:72.0/255.0 green:204.0/255.0 blue:220.0/255.0 alpha:1.0];
    self.call.backgroundColor=[UIColor colorWithRed:72.0/255.0 green:204.0/255.0 blue:220.0/255.0 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callac:(UIButton *)sender {
    NSString *str=[NSString stringWithFormat:@"tel://%@",self.lab1.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
