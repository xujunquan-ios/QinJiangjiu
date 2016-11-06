//
//  MyOrderListViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"

@interface MyOrderListViewController : MyViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArray;
    
    UIView *selectView;
}

@property (nonatomic,assign) NSInteger selectCount;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
