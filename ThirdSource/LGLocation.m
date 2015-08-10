//
//  LGLocation.m
//  Legend
//
//  Created by wuzhantu on 15/3/7.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "LGLocation.h"
#import <UIKit/UIKit.h>

@implementation LGLocation


+ (LGLocation *)Location:(LocationBlock)locationBlock
{
    //多线程并发时
    static LGLocation *location = nil ;
    static dispatch_once_t pred ;
    
    dispatch_once(&pred, ^{
        
        location = [[LGLocation alloc] init];
    });
    
    [location dingwei:locationBlock];
    
    return location;
}

- (void)dingwei:(LocationBlock)locationBlock
{
    self.locationBlock = locationBlock;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    BOOL is = [CLLocationManager locationServicesEnabled];
    NSLog(@"keyibule %d",is);
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"version %@",[[UIDevice currentDevice] systemVersion]);
    if (systemVersion >= 8.0) {
        
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}


#pragma cllocation  delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];

    if (self.locationBlock) {
        self.locationBlock(location);
        self.locationBlock = nil;
        [self.locationManager stopUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位error:%@",error);
}

@end
