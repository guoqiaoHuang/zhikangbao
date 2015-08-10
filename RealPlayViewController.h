//
//  RealPlayViewController.h
//  IVMSDemo
//
//  Created by songqi on 15-4-8.
//  Copyright (c) 2015年 songqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMSPInfo;
@class CCameraInfo;
@interface RealPlayViewController : UIViewController
@property(nonatomic,assign)IBOutlet UIView *playView;
@property(nonatomic,retain)CMSPInfo *serverInfo;
@property(nonatomic,retain)CCameraInfo *cameraInfo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServerInfo:(CMSPInfo *)serverInfo withCameraInfo:(CCameraInfo *)cameraInfo;

@property (nonatomic, retain)  UIButton  *backTouchBtn;
@end
