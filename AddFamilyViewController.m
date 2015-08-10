//
//  AddFamilyViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "AddFamilyViewController.h"

@interface AddFamilyViewController ()

@end

@implementation AddFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加家人";
    // Do any additional setup after loading the view from its nib.
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
//    self.relationText.text=@"哥哥";
//    self.IDText.text=@"1234567890987654";
//    self.nameText.text=@"剑阁";
//    self.phoneText.text=@"18938938814";
     self.nameLab.textColor= self.phoneLab.textColor=self.relationLab.textColor=self.IDLab.textColor=[UIColor HexColorSixteen:@"48ccdc"];
}
-(void)commit:(UIButton *)button{
    [self postData];
}
-(void)postData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/member_add/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
        NSDictionary *trackingDic=@{
                                        @"identity_card_id":self.IDText.text,
                                        @"device_sn":@"123456",
                                        @"relationship":self.relationText.text,
                                        @"person_name":self.nameText.text,
                                        @"mobile":self.phoneText.text
                                        };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"添加家人：%@,/n%@",json,[json objectForKey:@"message"]);
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return  [textField resignFirstResponder];
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
