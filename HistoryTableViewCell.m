//
//  HistoryTableViewCell.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.cornerRadius=self.headImage.width/2;
//    self.headImage.layer.borderWidth=4.0;
//    self.headImage.layer.borderColor=[UIColor colorWithRed:114.0/255.0 green:201.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor;
    self.headImage.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
