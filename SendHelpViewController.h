//
//  SendHelpViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/23.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"

@interface SendHelpViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIView *smallView;
@property (weak, nonatomic) IBOutlet UITextField *tittleTextfield;
@property (weak, nonatomic) IBOutlet UITextView *contentTextview;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
- (IBAction)takePhotoAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view0Height;
@property (weak, nonatomic) IBOutlet UIView *photoView;

@end
