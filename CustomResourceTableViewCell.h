//
//  CustomResourceTableViewCell.h
//  IVMSDemo
//
//  Created by songqi on 15-4-7.
//  Copyright (c) 2015年 songqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomResourceTableViewCell;
@protocol CustomResourceTableViewCellDelegate <NSObject>
- (void)cell:(CustomResourceTableViewCell *)cell expandToNextStage:(NSMutableArray *)array;
- (UIViewController *)fetchFatherViewCtrl;
-(void)stopLoading;
-(void)startLoading;
@end
@class CMSPInfo;
@interface CustomResourceTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger resourceType;
@property(nonatomic,retain)CMSPInfo *serverInfo;
@property(nonatomic,retain)id dataInfo;
@property(nonatomic,assign)NSInteger fatherDataID;
@property(nonatomic,assign)id<CustomResourceTableViewCellDelegate> delegate;

- (void)setCellContent:(id)data withServerInfo:(CMSPInfo *)mspInfo;
-(void)getsource;
@end
