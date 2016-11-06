//
//  ShoppingCartTableViewCell.h
//  水果唐
//
//  Created by MacPro on 15-7-25.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCatrCellDelegata <NSObject>

-(void)btnPress:(NSIndexPath*)indexPath andFunction:(NSString*)function;

@end

@interface ShoppingCartTableViewCell : UITableViewCell



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,retain)NSIndexPath* indexPath;
@property (nonatomic,assign)id <ShoppingCatrCellDelegata>delegate;

@property (nonatomic,retain)UIImageView* imageView;//
@property (nonatomic,retain)UILabel* nameLabel;//
@property (nonatomic,retain)UILabel *numberLab;//数量
@property (nonatomic,retain) UIButton *addBtn;//
@property (nonatomic,retain) UIButton *subBtn;//
@property (nonatomic,retain) UIButton *topBtn;//结算
@property (nonatomic,retain) UIButton *bottomBtn;//删除
@property (nonatomic,retain) UIButton *selectBtn;//选中button
@property (nonatomic,retain) UILabel *priceLab;//
@property (nonatomic,retain) UILabel *marketPriceLab;//
@property (nonatomic,retain) UILabel *totolPriceLab;//
@property (nonatomic,retain) UIView *selectView;

//@property (nonatomic,retain) UIButton* topBtn;//删除
//@property (nonatomic,retain) UIButton *bottomBtn;//删除



@end
