//
//  MessageViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "MessageTableViewCell.h"
#import "MBProgressHUD.h"

@interface MessageViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
