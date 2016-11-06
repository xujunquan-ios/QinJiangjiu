//
//  GoodViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "GoodTableViewCell.h"
#import "MBProgressHUD.h"

@interface GoodViewController : MyViewController <UITableViewDelegate,UITableViewDataSource,GoodTableViewCellDelegate>
{
    NSMutableArray* dataArray;
}

@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,strong) NSString *goodType;


@end
