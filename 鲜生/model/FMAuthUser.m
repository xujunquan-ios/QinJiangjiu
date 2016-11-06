//
//  FMAuthUser.m
//  FreshMan
//
//  Created by VictorXiong on 15/8/18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "FMAuthUser.h"

@implementation FMAuthUser
+ (FMAuthUser *)sharedInstance
{
    static FMAuthUser *userInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInstance = [[FMAuthUser alloc] init];
        
    });
    return userInstance;
}
@end
