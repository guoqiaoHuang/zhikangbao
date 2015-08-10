//
//  NSDictionary+Help.m
//  AiKangBao
//
//  Created by ydcq on 15/6/8.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "NSDictionary+Help.h"

@implementation NSDictionary (Help)
+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data,
                                                               kCFPropertyListImmutable,
                                                               NULL);
    if(plist == nil) return nil;
    if ([(__bridge id)plist isKindOfClass:[NSDictionary class]]) {
        return (__bridge NSDictionary *)plist;
    }
    else {
        CFRelease(plist);
        return nil;
    }
}
@end
