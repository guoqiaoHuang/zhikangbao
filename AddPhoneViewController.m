
//
//  AddPhoneViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/7/30.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "AddPhoneViewController.h"

@interface AddPhoneViewController ()

@end

@implementation AddPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"添加亲情号";
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
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
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/device/lists/api_key/%@",apiUrl,devicetring];
    NSLog(@"%@",trackingUrl);
    ////    NSDictionary *trackingDic=@{
    //                                @"device_id":@"123456"
    //
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"设备：%@,/n%@",json,[json objectForKey:@"message"]);
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
