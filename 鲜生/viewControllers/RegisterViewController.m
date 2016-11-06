//
//  RegisterViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterAgreementViewController.h"
#import "AppUtils.h"
#import "FMNetWorkManager.h"
#import "RegisterSeccussViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate>{
    UIButton *selectBtn;
    UIButton *sendNumberBtn;
}

@end

@implementation RegisterViewController
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3000) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:NO];
            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
                [self.delegate UIViewControllerBack:self];
            }
        }else{
            [self.navigationController popViewControllerAnimated:NO];
            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
                [self.delegate UIViewControllerBack:self];
            }
            [self backToRootViewControllerWithType:INDEX_HOME];

            
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMark = YES;
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewPress)];
    
    [self.view addGestureRecognizer:oneTap];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
//
//    self.showView1.backgroundColor = [UIColor clearColor];
//    self.showView1.layer.borderWidth = 1;
//    self.showView1.layer.borderColor = UIColorFromRGB(0xAFC875).CGColor;
//    
//    self.showView2.backgroundColor = [UIColor clearColor];
//    self.showView2.layer.borderWidth = 1;
//    self.showView2.layer.borderColor = UIColorFromRGB(0xAFC875).CGColor;
//    
//    self.showView3.backgroundColor = [UIColor clearColor];
//    self.showView3.layer.borderWidth = 1;
//    self.showView3.layer.borderColor = UIColorFromRGB(0xAFC875).CGColor;
//    
//    self.showView4.backgroundColor = [UIColor clearColor];
//    self.showView4.layer.borderWidth = 1;
//    self.showView4.layer.borderColor = UIColorFromRGB(0xAFC875).CGColor;
//    
//    self.validateBtn.backgroundColor = UIColorFromRGB(0xAFC875);
//    [self.validateBtn addTarget:self action:@selector(validateBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.registerBtn addTarget:self action:@selector(registerBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.agreeBtn addTarget:self action:@selector(agreeBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    
//    UITapGestureRecognizer* serviceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goServiceView)];
//    [self.serviceLabel addGestureRecognizer:serviceTap];
//
//    self.telephoneTextField.delegate = self;
//    self.validateTextField.delegate = self;
//    self.passwordTextField.delegate = self;
//    self.inviteTextField.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(25, 80, 200, 15)];
    lab.text = @"输入手机号,获取验证码";
    lab.font = FONTSIZE4;
    lab.textColor = [UIColor grayColor];
    [self.view addSubview:lab];
    NSArray *nameArray = @[@"输入手机号",@"输入验证码",@"设置密码",@"重新输入密码",@"输入邀请码，无邀请码可不填写"];
    for (int i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25, 100 + i*45, mainScreenWidth-50, 35)];
        view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        view.layer.shadowOffset = CGSizeMake(3,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        view.layer.shadowRadius = 3;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, mainScreenWidth-70, 35)];
        tf.placeholder = nameArray[i];
        tf.delegate = self;
        tf.tag = 1000+i;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.font = [UIFont systemFontOfSize:15];
        [view addSubview:tf];
        if (i == 3 || i == 2) {
            tf.keyboardType = UIKeyboardTypeDefault;
            tf.secureTextEntry = YES;
        }
        if (i == 4) {
            view.frame = CGRectMake(25, 100+i*45+20, mainScreenWidth-50, 35);
        }
        if (i == 0) {
            tf.frame = CGRectMake(10, 0, mainScreenWidth-70-100, 35);
            sendNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendNumberBtn.frame = CGRectMake(CGRectGetWidth(view.frame)-100, 0, 100, 35);
            sendNumberBtn.titleLabel.textColor = [UIColor whiteColor];
            [sendNumberBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [sendNumberBtn setBackgroundColor:[UIColor orangeColor]];
            sendNumberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [sendNumberBtn addTarget:self action:@selector(validateBtnPress) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:sendNumberBtn];
        }
        
    }
    UILabel *sureNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(45, 275, 200, 15)];
    sureNumberLab.text = @"请确保两次输入一致";
    sureNumberLab.font = FONTSIZE4;
    sureNumberLab.textColor = [UIColor grayColor];
    [self.view addSubview:sureNumberLab];
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(25, 345, 35, 35);
    [selectBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(agreeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    UILabel *sureTextLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 350, 200, 25)];
    sureTextLab.font = FONTSIZE3;
    sureTextLab.text = @"阅读并同意服务条款";
    sureTextLab.textColor = [UIColor orangeColor];
    [self.view addSubview:sureTextLab];
    sureTextLab.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer* serviceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goServiceView)];
    [sureTextLab addGestureRecognizer:serviceTap];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(25, 390, mainScreenWidth-50, 40);
    sureBtn.titleLabel.textColor = [UIColor whiteColor];
    sureBtn.titleLabel.font = FONTSIZE2_BOLD;
    [sureBtn setBackgroundColor:[UIColor orangeColor]];
    [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(registerBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    sureBtn.layer.cornerRadius = 5;
    
    
}

-(void)selfViewPress{
//    if ([self.telephoneTextField isFirstResponder]) {
//        [self.telephoneTextField resignFirstResponder];
//    }
//    if ([self.validateTextField isFirstResponder]) {
//        [self.validateTextField resignFirstResponder];
//    }
//    if ([self.inviteTextField isFirstResponder]) {
//        [self.inviteTextField resignFirstResponder];
//    }
    for (int i = 0; i < 5; i++) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:1000+i];
        [tf resignFirstResponder];
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
    UITextField *tf = (UITextField *)[self.view viewWithTag:1000];
    if (![self isTelephone:tf.text]) {
        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
        [tf becomeFirstResponder];
        return;
    }
    
    

    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/signVerify" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:tf.text,@"phone", nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            sendNumberBtn.enabled = NO;
//            self.validateBtn.backgroundColor = [UIColor grayColor];
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
    
    [sendNumberBtn setTitle:[NSString stringWithFormat:@"等待(%ld)",(long)60-timeCount] forState:UIControlStateNormal];
    timeCount ++;
    NSLog(@"time = %d",timeCount);
    if (timeCount  == 60) {
        
        [timer invalidate];
        timer = nil;
        timeCount = 0;
        sendNumberBtn.enabled = YES;
//        self.validateBtn.backgroundColor = UIColorFromRGB(0x8FB334);
        [sendNumberBtn setTitle:@"短信验证" forState:UIControlStateNormal];
    }
    else{
    
        sendNumberBtn.enabled = NO;
    }
}

//去注册
-(void)registerBtnPress{
    
    
//    if (self.telephoneTextField.text.length == 0) {
//    if (![self isTelephone:self.telephoneTextField.text]) {
//        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
//        [self.telephoneTextField becomeFirstResponder];
//        return;
//    }else{
//        if (![[AppUtils shareAppUtils] validateMobile:self.telephoneTextField.text]) {
//            [[AppUtils shareAppUtils] showAlert:@"请输入正确的手机号码！"];
//            [self.telephoneTextField becomeFirstResponder];
//            return;
//        }
//    }
//    
//    if (self.validateTextField.text.length == 0) {
//        [[AppUtils shareAppUtils] showAlert:@"验证码不能为空！"];
//        [self.validateTextField becomeFirstResponder];
//        return;
//    }
//    
//    if (self.passwordTextField.text.length == 0) {
//        [[AppUtils shareAppUtils] showAlert:@"用户密码不能为空！"];
//        [self.passwordTextField becomeFirstResponder];
//        return;
//    }
//    if (self.inviteTextField.text.length < 1) {
//        self.inviteTextField.text = @"";
//    }
//    if (!isMark) {
//        [[AppUtils shareAppUtils] showAlert:@"请先同意服务条款！"];
//        return;
//    }
    UITextField *tf0 = (UITextField *)[self.view viewWithTag:1000];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:1001];
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:1002];
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:1003];
    UITextField *tf4 = (UITextField *)[self.view viewWithTag:1004];
    
    
//    RegisterSeccussViewController *rvc = [[RegisterSeccussViewController alloc] init];
//    if ([self isTelephone:tf4.text]) {
//        rvc.is_invite = @"1";
//    }
//    rvc.inviteNumber = tf0.text;
//    [self.navigationController pushViewController:rvc animated:YES];
//    return;
    

    if (![self isTelephone:tf0.text]) {
        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
        [tf0 becomeFirstResponder];
        return;
    }else{
        if (![[AppUtils shareAppUtils] validateMobile:tf0.text]) {
            [[AppUtils shareAppUtils] showAlert:@"请输入正确的手机号码！"];
            [tf0 becomeFirstResponder];
            return;
        }
    }
    
    if (tf1.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"验证码不能为空！"];
        [tf1 becomeFirstResponder];
        return;
    }
    
    if (tf2.text.length == 0) {
        [[AppUtils shareAppUtils] showAlert:@"用户密码不能为空！"];
        [tf2 becomeFirstResponder];
        return;
    }
    if (tf4.text.length < 1) {
        tf4.text = @"";
    }
    
    
    if (![tf3.text isEqualToString:tf2.text]) {
        [[AppUtils shareAppUtils] showAlert:@"两次密码不一致"];
        return;
    }
    if (isMark) {
        [[AppUtils shareAppUtils] showAlert:@"请先同意服务条款！"];
        return;
    }
    
//    1、 phone   电话
//    2、 pwd     密码
//    3、 verify    验证码
    NSString *passWord = [self md5:tf2.text];
    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/signUp" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:tf4.text,@"invitation",tf0.text,@"phone",tf1.text,@"verify",passWord,@"pwd", nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            [[AppUtils shareAppUtils] saveIsLogin:YES];
            [[AppUtils shareAppUtils] saveAccount:tf0.text];
            [[AppUtils shareAppUtils] saveUserId:[responseObject objectForKey:@"token"]];
            [[AppUtils shareAppUtils] saveId:[responseObject objectForKey:@"uid"]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginStateChange" object:nil];
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", @"返回首页",nil];
            alt.tag = 3000;
            [alt show];
            RegisterSeccussViewController *rvc = [[RegisterSeccussViewController alloc] init];
            if ([self isTelephone:tf4.text]) {
                rvc.is_invite = @"1";
            }
            rvc.inviteNumber = tf0.text;
            [self.navigationController pushViewController:rvc animated:YES];
        }else{
            [self showAlt:[responseObject objectForKey:@"err_msg"]];
        }

    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
    }];
    
    return;
}


//勾选与取消勾选
-(void)agreeBtnPress{
    isMark = !isMark;
//    if (isMark) {
//        [self.agreeBtn setImage:[UIImage imageNamed:@"register_ture.png"] forState:UIControlStateNormal];
//    }else{
//        [self.agreeBtn setImage:[UIImage imageNamed:@"register_false.png"] forState:UIControlStateNormal];
//    }
    selectBtn.selected = !selectBtn.selected;
//    if (selectBtn) {
//        [selectBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateNormal];
//    }else{
//        [selectBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
//    }
    
}

//去服务条款界面
-(void)goServiceView{
    NSLog(@"去服务界面");
    RegisterAgreementViewController* registerAgreementView = [[RegisterAgreementViewController alloc] init];
    [self.navigationController pushViewController:registerAgreementView animated:YES];
}

#pragma mark ---- textFieldDelegate -----

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField == self.telephoneTextField){
//        [self.validateTextField becomeFirstResponder];
//    }
//    else if (textField == self.validateTextField){
//        [self.passwordTextField becomeFirstResponder];
//    }else if (textField == self.passwordTextField){
//        [self.inviteTextField becomeFirstResponder];
//    }else{
//        [self.inviteTextField resignFirstResponder];
//        [self registerBtnPress];
//    }
    if (textField.tag == 1000){
        [textField becomeFirstResponder];
    }
    else if (textField.tag == 1001){
        [textField becomeFirstResponder];
    }else if (textField.tag == 1004){
        [textField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self registerBtnPress];
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
