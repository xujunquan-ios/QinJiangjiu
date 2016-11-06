//
//  GoodsDetailModel.h
//  FreshMan
//
//  Created by Jie on 15/8/30.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailModel : NSObject
@property (nonatomic,strong) NSString *goodId;// 商品ID
@property (nonatomic,strong) NSString *goodName;//名称
@property (nonatomic,strong) NSString *goodPrice;//价格
@property (nonatomic,strong) NSString *goodUnit;//价格的单位
@property (nonatomic,strong) NSString *goodArea;//产地
@property (nonatomic,strong) NSString *goodHot;//热度
@property (nonatomic,strong) NSString *goodCal;//热量
@property (nonatomic,strong) NSString *goodPro;//蛋白质
@property (nonatomic,strong) NSString *goodFat;//脂肪
@property (nonatomic,strong) NSString *goodCho;//碳水化合物
@property (nonatomic,strong) NSString *goodNdf;//膳食纤维
@property (nonatomic,strong) NSString *goodGood;//好评数量
@property (nonatomic,strong) NSString *goodBad;//差评数量
@property (nonatomic,strong) NSString *goodFocus;//关注数
@property (nonatomic,strong) NSString *goodPicUrl;//图片
@end
