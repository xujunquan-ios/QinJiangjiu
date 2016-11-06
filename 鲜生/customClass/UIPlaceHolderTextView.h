//
//  UIPlaceHolderTextView.h
//
//  Created by liu.wei on 3/14/14.
//  Copyright (c) 2014 王 苏诚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}


@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;


-(void)textChanged:(NSNotification*)notification;


@end
