//
//  RegisterViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"

@interface RegisterViewController : MyViewController <UITextFieldDelegate>
{
    BOOL isMark;
    NSTimer* timer;
    NSInteger timeCount;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *showView1;
@property (weak, nonatomic) IBOutlet UIView *showView2;
@property (weak, nonatomic) IBOutlet UIView *showView3;
@property (weak, nonatomic) IBOutlet UIView *showView4;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateTextField;
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end
