//
//  PersonViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "PersonTableViewCell.h"

@interface PersonViewController : MyViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* dataArray;
    NSMutableArray* orderArray;
}

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
