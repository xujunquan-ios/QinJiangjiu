//
//  GoodCell.m
//  FreshMan
//
//  Created by Jie on 15/9/6.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "GoodCell.h"
#import "UIImageView+WebCache.h"

@implementation GoodCell
@synthesize buyBtn;
@synthesize shopingCartBtn;
@synthesize addBtn;
@synthesize subBtn;
@synthesize numberLab;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize marketPriceLabel;
@synthesize goodImageView;
#define BTN_HEIGHT 54

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        [self.contentView addSubview:goodImageView];
        goodImageView.backgroundColor = [UIColor redColor];
        
        buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(mainScreenWidth-80, 10, 80, 39);
        [buyBtn setBackgroundColor:UIColorFromRGB(0xf4a417)];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:buyBtn];
        
        shopingCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shopingCartBtn.frame = CGRectMake(mainScreenWidth-80, 50, 80, 39);
        [shopingCartBtn setBackgroundColor:UIColorFromRGB(0xee761b)];
        [shopingCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [shopingCartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopingCartBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:shopingCartBtn];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 20, mainScreenWidth-180, 20)];
        titleLabel.text = @"菲律宾进口凤梨约100g";
        titleLabel.font = FONTSIZE3;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        priceLabel = [[UILabel alloc ] initWithFrame:CGRectMake(95, 50, 75, 20)];
        priceLabel.text = @"¥25／份";
        priceLabel.font = FONTSIZE3;
        priceLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:priceLabel];
        
        marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 70, 70, 10)];
        marketPriceLabel.text = @"市场价：¥30元";
        marketPriceLabel.font = FONTSIZE5;
        marketPriceLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:marketPriceLabel];
        
        
        subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.frame = CGRectMake(mainScreenWidth-152, BTN_HEIGHT, 25, 25);
        [subBtn setImage:[UIImage imageNamed:@"cart_cut"] forState:UIControlStateNormal];
        [subBtn setImage:[UIImage imageNamed:@"cart_cutafter"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:subBtn];
//        subBtn.backgroundColor = [UIColor redColor];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(mainScreenWidth-110, BTN_HEIGHT, 25, 25);
        [addBtn setImage:[UIImage imageNamed:@"cart_add"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"cart_addafter"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:addBtn];
//        addBtn.backgroundColor = [UIColor redColor];
        
        numberLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-129, BTN_HEIGHT, 20, 25)];
        numberLab.text = @"10";
        numberLab.font = FONTSIZE2;
        numberLab.textAlignment = 1;
        numberLab.textColor = [UIColor orangeColor];
        [self.contentView addSubview:numberLab];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}
-(void)setModel:(GoodModel *)model{
    
    self.titleLabel.text = model.goodName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@/份",model.goodPrice];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.goodPicUrl] placeholderImage:[UIImage imageNamed:@"ios占位图5_购物车.png"]];
    if ([model.goodNumber intValue]>0) {
        self.numberLab.text = model.goodNumber;
    }else{
        self.numberLab.text = @"1";
    }
    
    if ([self isBlankString:model.marketPrice] || [model.marketPrice isEqualToString:@"0"]) {
        self.marketPriceLabel.text = [NSString stringWithFormat:@"暂无市场价"];
    }else{
        self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价:¥%@",model.marketPrice];
    }
    if ([model.goodPrice isEqualToString:@"0"]) {
        addBtn.enabled = NO;
        subBtn.enabled = NO;
        shopingCartBtn.enabled = NO;
    }
    
//    NSLog(@"%d",[[AppUtils shareAppUtils] getgo])
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
