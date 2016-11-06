//
//  OrderCell.m
//  FreshMan
//
//  Created by Jie on 15/9/24.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "OrderCell.h"
#import "UIImageView+WebCache.h"


#define GAP 90
#define MAX_COUNT 10

@implementation OrderCell
@synthesize  timeLab;
//@synthesize  nameLab;
//@synthesize  addressLab;
@synthesize  totalLab;
//@synthesize  orderImageView;
@synthesize  statusLab;
@synthesize fvView;
@synthesize payBtn;
@synthesize deleteBtn;
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
        UIImageView* markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        markImageView.image = [UIImage imageNamed:@"myOrderIcon.png"];
        [self.contentView addSubview:markImageView];
        
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(markImageView.frame.size.width+markImageView.frame.origin.x+5, 0, 160, 30)];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = UIColorFromRGB(0x666666);
        timeLab.text = @"时间";
        timeLab.font = FONTSIZE3;
        [self.contentView addSubview:timeLab];
        
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-70, 0, 60, 30)];
        statusLab.textAlignment = NSTextAlignmentRight;
        statusLab.backgroundColor = [UIColor clearColor];
        statusLab.font = FONTSIZE4;
        statusLab.textColor = UIColorFromRGB(0xE4511D);
        statusLab.text = @"订货状态";
        [self.contentView addSubview:statusLab];
        
        fvView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, mainScreenWidth, 90)];
        fvView.backgroundColor = UIColorFromRGB(0xF4F4F4);
        [self.contentView addSubview:fvView];
        
        
        for (int i = 0; i < MAX_COUNT ; i++) {
            UIImageView *orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10 +GAP*i, 100, 70)];
            orderImageView.image = [UIImage imageNamed:@"测试1.png"];;
            orderImageView.tag = 100+i;
            [fvView addSubview:orderImageView];
            orderImageView.hidden = YES;
            
            UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 25 +GAP*i, mainScreenWidth-140, 20)];
            nameLab.font = FONTSIZE3;
            nameLab.tag = 200+i;
            [fvView addSubview:nameLab];
            nameLab.hidden = YES;

            
            UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 50 +GAP*i, 130, 20)];
            addressLab.font = FONTSIZE4;
            addressLab.textColor = UIColorFromRGB(0x666666);
            addressLab.tag = 300+i;
            [fvView addSubview:addressLab];
            addressLab.hidden = YES;

            
            UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-70, 40 +GAP*i, 50, 20)];
            priceLab.font = FONTSIZE4;
            priceLab.textAlignment = 2;
            priceLab.tag = 400+i;
            [fvView addSubview:priceLab];
            priceLab.hidden = YES;

            
            UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth-70, 65 +GAP*i, 50, 20)];
            numberLab.font = FONTSIZE4;
            numberLab.textAlignment = 2;
            numberLab.tag = 500+i;
            numberLab.textColor = UIColorFromRGB(0x666666);
            [fvView addSubview:numberLab];
            numberLab.hidden = YES;

            
        }
        
        
        totalLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30+90, mainScreenWidth-2*20, 30)];
        totalLab.backgroundColor = [UIColor clearColor];
        totalLab.textAlignment = NSTextAlignmentRight;
        totalLab.font = FONTSIZE4;
        totalLab.textColor = UIColorFromRGB(0x333333);
        totalLab.text = [NSString stringWithFormat:@"合计¥%@",@"120"];
        [self.contentView addSubview:totalLab];
        
        payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        payBtn.frame = CGRectMake(mainScreenWidth-100, 155, 80, 30);
        [payBtn setBackgroundColor:UIColorFromRGB(0x66c2b0)];
        payBtn.layer.cornerRadius = 7;
        [payBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [self.contentView addSubview:payBtn];
        payBtn.hidden = YES;
        payBtn.titleLabel.font = FONTSIZE3;
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        payBtn.frame = CGRectMake(mainScreenWidth-100, 155, 80, 30);
        [deleteBtn setBackgroundColor:UIColorFromRGB(0x66c2b0)];
        deleteBtn.layer.cornerRadius = 7;
        [deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.contentView addSubview:deleteBtn];
        deleteBtn.titleLabel.font = FONTSIZE3;
        
        
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return  self;
}

-(void)setModel:(OrderModel *)newModel{
    timeLab.text = newModel.time;
    statusLab.text = newModel.status;
//    nameLab.text = newModel.name;
    fvView.frame = CGRectMake(0, 30, mainScreenWidth, 90*newModel.product.count);
//    nameLab.text = [NSString stringWithFormat:@"订单号：%@",newModel.tradeId];
//    addressLab.text = newModel.address;
    totalLab.text = [NSString stringWithFormat:@"合计¥%@",newModel.total];
    totalLab.frame = CGRectMake(20, 30+newModel.product.count*90, mainScreenWidth-2*20, 30);
    
    payBtn.frame = CGRectMake(mainScreenWidth-90, 30+newModel.product.count*90 +30, 70, 20);
    deleteBtn.frame = CGRectMake(mainScreenWidth-170, 30+newModel.product.count*90 +30, 70, 20);
    payBtn.hidden = YES;
    if ([newModel.status isEqualToString:@"未付款"]) {
        payBtn.hidden = NO;
    }
    
    NSArray *arr = newModel.product;
    
    for (int i = 0; i < MAX_COUNT ; i++) {
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:100+i];
        imgView.hidden = YES;
        
        UILabel *nmLab = (UILabel *)[self.contentView viewWithTag:200+i];
        nmLab.hidden = YES;
        
        UILabel *addLab = (UILabel *)[self.contentView viewWithTag:300+i];
        addLab.hidden = YES;
        
        UILabel *priLab = (UILabel *)[self.contentView viewWithTag:400+i];
        priLab.hidden = YES;
        
        UILabel *numLab = (UILabel *)[self.contentView viewWithTag:500+i];
        numLab.hidden = YES;
    }
    
    for (int i = 0; i < arr.count ; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:100+i];
        imgView.hidden = NO;
        [imgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"ios_评价页"]];
        
        UILabel *nmLab = (UILabel *)[self.contentView viewWithTag:200+i];
        nmLab.hidden = NO;
        nmLab.text = [dic objectForKey:@"name"];

        UILabel *addLab = (UILabel *)[self.contentView viewWithTag:300+i];
        addLab.hidden = NO;
        addLab.text = [dic objectForKey:@"name"];

        UILabel *priLab = (UILabel *)[self.contentView viewWithTag:400+i];
        priLab.hidden = NO;
        NSString *priStr = [dic objectForKey:@"price"];
        priLab.text = [NSString stringWithFormat:@"￥%@",priStr];

        UILabel *numLab = (UILabel *)[self.contentView viewWithTag:500+i];
        numLab.hidden = NO;
        NSString *numStr = [dic objectForKey:@"amount"];
        numLab.text = [NSString stringWithFormat:@"X %@",numStr];
    }
    
    
}

-(void)getGoodView{

}
@end
