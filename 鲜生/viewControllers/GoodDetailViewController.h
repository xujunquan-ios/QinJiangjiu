//
//  GoodDetailViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "GoodModel.h"

@interface GoodDetailViewController : MyViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;

@property (weak, nonatomic) IBOutlet UIView *shoucangView;
@property (weak, nonatomic) IBOutlet UIImageView *shoucangImageView;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;

@property (weak, nonatomic) IBOutlet UIButton *shoppingCartBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;


@property (retain ,nonatomic) UILabel *yingyang1;
@property (retain ,nonatomic) UILabel *yingyang2;
@property (retain ,nonatomic) UILabel *yingyang3;

@property (retain ,nonatomic) UILabel *numberLab;
@property (retain ,nonatomic) UILabel *priceLab;


@property (retain ,nonatomic) NSString *pid;

@property (retain ,nonatomic) NSString *isZero;


//@property (retain ,nonatomic) GoodModel *modelShuansong;



@end
