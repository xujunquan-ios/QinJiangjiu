//
//  ShoppingCartViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "ShoppingCartTableViewCell.h"

@interface ShoppingCartViewController : MyViewController <UITableViewDataSource,UITableViewDelegate,ShoppingCatrCellDelegata>
{
    NSMutableArray* dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
