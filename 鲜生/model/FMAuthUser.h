//
//  FMAuthUser.h
//  FreshMan
//
//  Created by VictorXiong on 15/8/18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMAuthUser : NSObject

@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) NSNumber *token;

+ (FMAuthUser *)sharedInstance;

@end
