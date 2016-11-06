//
//  GoodModel.h
//  FreshMan
//
//  Created by Jie on 15/8/30.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject
@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,strong) NSString *goodName;
@property (nonatomic,strong) NSString *goodPicUrl;
@property (nonatomic,strong) NSString *goodPid;
@property (nonatomic,strong) NSString *goodPrice;
@property (nonatomic,strong) NSString *goodNumber;
@property (nonatomic,strong) NSString *marketPrice;
@property (nonatomic,assign) BOOL select;

@end
