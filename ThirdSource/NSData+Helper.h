//
//  NSData+Helper.h
//  Copyright (c)  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Helper)

//字典转NSData
+ (NSData*)toJSON:(NSDictionary *)dict;

@end
