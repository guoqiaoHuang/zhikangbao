//
//  ModifyViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/15.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"密码修改";
//    self.view1.layer.borderWidth=1.0;
//    self.view1.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.view1.layer.masksToBounds=YES;
//    self.view2.layer.borderWidth=1.0;
//    self.view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.view2.layer.masksToBounds=YES;
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
-(void)commit:(UIButton *)button{
    [self getData];
}
-(void)getData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/modify_password/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
        NSDictionary *trackingDic=@{
                                        @"old":@"123456",
                                        @"password":@"123456",
                                        @"repassword":@"123456"
                                        };
    
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"修改密码：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
           
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    self.viewHeight.constant=568* ScreenWidth/320;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
