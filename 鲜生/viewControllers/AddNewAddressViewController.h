//
//  AddNewAddressViewController.h
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "AddressModel.h"

@protocol NewAddressDelegate <NSObject>

-(void)newAddressModel:(AddressModel *)newModel;

@end

@interface AddNewAddressViewController : MyViewController
@property (nonatomic,retain) AddressModel *model;
@property (nonatomic,retain) NSString *userType;//用途 0在管理中修改  1在管理中添加 2在购物车中添加
//@property (nonatomic ,assign) id<NewAddressDelegate>newAddressDelegate;
@end
