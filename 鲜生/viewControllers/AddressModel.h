//
//  AddressModel.h
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic,retain) NSString *addressId;   //地址id
@property (nonatomic,retain) NSString *uid;         //用户id
@property (nonatomic,retain) NSString *name;        //姓名
@property (nonatomic,retain) NSString *address;     //地址
@property (nonatomic,retain) NSString *phone;       //电话
@property (nonatomic,retain) NSString *moren;       //默认地址

@end
