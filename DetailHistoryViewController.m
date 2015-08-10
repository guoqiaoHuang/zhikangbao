//
//  DetailHistoryViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/15.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "DetailHistoryViewController.h"

@interface DetailHistoryViewController ()

@end

@implementation DetailHistoryViewController
{
    NSString *askString;
    NSString *answerString;
    NSString *statueString;
    NSString *askTittle;
    UILabel *label;
    UILabel *askLab;
    UILabel *answer;
    UILabel *answerContent;
    UILabel *statueLabel;
    UILabel *tittleLabel;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    // Do any additional setup after loading the view from its nib.
    [self getData];
   
    
}

-(void)getData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/call/help_info/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
        NSDictionary *trackingDic=@{
                                        @"id":self.historyID
    
                                        };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"历史记录：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            NSDictionary *tempDic=[json objectForKey:@"data"];
            
            askString=[tempDic objectForKey:@"content"];
            NSDictionary *tempDic2=[tempDic objectForKey:@"reply"];
            answerString=[tempDic2 objectForKey:@"content"];
            statueString=[tempDic2 objectForKey:@"remark"];
            askTittle=[tempDic objectForKey:@"title"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self createUI];
            
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}
-(void)createUI{
    label=[[UILabel alloc]init];
    label.backgroundColor=[UIColor cyanColor];
    label.text=@" 问";
    label.font=[UIFont systemFontOfSize:15.0];
    [self.view addSubview:label];
    tittleLabel=[[UILabel alloc]init];
    tittleLabel.text=askTittle;
    tittleLabel.textColor=[UIColor redColor];
    tittleLabel.font=[UIFont systemFontOfSize:12.0];
    tittleLabel.backgroundColor=[UIColor clearColor];
    tittleLabel.textAlignment=2;
    [self.view addSubview:tittleLabel];
    
    askLab=[[UILabel alloc]init];
    askLab.numberOfLines=0;
    askLab.font=[UIFont systemFontOfSize:14.0];
    askLab.text=askString;
    [self.view addSubview:askLab];
    answer=[[UILabel alloc]init];
    answer.text=@" 答";
    answer.backgroundColor=[UIColor cyanColor];
    answer.font=[UIFont systemFontOfSize:15.0];

    [self.view addSubview:answer];
    statueLabel=[[UILabel alloc]init];
    statueLabel.text=statueString;
    statueLabel.textColor=[UIColor redColor];
    statueLabel.font=[UIFont systemFontOfSize:12.0];
    statueLabel.backgroundColor=[UIColor clearColor];
    statueLabel.textAlignment=2;
    [self.view addSubview:statueLabel];
    answerContent=[[UILabel alloc]init];
    answerContent.numberOfLines=0;
    answerContent.backgroundColor=[UIColor clearColor];
    answerContent.font=[UIFont systemFontOfSize:14.0];
    answerContent.text=answerString;
    [self.view addSubview:answerContent];
//    int padding = 10;
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    CGSize constraint = CGSizeMake(300, 20000.0f);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font , NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize heightSize = [askString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGSize answerheightSize = [answerString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(askLab.mas_top).offset(-1);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-200, 35));
    }];
    [tittleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.mas_top).with.offset(0);
        //        make.left.equalTo(self.view.mas_left).with.offset(100);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        //        make.bottom.equalTo(answer.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(200, 35));
        //        make.top.equalTo(self.view.topMargin);
    }];
    [askLab mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.mas_bottom).with.offset(1);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(answer.mas_top).offset(-1);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, heightSize.height+20));
    }];
    [answer mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(askLab.mas_bottom).with.offset(1);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(answerContent.mas_top).offset(-1);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-200, 35));
    }];
    
    [statueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(answer.mas_top).with.offset(0);
//        make.left.equalTo(self.view.mas_left).with.offset(100);
        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.bottom.equalTo(answer.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(200, 35));
//        make.top.equalTo(self.view.topMargin);
    }];
    [answerContent mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(answer.mas_bottom).with.offset(1);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.bottom.equalTo(answerContent.mas_top).offset(-1);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, answerheightSize.height+20));
    }];
}

@end
