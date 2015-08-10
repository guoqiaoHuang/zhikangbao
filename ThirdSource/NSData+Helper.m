//
//  NSData+Helper.m
//  Copyright (c)  All rights reserved.
//

#import "NSData+Helper.h"

@implementation NSData (Helper)

+ (NSData*)toJSON:(NSDictionary *)dict
{
    NSError* error =nil;
    id result =[NSJSONSerialization dataWithJSONObject:dict
                                               options:kNilOptions error:&error];
    if(error !=nil)
    {
        NSLog(@"the jsion error is %@",error);
        return nil;
    }
    return result;
}

@end
