//
//  CustomResourceTableViewCell.m
//  IVMSDemo
//
//  Created by songqi on 15-4-7.
//  Copyright (c) 2015年 songqi. All rights reserved.
//

#import "CustomResourceTableViewCell.h"
#import "VMSNetSDK.h"
#import "RealPlayViewController.h"
#import "UIView+Additions.h"
@interface CustomResourceTableViewCell()
@property(nonatomic,assign)IBOutlet UILabel *nameLable;
@property(nonatomic,assign)IBOutlet UIButton *realPlayBtn;
@property(nonatomic,assign)IBOutlet UIButton *expandBtn;
@property(nonatomic,retain)IBOutlet NSString *serverAddr;
@end

@implementation CustomResourceTableViewCell
{
     UIActivityIndicatorView *activity;//活动指示器
}
- (void)awakeFromNib {
    // Initialization code
    self.serverAddr = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_ADDRESS];
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];//指定进度轮的大小
    //    activity.backgroundColor = [UIColor lightGrayColor];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
//    [homeWebView addSubview:activity];
    activity.frame = CGRectMake(0, 0, 35, 35);
    activity.center=self.viewController.view.center;
    activity.hidden=YES;
    [self.viewController.view addSubview:activity];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.serverInfo = nil;
    self.dataInfo = nil;
    self.delegate = nil;
//    [super dealloc];
}
- (void)setCellContent:(id)data withServerInfo:(CMSPInfo *)mspInfo
{
    self.serverInfo = mspInfo;
    NSLog(@"frame = %@",NSStringFromCGRect(self.frame));
    if([data isKindOfClass:[CControlUnitInfo class]])
    {
        self.resourceType = 0;
        self.dataInfo = data;
        
        CControlUnitInfo *tmpDataInfo = (CControlUnitInfo *)data;
        self.nameLable.text = tmpDataInfo.name;
        [self.realPlayBtn setHidden:YES];
        [self.expandBtn setHidden:NO];
    }
    else if([data isKindOfClass:[CRegionInfo class]])
    {
        self.resourceType = 1;
        self.dataInfo = data;
        
        CRegionInfo *tmpDataInfo = (CRegionInfo *)data;
        self.nameLable.text = tmpDataInfo.name;
        [self.realPlayBtn setHidden:YES];
        [self.expandBtn setHidden:NO];
    }
    else if([data isKindOfClass:[CCameraInfo class]])
    {
        self.resourceType = 2;
        self.dataInfo = data;
        CCameraInfo *tmpDataInfo = (CCameraInfo *)data;
        self.nameLable.text = tmpDataInfo.name;
        [self.realPlayBtn setHidden:NO];
        [self.expandBtn setHidden:YES];
    }
}
- (IBAction)expandBtnClick:(id)sender {
    if(self.resourceType == 2)
    {
        return;
    }
     [self.delegate startLoading];
    NSMutableArray *newArray = [NSMutableArray array];
    if(self.resourceType == 0)
    {
        
        NSMutableArray *newControlUnitArray = [NSMutableArray array];
        NSMutableArray *newRegionArray = [NSMutableArray array];
        NSMutableArray *newCameraArray = [NSMutableArray array];
        dispatch_queue_t aQueue;
        aQueue = dispatch_get_global_queue(0,0);
        dispatch_async(aQueue, ^{
        [[VMSNetSDK shareInstance] getControlUnitList:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toControlUnitList:newControlUnitArray];
        
        [[VMSNetSDK shareInstance] getRegionListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1   toRegionList:newRegionArray];
        
        [[VMSNetSDK shareInstance] getCameraListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate stopLoading];
        [newArray addObjectsFromArray:newControlUnitArray];
        [newArray addObjectsFromArray:newRegionArray];
        [newArray addObjectsFromArray:newCameraArray];
        if(0 == [newArray count])
        {
            NSLog(@"没有资源");
            return;
        }
        [self.delegate cell:self expandToNextStage:newArray];
        });
        });
    
    
    }
    else if(self.resourceType == 1)
    {
        
        NSMutableArray *newRegionArray = [NSMutableArray array];
        NSMutableArray *newCameraArray = [NSMutableArray array];
        dispatch_queue_t aQueue;
        aQueue = dispatch_get_global_queue(0,0);
        dispatch_async(aQueue, ^{
        [[VMSNetSDK shareInstance] getRegionListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toRegionList:newRegionArray];
        [[VMSNetSDK shareInstance] getCameraListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stopLoading];
        [newArray addObjectsFromArray:newRegionArray];
        [newArray addObjectsFromArray:newCameraArray];
        if(0 == [newArray count])
        {
            NSLog(@"没有资源");
            return;
        }

        [self.delegate cell:self expandToNextStage:newArray];
        
        });
        });

    }
    
}
-(void)getsource{
//    if(self.resourceType == 2)
//    {
//        return;
//    }
//    
//    NSMutableArray *newArray = [NSMutableArray array];
//    if(self.resourceType == 0)
//    {
//        
//        NSMutableArray *newControlUnitArray = [NSMutableArray array];
//        NSMutableArray *newRegionArray = [NSMutableArray array];
//        NSMutableArray *newCameraArray = [NSMutableArray array];
//        [[VMSNetSDK shareInstance] getControlUnitList:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toControlUnitList:newControlUnitArray];
//        
//        [[VMSNetSDK shareInstance] getRegionListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1   toRegionList:newRegionArray];
//        
//        [[VMSNetSDK shareInstance] getCameraListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
//        
//        [newArray addObjectsFromArray:newControlUnitArray];
//        [newArray addObjectsFromArray:newRegionArray];
//        [newArray addObjectsFromArray:newCameraArray];
//        if(0 == [newArray count])
//        {
//            NSLog(@"没有资源");
//            return;
//        }
//        [self.delegate cell:self expandToNextStage:newArray];
//        
//        
//    }
//    else if(self.resourceType == 1)
//    {
//        activity.hidden=NO;
//        [activity startAnimating];
//        NSMutableArray *newRegionArray = [NSMutableArray array];
//        NSMutableArray *newCameraArray = [NSMutableArray array];
//        
//        [[VMSNetSDK shareInstance] getRegionListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toRegionList:newRegionArray];
//        [[VMSNetSDK shareInstance] getCameraListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
//        
//        [newArray addObjectsFromArray:newRegionArray];
//        [newArray addObjectsFromArray:newCameraArray];
//        if(0 == [newArray count])
//        {
//            NSLog(@"没有资源");
//            return;
//        }
//        
//        [self.delegate cell:self expandToNextStage:newArray];
//        
//    }
//    activity.hidden=NO;
//    [activity startAnimating];
    
    
    if(self.resourceType == 2)
    {
        return;
    }
    [self.delegate startLoading];
    NSMutableArray *newArray = [NSMutableArray array];
    if(self.resourceType == 0)
    {
        
        NSMutableArray *newControlUnitArray = [NSMutableArray array];
        NSMutableArray *newRegionArray = [NSMutableArray array];
        NSMutableArray *newCameraArray = [NSMutableArray array];
        dispatch_queue_t aQueue;
        aQueue = dispatch_get_global_queue(0,0);
        dispatch_async(aQueue, ^{
            [[VMSNetSDK shareInstance] getControlUnitList:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toControlUnitList:newControlUnitArray];
            
            [[VMSNetSDK shareInstance] getRegionListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1   toRegionList:newRegionArray];
            
            [[VMSNetSDK shareInstance] getCameraListFromCtrlUnit:self.serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:((CControlUnitInfo *)self.dataInfo).controlUnitID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stopLoading];
                [newArray addObjectsFromArray:newControlUnitArray];
                [newArray addObjectsFromArray:newRegionArray];
                [newArray addObjectsFromArray:newCameraArray];
                if(0 == [newArray count])
                {
                    NSLog(@"没有资源");
                    return;
                }
                [self.delegate cell:self expandToNextStage:newArray];
            });
        });
        
        
    }
    else if(self.resourceType == 1)
    {
        
        NSMutableArray *newRegionArray = [NSMutableArray array];
        NSMutableArray *newCameraArray = [NSMutableArray array];
        dispatch_queue_t aQueue;
        aQueue = dispatch_get_global_queue(0,0);
        dispatch_async(aQueue, ^{
            [[VMSNetSDK shareInstance] getRegionListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toRegionList:newRegionArray];
            [[VMSNetSDK shareInstance] getCameraListFromRegion:self.serverAddr toSessionID:self.serverInfo.sessionID toRegionID:((CRegionInfo *)self.dataInfo).regionID toNumPerOnce:20 toCurPage:1 toCameraList:newCameraArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate stopLoading];
                [newArray addObjectsFromArray:newRegionArray];
                [newArray addObjectsFromArray:newCameraArray];
                if(0 == [newArray count])
                {
                    NSLog(@"没有资源");
                    return;
                }
                
                [self.delegate cell:self expandToNextStage:newArray];
                
            });
        });
        
    }
}
- (IBAction)realplayBtnClick:(id)sender {
    
    if(self.resourceType != 2)
    {
        return;
    }

    RealPlayViewController *realplayViewCtr = [[RealPlayViewController alloc] initWithNibName:NSStringFromClass([RealPlayViewController class]) bundle:nil withServerInfo:self.serverInfo withCameraInfo:self.dataInfo] ;
    
    [[self.delegate fetchFatherViewCtrl].navigationController pushViewController:realplayViewCtr animated:YES];
}

@end
