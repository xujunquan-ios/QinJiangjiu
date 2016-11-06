//
//  OrderCell.h
//  FreshMan
//
//  Created by Jie on 15/9/24.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderCell : UITableViewCell
@property (nonatomic,strong) UILabel *timeLab;
//@property (nonatomic,strong) UILabel *nameLab;
//@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *totalLab;
//@property (nonatomic,strong) UIImageView *orderImageView;
@property (nonatomic,strong) UILabel *statusLab;
@property (nonatomic,strong) UIView* fvView;
@property (nonatomic,strong) UIButton *payBtn;//去支付按钮
@property (nonatomic,strong) UIButton *deleteBtn;//删除按钮
-(void)setModel:(OrderModel *)newModel;
@end
