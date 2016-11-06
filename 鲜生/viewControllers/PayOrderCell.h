//
//  PayOrderCell.h
//  FreshMan
//
//  Created by Jie on 15/9/15.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderCell : UITableViewCell
@property (nonatomic,strong)UIImageView* mainImageView;//
@property (nonatomic,strong)UILabel* nameLabel;//
@property (nonatomic,strong)UILabel *subNameLabel;//数量
@property (nonatomic,strong)UILabel *priceLaberl;//数量
@property (nonatomic,strong) UIButton *addBtn;//
@property (nonatomic,strong) UIButton *subBtn;//
@property (nonatomic,retain)UILabel *numberLab;//数量

@end
