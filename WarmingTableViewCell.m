//
//  WarmingTableViewCell.m
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "WarmingTableViewCell.h"

@implementation WarmingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return  [textField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    switch (textField.tag) {
        case 0:
            self.string1=textField.text;
            break;
        case 1:
            self.string2=textField.text;
            break;
        case 2:
            self.string3=textField.text;
            break;
        default:
            break;
    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
