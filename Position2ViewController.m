//
//  Position2ViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/18.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "Position2ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "Tracking.h"
#import "ShowTrackingViewController.h"
@interface Position2ViewController ()<MAMapViewDelegate, TrackingDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) Tracking *tracking;
@property (assign)CLLocationCoordinate2D coords;
@property (nonatomic) NSArray *buttomRadioButtons;
@end

@implementation Position2ViewController
{
    NSMutableArray *locationArr;
     UIView *toolView;
     NSString *select;//日历选中的日期
}
@synthesize mapView  = _mapView;
@synthesize tracking = _tracking;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=NO;
        self.isCancel=YES;
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title=@"位置2";
    
//    [self setupMapView];
   
    for (DLRadioButton *radioButton in self.topRadioButtons) {
        radioButton.ButtonIcon = [UIImage imageNamed:@"RadioButton"];
        radioButton.ButtonIconSelected = [UIImage imageNamed:@"RadioButtonSelected"];
//        [radioButton setBackgroundColor:[UIColor brownColor]];
        radioButton.circleColor = [UIColor redColor];
        radioButton.indicatorColor = [UIColor redColor];
    }
    

    self.dataPicker=[[UIDatePicker alloc]init];
    self.dataPicker.center=CGPointMake(ScreenWidth/2, ScreenHeight-self.dataPicker.height/2-49);
    self.dataPicker.datePickerMode=UIDatePickerModeDate;
    
    [self.dataPicker setLocale:[[NSLocale
                                 alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    NSDate* maxDate = [NSDate date];
    self.dataPicker.backgroundColor=[UIColor lightGrayColor];
    //    self.dataPicker.minimumDate = minDate;
    self.dataPicker.maximumDate = maxDate;
    toolView=[[UIView alloc]initWithFrame:CGRectMake(0, self.dataPicker.top-35, ScreenWidth, 35)];
    toolView.backgroundColor=[UIColor lightGrayColor];
    
    [self.dataPicker addTarget:self action:@selector(getData:) forControlEvents:UIControlEventValueChanged];
    //    日历控件工具按钮
    UIButton *leftBtn=[[UIButton alloc]init];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:leftBtn];
    UIButton *rightBtn=[[UIButton alloc]init];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(completionAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:rightBtn];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(toolView.mas_top).offset(5);
        make.left.equalTo(toolView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(45, 25));
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(toolView.mas_top).offset(5);
        make.right.equalTo(toolView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(45, 25));
    }];

 }
//取消
-(void)cancelAction:(UIButton *)button{
    [toolView removeFromSuperview];
    [self.dataPicker removeFromSuperview];
}
//完成
-(void)completionAction:(UIButton *)button{
    [toolView removeFromSuperview];
    [self.dataPicker removeFromSuperview];
    
}
//获取日期值
-(void)getData:(UIDatePicker *)datePicker{
    NSDate *selectDate=[datePicker date];
    NSDateFormatter * dateFormate=[[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    select=[dateFormate stringFromDate:selectDate];
    NSLog(@"current date:%@",select);
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.bounds;
}

-(void)didReceiveMemoryWarning{
    NSLog(@"i am going die");
}
- (IBAction)show:(UIButton *)sender {
    [self showSelectedButton:self.topRadioButtons];
}

- (IBAction)oneDayAction:(DLRadioButton *)sender {
    [self.view insertSubview:self.dataPicker aboveSubview:self.view];
    [self.view insertSubview:toolView aboveSubview:self.view];
}
- (void)showSelectedButton:(NSArray *)radioButtons {
 //   NSString *buttonName = [(DLRadioButton *)radioButtons[0] selectedButton].titleLabel.text;
//    [[[UIAlertView alloc] initWithTitle: buttonName ? @"Selected Button" : @"No Button Selected" message:buttonName delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    ShowTrackingViewController *showVC=[ShowTrackingViewController new];
    BaseNavigationController *baseNav=[[BaseNavigationController alloc]initWithRootViewController:showVC];
    [self presentViewController:baseNav animated:YES completion:nil];
}

@end
