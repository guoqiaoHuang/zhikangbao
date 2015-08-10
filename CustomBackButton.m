//
//  CustomBackButton.m
//  Legend
//
//  Created by fuhuiqiang on 15/3/17.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "CustomBackButton.h"

@implementation CustomBackButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


+ (UIButton *)createBackButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 13, 20);
    //当点击的时候显示为高亮
    button.showsTouchWhenHighlighted = NO;
    return button;
}

@end
