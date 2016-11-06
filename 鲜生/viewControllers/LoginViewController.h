//
//  LoginViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "LoginModel.h"

@interface LoginViewController : MyViewController <LoginDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (retain,nonatomic)NSString* typeString;

@end
