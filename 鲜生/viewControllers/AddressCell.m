//
//  AddressCell.m
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell
@synthesize nameLabel,addressLabel,phoneLabel,selectBtn;
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
        self.backgroundColor = UIColorFromRGB(0xF8F8F8);
        

        nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        nameLabel.text = @"姓名";
        nameLabel.font = FONTSIZE2;
        nameLabel.textAlignment = 0;
        [self.contentView addSubview:nameLabel];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, mainScreenWidth-80, 20)];
        addressLabel.text = @"地址第一地址第一地址第一地址第一地址第一";
        addressLabel.font = FONTSIZE3;
        addressLabel.textAlignment = 0;
        [self.contentView addSubview:addressLabel];
        
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2-20, 10, 120, 30)];
        phoneLabel.textAlignment = 0;
        phoneLabel.font = FONTSIZE2;
        phoneLabel.text = @"13811111111";
        [self.contentView addSubview:phoneLabel];
        
        selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(mainScreenWidth-80, 0, 80, 70);
//        [selectBtn setImage:[UIImage imageNamed:@"register_false"] forState:UIControlStateNormal];
//        [selectBtn setImage:[UIImage imageNamed:@"register_ture"] forState:UIControlStateSelected];
        [selectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:selectBtn];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}


@end
