//
//  LoginViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "FMNetWorkManager.h"

@interface LoginViewController ()<UIAlertViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewPress)];
    
    [self.view addGestureRecognizer:oneTap];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.showView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.showView.layer.cornerRadius = 5;
    self.showView.layer.borderWidth = 0.5;
    self.showView.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
    
    self.shadowView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    
    self.loginBtn.backgroundColor = UIColorFromRGB(0x66C2B0);
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn addTarget:self action:@selector(loginBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registerBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.forgetBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.forgetBtn addTarget:self action:@selector(forgetBtnPress) forControlEvents:UIControlEventTouchUpInside];
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selfViewPress{
    if ([self.accountTextField isFirstResponder]) {
        [self.accountTextField resignFirstResponder];
    }
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

//去找回密码
-(void)forgetBtnPress{
    NSLog(@"去找回密码");
    ForgetViewController* forgetPasswordView = [[ForgetViewController alloc] init];
    forgetPasswordView.delegate = self;
    [self.navigationController pushViewController:forgetPasswordView animated:YES];
}

//去注册
-(void)registerBtnPress{
    NSLog(@"去注册");
    RegisterViewController* regiterView = [[RegisterViewController alloc] init];
    regiterView.delegate = self;
    [self.navigationController pushViewController:regiterView animated:YES];
}

//去登录
-(void)loginBtnPress{
    NSLog(@"去登录");
    if (self.accountTextField.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"用户名不能为空！"];
        [self.accountTextField becomeFirstResponder];
        return;
    }else{
        if (![[AppUtils shareAppUtils] validateMobile:self.accountTextField.text]) {
            [[AppUtils shareAppUtils] showAlert:@"请输入正确的用户名"];
            [self.accountTextField becomeFirstResponder];
            return;
        }
    }
    
    if (self.passwordTextField.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"密码不能为空！"];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    NSString *passWord = [self md5:self.passwordTextField.text];
    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/login" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.accountTextField.text,@"phone",passWord ,@"pwd", nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示"
                                                           message:@"登录成功"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"确定", nil];
            alt.tag = 3000;
            [alt show];
            [[AppUtils shareAppUtils] saveUserId:[responseObject objectForKey:@"token"]];
            [[AppUtils shareAppUtils] saveUserName:[responseObject objectForKey:@"name"]];
            [[AppUtils shareAppUtils] saveId:[responseObject objectForKey:@"uid"]];
            [[AppUtils shareAppUtils] saveAccount:self.accountTextField.text];
            [[AppUtils shareAppUtils] savePassword:passWord];
            [[AppUtils shareAppUtils] saveIsLogin:YES];

        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
}

#pragma mark ---- LoginDelegate -----

-(void)LoginSuccessInData:(NSString*)message{
    NSLog(@"登录成功");
    NSLog(@"%@",message);
    
    [[AppUtils shareAppUtils] saveIsLogin:YES];
    [[AppUtils shareAppUtils] saveAccount:self.accountTextField.text];
    [[AppUtils shareAppUtils] savePassword:self.passwordTextField.text];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginStateChange" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
        [self.delegate UIViewControllerBack:self];
    }
}
-(void)LoginFailInData:(NSString*)message{
     NSLog(@"登录失败，原因是:%@",message);
    [[AppUtils shareAppUtils] showHUD:message];
}

#pragma mark ---- textFieldDelegate -----

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTextField){
        [self.passwordTextField becomeFirstResponder];
    }
    else{
        [self loginBtnPress];
    }
    return YES;
}
#pragma mark ------alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3000) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark ---- MyViewControllerDelegate -----
- (void)UIViewControllerBack:(MyViewController *)myViewController{
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
        [self.delegate UIViewControllerBack:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
