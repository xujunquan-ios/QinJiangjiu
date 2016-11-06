//
//  OneMoneyViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "OneMoneyTableViewCell.h"

@interface OneMoneyViewController : MyViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* dataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@end
