//
//  DeviceTableViewCell.m
//  AiKangBao
//
//  Created by ydcq on 15/6/8.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "MyDeviceViewController.h"
@implementation DeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)unbind:(UIButton *)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要解绑该设备吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex==0) {
        NSLog(@"0");
    } else {
        NSLog(@"1");
//        [self.tableView reloadData];
        [self freeBind];
 
    }
}
-(void)freeBind{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/device/unbind/api_key/%@",apiUrl,devicetring];
    NSLog(@"%@",trackingUrl);
    NSDictionary *tempDic=self.deviceData[self.unbind.tag];
    NSString *personID=[tempDic objectForKey:@"person_id"];
     NSString *deviceID=[tempDic objectForKey:@"device_sn"];
    NSDictionary *trackingDic=@{
                                    @"device_sn":deviceID,
                                    @"person_id":personID
    
                                };
    [[CustomMBProgressHUD sharedCustomHUD] showSimple:self.viewController.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"解除绑定：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.viewController.view withTitle:[json objectForKey:@"message"]];
            MyDeviceViewController *myVC= (MyDeviceViewController *)self.viewController;
            [myVC getdata];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.viewController.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.viewController.view withTitle:@"亲，网络不给力哦！"];
    }];

}
@end
