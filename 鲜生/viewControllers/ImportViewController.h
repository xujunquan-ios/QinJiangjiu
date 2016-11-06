//
//  ImportViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "UIPlaceHolderTextView.h"

@interface ImportViewController : MyViewController <UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *mTextView;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showViewHeight;


@property (nonatomic,assign) BOOL isEnter;                 //可否回车
@property (nonatomic,assign) NSInteger maxCount;           //最大字数
@property (nonatomic,assign) BOOL isSingle;                //是否只显示单行
@property (nonatomic,retain) NSString* placeholder;        //提示文字
@property (nonatomic,assign) UIKeyboardType keyboardType;  //键盘风格
@property (nonatomic,retain) NSString* improtText;         //原文字
@property (nonatomic,assign) BOOL isZero;                  //可否为空
@property (nonatomic,retain) NSString *paraName;           //修改类型

@end
