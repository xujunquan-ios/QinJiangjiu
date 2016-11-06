//
//  ETUlityCommon.h
//  鲜生
//
//  Created by caidengshan on 10/24/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ETUlityCommon : NSObject


+(NSString*)EtstrOrEmpty:(NSString*)str;


+(CGSize)getcontnetsize:(NSString*)str font:(UIFont*)mfont constrainedtosize:(CGSize)msize linemode:(NSLineBreakMode)lineBreakMode;

+(CGSize)getcontnetsize:(NSString*)str font:(UIFont*)mfont;

@end
