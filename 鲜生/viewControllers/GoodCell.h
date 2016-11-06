//
//  GoodCell.h
//  FreshMan
//
//  Created by Jie on 15/9/6.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

@interface GoodCell : UITableViewCell

@property (strong, nonatomic) UIButton *buyBtn;             //购买
@property (strong, nonatomic) UIButton *shopingCartBtn;     //加入购物车
@property (strong, nonatomic) UIButton *addBtn;             //增加数量
@property (strong, nonatomic) UIButton *subBtn;             //减少数量
@property (strong, nonatomic) UILabel *numberLab;           //数量
@property (strong, nonatomic) UILabel *titleLabel;          //名称
@property (strong, nonatomic) UILabel *priceLabel;          //价格
@property (strong, nonatomic) UILabel *marketPriceLabel;    //市场价格
@property (strong, nonatomic) UIImageView *goodImageView;   //果蔬实拍图片
-(void)setModel:(GoodModel*)model;
@end
