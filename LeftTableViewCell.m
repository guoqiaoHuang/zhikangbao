//
//  LeftTableViewCell.m
//  AiKangBao
//
//  Created by ydcq on 15/5/13.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UIColor* color=[[UIColor alloc]initWithRed:1.0/255.0 green:112.0/255.0 blue:124.0/255 alpha:1];//通过RGB来定义颜色
//    self.selectedBackgroundView.backgroundColor=color;
    self.funcLabel.highlightedTextColor=color;
   // self.biaoshi.layer.cornerRadius=3;
    self.biaoshi.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
