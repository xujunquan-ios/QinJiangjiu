//
//  PayOrderViewController.h
//  FreshMan
//
//  Created by Jie on 15/9/15.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "WXApi.h"

@interface PayOrderViewController : MyViewController<WXApiDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) NSMutableArray *orderArray;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,retain) NSString *totalPrice;
@end
