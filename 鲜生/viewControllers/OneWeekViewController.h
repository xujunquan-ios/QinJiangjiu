//
//  OneWeekViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"

@interface OneWeekViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray* dataArray;
    
    NSInteger selectCount;
}
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *fruitBtn;
@property (weak, nonatomic) IBOutlet UIButton *vegetablesBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
