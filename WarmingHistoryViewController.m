
//
//  WarmingHistoryViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "WarmingHistoryViewController.h"
#import "UIImageView+WebCache.h"
@interface WarmingHistoryViewController ()

@end

@implementation WarmingHistoryViewController
{
    NSArray *warmingArr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=YES;
        self.isCancel=NO;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"报警记录";
    self.historyTable.tableFooterView=[[UIView alloc]init];
//    self.tableCell=[self.historyTable dequeueReusableHeaderFooterViewWithIdentifier:@"UIKitCell"];
    [self getData];
}
-(void)getData{
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",warmstring);
    NSString *warmingURL=[NSString stringWithFormat:@"%@/advice/index/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",warmingURL);
    NSDictionary *sendDic=@{
                            @"offset":@"1",
                            @"limit":@"10",
                            };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:warmingURL parameters:sendDic sucess:^(id json){
        NSLog(@"warming：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            warmingArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.historyTable reloadData];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];

}
#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return warmingArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WarmingHistoryTableViewCell *cell = (WarmingHistoryTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSDictionary *temDic=warmingArr[indexPath.row];
//    NSDictionary *fontDic=@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:12.0]};
    NSString *text =[temDic objectForKey:@"content"];
    cell.introuduction.text=text;
    CGSize constraint = CGSizeMake(300, 20000.0f);
//    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//       NSLog(@"cell height %f",cell.frame.size.height);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font , NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize heightSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return 1+heightSize.height+cell.pic.height+20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    WarmingHistoryTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"WarmingHistoryTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *temDic=warmingArr[indexPath.section];

    NSString *text = [temDic objectForKey:@"content"];
    
    firstCell.introuduction.text = text;
    [firstCell.pic sd_setImageWithURL:[NSURL URLWithString:[temDic objectForKey:@"pic"]]];
//    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    //设置字体
    
//    NSDictionary *dic=@{NSFontAttributeName: font};
//     CGSize constraint = CGSizeMake(300, 20000.0f);
////    CGSize sizes = [firstCell.introuduction.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |UILineBreakModeWordWrap| NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesDeviceMetrics    attributes:dic context:nil].size;
//    
//    CGSize sizes = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat height=MAX(sizes.height+firstCell.pic.height+1, 185);
//    NSLog(@"gao%f------",height);
////    [firstCell.introuduction setFrame:CGRectMake(10, 0, sizes.width, sizes.height)];
////    firstCell.height=labsize.height+imageSize.height;
//    
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:font , NSParagraphStyleAttributeName:paragraphStyle.copy};
//    
//    CGSize heightSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//     NSLog(@"%@------",NSStringFromCGSize(heightSize));
//    firstCell.introuduction.height=heightSize.height;
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 12.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel *la=[[UILabel alloc]init];
    NSDictionary *temDic=warmingArr[section];
    
    NSString *text = [temDic objectForKey:@"title"];
    la.text=[NSString stringWithFormat:@"     %@",text];
    la.textColor=[UIColor blackColor];
    la.font=[UIFont systemFontOfSize:16.0];
    return la;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *temDic=warmingArr[indexPath.section];
    NSString *url=[temDic objectForKey:@"url"];
    NSURL *urls=[NSURL URLWithString:url];
    WarmingDetailViewController *warmVC=[WarmingDetailViewController new];
    warmVC.urls=urls;
    warmVC.title=@"详情";
    [self.navigationController pushViewController:warmVC animated:YES];
}


@end
