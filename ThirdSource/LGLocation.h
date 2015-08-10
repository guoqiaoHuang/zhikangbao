//
//  LGLocation.h
//  Legend
//
//  Created by wuzhantu on 15/3/7.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void(^LocationBlock) (CLLocation *location);

@interface LGLocation : NSObject<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic)LocationBlock locationBlock;

+ (LGLocation *)Location:(LocationBlock)locationBlock;

@end
