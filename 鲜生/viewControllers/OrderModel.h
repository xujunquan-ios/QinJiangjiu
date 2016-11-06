//
//  OrderModel.h
//  FreshMan
//
//  Created by Jie on 15/9/24.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSString *tradeId;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSArray *product;
@property (nonatomic,strong) NSString *time;
@end
