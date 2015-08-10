//
//  Position2ViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/5/18.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "JSONKit.h"
#import "location.h"
#import "DLRadioButton.h"
@interface Position2ViewController : BaseViewController<NSCoding>
@property (weak, nonatomic) IBOutlet DLRadioButton *collection;
@property (strong, nonatomic) IBOutletCollection(DLRadioButton) NSArray *topRadioButtons;
- (IBAction)show:(UIButton *)sender;
@property(nonatomic,retain)UIDatePicker * dataPicker;
- (IBAction)oneDayAction:(DLRadioButton *)sender;
@property (weak, nonatomic) IBOutlet DLRadioButton *one;
@property (weak, nonatomic) IBOutlet DLRadioButton *two;
@property (weak, nonatomic) IBOutlet DLRadioButton *three;

@end
