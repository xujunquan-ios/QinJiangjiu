//
//  PersonTableViewCell.m
//  水果唐
//
//  Created by MacPro on 15-8-3.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell
@synthesize imageView,titleLabel;

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
    
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (80-24)/2, 24, 24)];
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+20, 0, mainScreenWidth-(imageView.frame.size.width+imageView.frame.origin.x+20+10), 80)];
        titleLabel.text = @"收货地址管理";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONTSIZE3;
        titleLabel.textColor = UIColorFromRGB(0x000000);
        [self.contentView addSubview:titleLabel];
        
        UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 80-1, mainScreenWidth, 1)];
        shadowView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [self.contentView addSubview:shadowView];
        
    }
    return self;
}

@end
