//
//  ShoppingCartTableViewCell.m
//  水果唐
//
//  Created by MacPro on 15-7-25.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"
#define TITLE_GAP 5
#define BTN_HEIGHT 50
#define ADDBTN_WEITH 33

@implementation ShoppingCartTableViewCell
@synthesize imageView,nameLabel,numberLab,addBtn,subBtn,priceLab,selectBtn;
@synthesize topBtn,bottomBtn,selectView,marketPriceLab,totolPriceLab;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

//        UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(20, TITLE_GAP, 2, 120)];
//        view1.backgroundColor = UIColorFromRGB(0xCC3766);
//        [self.contentView addSubview:view1];
//        view1.hidden = YES;
//        
//        UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, TITLE_GAP, 12, 12)];
//        view2.center = CGPointMake(view1.center.x, view2.center.y);
//        view2.backgroundColor = UIColorFromRGB(0xCC3766);
//        view2.layer.cornerRadius = view2.frame.size.width/2;
//        [self.contentView addSubview:view2];
//        view2.hidden = YES;
//        
//        selectView = [[UIView alloc] initWithFrame:CGRectMake(20, TITLE_GAP, 20, view1.frame.size.height-10*2)];
//        selectView.backgroundColor = UIColorFromRGB(0xE55836);
//        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:selectView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft  cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = selectView.bounds;
//        maskLayer.path = maskPath.CGPath;
//        selectView.layer.mask = maskLayer;
//        
//        [self.contentView addSubview:selectView];
//        
//        UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth-150-40, selectView.frame.origin.y, 150+20, selectView.frame.size.height)];
//        view4.backgroundColor = UIColorFromRGB(0xE7F1C9);
//        maskPath = [UIBezierPath bezierPathWithRoundedRect:view4.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight  cornerRadii:CGSizeMake(10, 10)];
//        maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = view4.bounds;
//        maskLayer.path = maskPath.CGPath;
//        view4.layer.mask = maskLayer;
//        
//        
//        topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        topBtn.frame = CGRectMake(view4.frame.size.width-60, 0, 60, view4.frame.size.height/2);
//        topBtn.titleLabel.font = FONTSIZE3;
//        [topBtn setTitle:@"结算" forState:UIControlStateNormal];
//        topBtn.backgroundColor = UIColorFromRGB(0xC2CD93);
//        maskPath = [UIBezierPath bezierPathWithRoundedRect:topBtn.bounds byRoundingCorners:UIRectCornerTopRight  cornerRadii:CGSizeMake(10, 10)];
//        maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = topBtn.bounds;
//        maskLayer.path = maskPath.CGPath;
//        topBtn.layer.mask = maskLayer;
//        [view4 addSubview:topBtn];
//        
//        bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        bottomBtn.frame = CGRectMake(view4.frame.size.width-60, view4.frame.size.height/2, 60, view4.frame.size.height/2);
//        bottomBtn.titleLabel.font = FONTSIZE3;
//        [bottomBtn setTitle:@"删除" forState:UIControlStateNormal];
//        bottomBtn.backgroundColor = UIColorFromRGB(0xB0BE84);
//        maskPath = [UIBezierPath bezierPathWithRoundedRect:bottomBtn.bounds byRoundingCorners:UIRectCornerBottomRight  cornerRadii:CGSizeMake(10, 10)];
//        maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = bottomBtn.bounds;
//        maskLayer.path = maskPath.CGPath;
//        bottomBtn.layer.mask = maskLayer;
//        [view4 addSubview:bottomBtn];
//        
//        
//        [topBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [bottomBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        [self.contentView addSubview:view4];
//        
//        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
//        nameLabel.text = @"柠檬";
//        nameLabel.backgroundColor = [UIColor clearColor];
//        nameLabel.font = FONTSIZE4;
//        nameLabel.numberOfLines = 0;
//        nameLabel.textColor = UIColorFromRGB(0x89A453);
//        [view4 addSubview:nameLabel];
////        view4.backgroundColor = [UIColor redColor];
//        NSLog(@"frame = %f= %f= %f= %f",view4.frame.origin.x,view4.frame.origin.y,view4.frame.size.width,view4.frame.size.height);
//        
//        numberLab = [[UILabel alloc] initWithFrame:CGRectMake(view4.frame.size.width/4-8, 35, 30, 18)];
//        numberLab.backgroundColor = [UIColor whiteColor];
//        numberLab.text = @"1斤";
//        numberLab.textAlignment = 1;
//        [view4 addSubview:numberLab];
//
//        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [addBtn setImage:[UIImage imageNamed:@"shoppingCart_addafter"] forState:UIControlStateNormal];
//        [addBtn setImage:[UIImage imageNamed:@"shoppingCart_add"] forState:UIControlStateDisabled];
////        [addBtn setTitle:@"加" forState:UICont rolStateNormal];
//        addBtn.frame = CGRectMake(view4.frame.size.width/4+24, 35, 18, 18);
////        addBtn.backgroundColor = [UIColor redColor];
//        [view4 addSubview:addBtn];
//        
//        subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [subBtn setImage:[UIImage imageNamed:@"shoppingCart_cutafter"] forState:UIControlStateNormal];
//        [subBtn setImage:[UIImage imageNamed:@"shoppingCart_cut"] forState:UIControlStateDisabled];
////        [subBtn setTitle:@"减" forState:UIControlStateNormal];
////        subBtn.backgroundColor = [UIColor redColor];
//        subBtn.frame = CGRectMake(view4.frame.size.width/4-28, 35, 18, 18);
//        [view4 addSubview:subBtn];
//        
//        UILabel *rmbSymbol = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 8, 8)];
//        rmbSymbol.text = @"¥";
//        rmbSymbol.font = FONTSIZE4;
//        rmbSymbol.textAlignment = 2;
//        rmbSymbol.backgroundColor = [UIColor clearColor];
//        [view4 addSubview:rmbSymbol];
//        
//        priceLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 140, 13)];
//        priceLab.text = @"00.0";
//        priceLab.font = FONTSIZE1;
//        priceLab.textAlignment = 0;
//        priceLab.textColor = [UIColor orangeColor];
//        priceLab.backgroundColor = [UIColor clearColor];
//        [view4 addSubview:priceLab];
//        
//        
//        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(selectView.frame.origin.x+selectView.frame.size.width, TITLE_GAP, view4.frame.origin.x-(selectView.frame.origin.x+selectView.frame.size.width), selectView.frame.size.height)];
//        imageView.backgroundColor = [UIColor greenColor];
//        [self.contentView addSubview:imageView];
        
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(0, 0, 30, 100);
        [selectBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:selectBtn];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 100, 90)];
        imageView.image = [UIImage imageNamed:@"ios占位图5_商场 活动"];
        [self.contentView addSubview:imageView];
        
        //修改有问题
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, mainScreenWidth-200, 15)];
        nameLabel.text = @"菲律宾进口凤梨约100g";
        nameLabel.font = FONTSIZE3;
        nameLabel.numberOfLines = 0;
        [self.contentView addSubview:nameLabel];
        
        
        priceLab = [[UILabel alloc ] initWithFrame:CGRectMake(140, 50, mainScreenWidth-200, 20)];
        priceLab.text = @"¥25元/份";
        priceLab.font = FONTSIZE3;
        priceLab.textColor = [UIColor orangeColor];
        [self.contentView addSubview:priceLab];
        
        marketPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 75, mainScreenWidth-200, 10)];
        marketPriceLab.text = @"市场价：¥30元";
        marketPriceLab.font = FONTSIZE5;
        marketPriceLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:marketPriceLab];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-80, 5, 1, 90)];
        lab.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lab];
        
        totolPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-80, 30, 80, 15)];
        totolPriceLab.text = @"总计:¥20元";
        totolPriceLab.font = FONTSIZE4;
        totolPriceLab.textAlignment = 1;
        totolPriceLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:totolPriceLab];
        
        
        subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.frame = CGRectMake(mainScreenWidth-80, BTN_HEIGHT, ADDBTN_WEITH, ADDBTN_WEITH);
        [subBtn setImage:[UIImage imageNamed:@"cart_cut"] forState:UIControlStateNormal];
        [subBtn setImage:[UIImage imageNamed:@"cart_cutafter"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:subBtn];
//        subBtn.backgroundColor = [UIColor redColor];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(mainScreenWidth-33, BTN_HEIGHT, ADDBTN_WEITH, ADDBTN_WEITH);
        [addBtn setImage:[UIImage imageNamed:@"cart_add"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"cart_addafter"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:addBtn];
//        addBtn.backgroundColor = [UIColor redColor];
        
        
        numberLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-50, BTN_HEIGHT, 20, ADDBTN_WEITH)];
        numberLab.text = @"10";
        numberLab.font = FONTSIZE2;
        numberLab.textAlignment = 1;
        numberLab.textColor = [UIColor orangeColor];
        [self.contentView addSubview:numberLab];
        
        
    }
    return self;
}

-(void)btnPress:(UIButton*)sender{
    
    
    if ([self.delegate respondsToSelector:@selector(btnPress:andFunction:)]) {
        [self.delegate btnPress:self.indexPath andFunction:sender.titleLabel.text];
    }
}

@end
