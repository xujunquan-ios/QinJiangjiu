//
//  AddressListViewController.h
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "AddressModel.h"
@protocol AddressListDelegate <NSObject>

-(void)selectAddress:(AddressModel *)model;

@end

@interface AddressListViewController : MyViewController
@property (nonatomic,retain) NSString *fathType;
@property (nonatomic,assign) id<AddressListDelegate>addressDelegate;
//@property (assign, nonatomic)id <MyViewControllerDelegate>delegate;

@end
