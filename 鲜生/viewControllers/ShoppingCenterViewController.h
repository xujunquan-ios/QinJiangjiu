//
//  ShoppingCenterViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"

@interface ShoppingCenterViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (weak, nonatomic) IBOutlet UITableView *goodTableView;

@end
