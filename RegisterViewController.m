//
//  RegisterViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户注册";
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"确 定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(regesiter:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.phoneText.text=@"18927452013";
//    self.codeText.text=@"1234";
    self.lab1.textColor=self.lab2.textColor=self.lab3.textColor=[UIColor HexColorSixteen:@"48ccdc"];
    self.getcode.backgroundColor=[UIColor HexColorSixteen:@"48ccdc"];
    [self.getcode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//提交注册
-(void)regesiter:(UIButton *)sender{
    NSString *loginUrl=[NSString stringWithFormat:@"%@/register",BaseURL];
    if ([self.codeText.text isEqualToString:@""]) {
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"请填写验证码"];
        return;
        
    }
    NSDictionary *logDic=@{
                           @"mobile":self.phoneText.text,
                           @"password":self.passwordText.text,
                           @"verify":self.codeText.text,
                          // @"nickname":@"",
                           };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:loginUrl parameters:logDic sucess:^(id json){
        NSLog(@"提交注册返回的信息：%@,%@",json,[json objectForKey:@"message"]);
        
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *err){
        NSLog(@"请求失败：%@",err.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:err.description];
    }];
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewHeight.constant=568*ScreenWidth/320;
}
#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return  [textField resignFirstResponder];
}

- (IBAction)getCode:(UIButton *)sender {
    NSString *loginUrl=[NSString stringWithFormat:@"%@/get_vcode",BaseURL];
    NSDictionary *logDic=@{
                           @"identity":self.phoneText.text,
//                           @"sig":self.passwordText.text,
//                           @"verify":self.codeText.text,
//                           @"nickname":@"",
                           };
    [BaseHttpRequest postWithUrl:loginUrl parameters:logDic sucess:^(id json){
        NSLog(@"获取验证码返回的信息：%@,%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
             [self resetCodeBtn:sender];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *err){
        NSLog(@"请求失败：%@",err.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"网络出错了"];
    }];

}
-(void)resetCodeBtn:(UIButton *)button{
    __block int timeout=60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [button setTitle:@"发送验证码" forState:UIControlStateNormal];
                button.titleLabel.font=[UIFont systemFontOfSize:12.0];
                button.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [button setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                button.titleLabel.font=[UIFont systemFontOfSize:10.0];
                
                button.userInteractionEnabled = NO;
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);

}
@end
