//
//  ETUlityCommon.m
//  鲜生
//
//  Created by caidengshan on 10/24/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import "ETUlityCommon.h"
#import "AppUtils.h"

@implementation ETUlityCommon

/**
 安全获取字符串
 @param str 字符串
 @returns 若字符串为nil，则返回空字符串，否则直接返回字符串
 */
+(NSString*)EtstrOrEmpty:(NSString*)str{
    if ([str isKindOfClass:[NSNumber class]]){
        str = [NSString stringWithFormat:@"%@",str];
    }
	return ((str==nil||[str isEqual:[NSNull null]]||[str isEqualToString:@"(null)"])?@"":str);
}

+(CGSize)getcontnetsize:(NSString*)str font:(UIFont*)mfont constrainedtosize:(CGSize)msize linemode:(NSLineBreakMode)lineBreakMode{
    CGSize size = CGSizeZero;
    if (str == nil || str.length == 0) {
        return size;
    }
    if ([str respondsToSelector: @selector(boundingRectWithSize:options:attributes:context:)] == YES) {
        size = [str boundingRectWithSize: msize options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin
                              attributes: @{ NSFontAttributeName: mfont} context: nil].size;
    } else {
        size = [str sizeWithFont: mfont constrainedToSize: msize lineBreakMode: lineBreakMode];
    }
    return size;
}

+(CGSize)getcontnetsize:(NSString*)str font:(UIFont*)mfont{
    CGSize size = CGSizeZero;
    if (str == nil || str.length == 0) {
        return size;
    }
    if ([str respondsToSelector: @selector(sizeWithAttributes:)] == YES) {
        size = [str sizeWithAttributes:@{NSFontAttributeName: mfont}];
    } else {
        size = [str sizeWithFont:mfont];
    }
    return size;
}

@end
