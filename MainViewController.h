//
//  MainViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "LeftViewController.h"
#import "SliderViewController.h"
#import "RecordViewController.h"
#import "YKTViewController.h"
#import "PositionViewController.h"
#import "PositionTabBarVieewcontroller.h"
#import "LongDistanceViewController.h"
#import "CallViewController.h"
#import "VedioViewController.h"
@interface MainViewController : BaseViewController
- (IBAction)showLeft:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vew1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Height;
@property (weak, nonatomic) IBOutlet UIButton *recordAction;
- (IBAction)record:(UIButton *)sender;
@property(nonatomic,retain)BaseNavigationController *base;
@property (weak, nonatomic) IBOutlet UIButton *yjtButton;
- (IBAction)yktAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *place;
- (IBAction)positionAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UILabel *recordLab1;

@property (weak, nonatomic) IBOutlet UILabel *callLab2;
@property (weak, nonatomic) IBOutlet UILabel *positionLab1;
@property (weak, nonatomic) IBOutlet UILabel *shipinLab2;
@property (weak, nonatomic) IBOutlet UILabel *farLab1;
@property (weak, nonatomic) IBOutlet UILabel *yktLab;
@property (weak, nonatomic) IBOutlet UIButton *longDistance;
- (IBAction)longDistanceAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
- (IBAction)callAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *vidioButton;
- (IBAction)vedioAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)rightAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *biaoshi;

@end
