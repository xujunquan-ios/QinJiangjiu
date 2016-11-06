//
//  AreaCell.m
//  FreshMan
//
//  Created by Jie on 15/11/16.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "AreaCell.h"

@implementation AreaCell
@synthesize titleLab;
@synthesize distanceLab;
@synthesize locationBtn;
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
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, mainScreenWidth-90-60, 50)];
        titleLab.numberOfLines = 0;
        titleLab.font = FONTSIZE2;
        [self.contentView addSubview:titleLab];
        
        locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainScreenWidth-90-45, 5, 30, 30)];
        [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [self.contentView addSubview:locationBtn];
        
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth-90-45, 5, 30, 30)];
//        imgView.image = [UIImage imageNamed:@"location"];
//        [self.contentView addSubview:imgView];
        
        distanceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-90-60, 40, 60, 10)];
        distanceLab.text = @"距离您:99.9KM";
        distanceLab.font = FONTSIZE6;
        distanceLab.textAlignment = 1;
        [self.contentView addSubview:distanceLab];
        
        
    }
    return self;
}

//显示具体的内容，titleLabel表示的列表的名称
-(void)setModel:(AnnotationModel *)newModel{
//    NSLog(@"dis = %@",newModel.distance);
    titleLab.text = newModel.name;
    NSLog(@"titleLab的内容:%@",newModel.name);
    if ([newModel.distance isEqualToString:@"-1"]) {
        distanceLab.text = @"距离大于100KM";
    }else if([newModel.distance isEqualToString:@"-2"]){
        distanceLab.text = @"获取位置失败";
    }else{
        distanceLab.text = newModel.distance;
    }
    
    
}
@end
