//
//  LoginViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
@interface LoginViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIButton *forgetAction;
- (IBAction)regesterAction:(UIButton *)sender;
- (IBAction)forget:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *loginInputView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *baseview;

@end
