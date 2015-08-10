//
//  SendHelpViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/23.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "SendHelpViewController.h"

@interface SendHelpViewController ()

@end

@implementation SendHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"发送求助";
//    self.photoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"添加照片底块.9"]];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"确 定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bigView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.tittleTextfield.text=@"i am sick";
//    self.contentTextview.text=@"help me please ";
//    self.contentTextview.layer.borderWidth=1.0;
//    self.contentTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.contentTextview.layer.masksToBounds=YES;
//self.contentTextview.delegate
}
-(void)updateViewConstraints
{
    [super updateViewConstraints];
    self.view0Height.constant=568*ScreenWidth/320.0;
}
//提交
-(void)commit:(UIButton *)sender{
    [self.tittleTextfield resignFirstResponder];
    [self.contentTextview resignFirstResponder];
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/call/send/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
        NSDictionary *sendDic=@{
                                    @"device_id":@"123456",
                                    @"title":self.tittleTextfield.text,
                                    @"content":self.contentTextview.text,
                                    };
[self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:sendDic sucess:^(id json){
        NSLog(@"send help：%@,/n%@",json,[json objectForKey:@"message"]);
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    textView.text=@"";
    return YES;
}
- (IBAction)takePhotoAction:(UIButton *)sender {
}
@end
