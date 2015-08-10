//
//  FindPasswordViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface FindPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
- (IBAction)getcodeAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@end
