//
//  ForgetViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ForgetViewController.h"
#import "AppUtils.h"
#import "FindPasswordViewController.h"

#import "MBProgressHUD.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewPress)];
    
    [self.view addGestureRecognizer:oneTap];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.showView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.showView.layer.cornerRadius = 5;
    self.showView.layer.borderWidth = 0.5;
    self.showView.layer.borderColor = UIColorFromRGB(0xE5E5E5).CGColor;
    
    self.shadowView.backgroundColor = UIColorFromRGB(0xE5E5E5);
    
    self.validateBtn.layer.cornerRadius = self.validateBtn.frame.size.height/2;
    [self.validateBtn addTarget:self action:@selector(validateBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgetBtn.backgroundColor = UIColorFromRGB(0xE4521C);
    
    self.accountTextField.delegate = self;
    self.validateTextField.delegate = self;
    [self.forgetBtn addTarget:self action:@selector(forgetBtnPress) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}

-(void)selfViewPress{
    if ([self.accountTextField isFirstResponder]) {
        [self.accountTextField resignFirstResponder];
    }
    
    if ([self.validateTextField isFirstResponder]) {
        [self.validateTextField resignFirstResponder];
    }
}

-(void)leftBtnPress{
    [timer invalidate];
    timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//发送验证
-(void)validateBtnPress{
    NSLog(@"去发送验证");
    if (![self isTelephone:self.accountTextField.text]) {
        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
        [self.accountTextField becomeFirstResponder];
        return;
    }
//    self.validateBtn.enabled = NO;
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerValue) userInfo:nil repeats:YES];
//    [self timerValue];
    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/pwdRecover" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.accountTextField.text,@"phone", nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            self.validateBtn.enabled = NO;
            self.validateBtn.backgroundColor = [UIColor grayColor];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerValue) userInfo:nil repeats:YES];
            [self timerValue];
        }else{
            [self showAlt:[responseObject objectForKey:@"err_msg"]];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
    }];
}

//进行计算时间
-(void)timerValue{
    
    [self.validateBtn setTitle:[NSString stringWithFormat:@"等待(%ld)",(long)60-timeCount] forState:UIControlStateNormal];
    timeCount ++;
    if (timeCount  == 60) {
        [timer invalidate];
        timer = nil;
        timeCount = 0;
        self.validateBtn.enabled = YES;
        [self.validateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

//去找回密码
-(void)forgetBtnPress{
    NSLog(@"去找回密码");
    if (self.accountTextField.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"手机号码不能为空！"];
        [self.accountTextField becomeFirstResponder];
        return;
    }else{
        if (![[AppUtils shareAppUtils] validateMobile:self.accountTextField.text]) {
            [[AppUtils shareAppUtils] showAlert:@"请输入正确的手机号码！"];
            [self.accountTextField becomeFirstResponder];
            return;
        }
    }
    if (![self isTelephone:self.accountTextField.text]) {
        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
        [self.accountTextField becomeFirstResponder];
        return;
    }
    if (self.validateTextField.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"验证码不能为空！"];
        [self.validateTextField becomeFirstResponder];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"----|%@|%@|",self.accountTextField.text,self.validateTextField.text);
    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/pwdVerify" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:self.accountTextField.text,@"phone",self.validateTextField.text,@"verify", nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            FindPasswordViewController *fvc = [[FindPasswordViewController alloc] init];
            fvc.phoneNumber = self.accountTextField.text;
            fvc.verify = self.validateTextField.text;
            fvc.token = [responseObject objectForKey:@"token"];
            [self.navigationController pushViewController:fvc animated:YES];
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
//        FindPasswordViewController *fvc = [[FindPasswordViewController alloc] init];
//        fvc.phoneNumber = self.accountTextField.text;
//        fvc.verify = self.validateTextField.text;
//        fvc.token = [responseObject objectForKey:@"token"];
//        [self.navigationController pushViewController:fvc animated:YES];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
    }];
//    SettingPasswordViewController* settingPasswordView = [[SettingPasswordViewController alloc] init];
//    settingPasswordView.passwordType = repleaceOtherPassword;
//    settingPasswordView.delegate = self;
//    [self.navigationController pushViewController:settingPasswordView animated:YES];
}

#pragma mark ---- textFieldDelegate -----

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTextField){
        [self.validateTextField becomeFirstResponder];
    }
    else{
        [self forgetBtnPress];
    }
    return YES;
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
