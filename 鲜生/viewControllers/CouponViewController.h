//
//  CouponViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "CouponTableViewCell.h"

@interface CouponViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *ruleImage;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@end
