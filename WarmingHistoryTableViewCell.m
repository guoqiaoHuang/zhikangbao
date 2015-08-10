//
//  WarmingHistoryTableViewCell.m
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "WarmingHistoryTableViewCell.h"

@implementation WarmingHistoryTableViewCell

- (void)awakeFromNib {
      [self.introuduction setNumberOfLines:0];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
