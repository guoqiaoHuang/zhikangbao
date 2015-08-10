//
//  LoginViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "LoginViewController.h"
#import "SliderViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=NO;
        self.isCancel=NO;
        
    }
    return self;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.height.constant=568*ScreenWidth/320.0;
//    self.viewHeight.constant=100*ScreenWidth/320.0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登陆";
    self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    NSLog(@"==%@",NSStringFromCGRect(self.view.frame));
    self.loginButton.layer.borderWidth=1.0;
    self.loginButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius=16.0;
    self.loginButton.layer.masksToBounds=YES;
    self.line.backgroundColor=[UIColor colorWithRed:177.0/255.0 green:207.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.baseview.backgroundColor=[UIColor colorWithRed:127.0/255.0 green:202.0/255.0 blue:217.0/255.0 alpha:1.0];
//    self.phoneText.text = @"18503039870";
//    self.passwordText.text = @"123456r";
}
- (void)cancelButtonTapped:(UIButton *)button
{
    [[SliderViewController sharedSliderController]showContentControllerWithModel:@"MainViewController"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)regesterAction:(UIButton *)sender {
    RegisterViewController *regesterVC=[RegisterViewController new];
    self.navigationController.navigationBar.hidden=NO;

    [self.navigationController pushViewController:regesterVC animated:YES];
}

- (IBAction)forget:(UIButton *)sender {
    FindPasswordViewController *findVC=[FindPasswordViewController new];
    self.navigationController.navigationBar.hidden=NO;

    [self.navigationController pushViewController:findVC animated:YES];

}
- (IBAction)loginAction:(UIButton *)sender {
    NSString *loginUrl=[NSString stringWithFormat:@"%@/login",BaseURL];
    NSDictionary *logDic=@{
                           @"identity":self.phoneText.text,
                           @"password":self.passwordText.text,
                           @"remember":@YES,
                           };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:loginUrl parameters:logDic sucess:^(id json){
        NSLog(@"登陆返回的信息：%@,%@",json,[json objectForKey:@"message"]);
        NSString *string=[NSString stringWithFormat:@"%@",[json objectForKey:@"status" ]];
        if (string.integerValue==1) {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            NSDictionary *tempDic=[json objectForKey:@"data"];
            UserInformation *userinformation=[UserInformation sharedUserManager];
            userinformation.api_key=[tempDic objectForKey:@"api_key"];
            NSLog(@"api::%@",userinformation.api_key);
            userinformation.username=[tempDic objectForKey:@"nickname"];
            [[SliderViewController sharedSliderController]showContentControllerWithModel:@"MainViewController"];
            [self dismissViewControllerAnimated:YES completion:nil];
            self.navigationController.navigationBar.hidden=NO;

//            [self presentViewController:[SliderViewController sharedSliderController] animated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            self.view.window.rootViewController = [SliderViewController sharedSliderController];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *err){
        NSLog(@"请求失败：%@",err.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"网络出错了"];
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return  [textField resignFirstResponder];
}

@end
