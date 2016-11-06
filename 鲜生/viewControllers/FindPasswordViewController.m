//
//  FindPasswordViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/24.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    NSString *newPassWord;
    NSString *AgainNewPassWord;
}

@end

@implementation FindPasswordViewController
@synthesize phoneNumber;
@synthesize token;
@synthesize verify;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newPassWord = @"";
    AgainNewPassWord = @"";
    [self getView];
}
-(void)touceBackground{
    [[UIApplication sharedApplication].keyWindow endEditing:NO];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3000) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)commitData{
    
    [self touceBackground];
    newPassWord = [self md5:newPassWord];
    AgainNewPassWord = [self md5:AgainNewPassWord];

    NSLog(@"__%@__%@",newPassWord,AgainNewPassWord);
    if ([self isBlankString:newPassWord]) {
        [self showAlt:@"内容不能为空"];
        return;
    }
    NSLog(@"new|%@|%@|",newPassWord,AgainNewPassWord);
    if (![newPassWord isEqualToString:AgainNewPassWord]) {
        [self showAlt:@"两次密码不一样"];
        return;
    }else{

    }
//    newPassWord = [self md5:newPassWord];

    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/user/pwdReset" httpMethod:@"POST" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"phone",token,@"token",newPassWord ,@"pwd",verify,@"verify",  nil] success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示"
                                                           message:@"修改成功"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"确定", nil];
            alt.tag = 3000;
            [alt show];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [[AppUtils shareAppUtils] saveUserId:[responseObject objectForKey:@"token"]];
            [[AppUtils shareAppUtils] saveUserName:[responseObject objectForKey:@"name"]];
            [[AppUtils shareAppUtils] saveId:[responseObject objectForKey:@"uid"]];
            [[AppUtils shareAppUtils] saveAccount:phoneNumber];
            [[AppUtils shareAppUtils] savePassword:newPassWord];
            [[AppUtils shareAppUtils] saveIsLogin:YES];

//            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
//                [self.delegate UIViewControllerBack:self];
//            }
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)leftBtnClick:(UIButton *)button{
    switch (button.tag) {
        case 4000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 4001:
            [self commitData];
            break;
            
        default:
            break;
    }
}

#pragma mark ------textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 5000:
            newPassWord = textField.text;
            break;
        case 5001:
            AgainNewPassWord = textField.text;
            break;
//        case 5002:
//            AgainNewPassWord = textField.text;
//            break;
            
        default:
            break;
    }
}
-(void)getView{
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touceBackground)];
    [self.view addGestureRecognizer:tapGes];
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"修改密码";
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    leftBtn.tag = 4000;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(mainScreenWidth - 44, 20, 44, 44);
    rightBtn.titleLabel.font = FONTSIZE3;
    //    [rightBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    rightBtn.tag = 4001;
    
    NSArray  *titleArr = [[NSMutableArray alloc] initWithObjects:@"新密码：",@"确认密码：", nil];
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 + i*40, 70, 30)];
        lab.font = FONTSIZE3;
        lab.textAlignment = 2;
        lab.text = [titleArr objectAtIndex:i];
        [self.view addSubview:lab];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(70, 70 + 40*i, mainScreenWidth-90, 30)];
        tf.tag = 5000+i;
        tf.secureTextEntry = YES;
        [self.view addSubview:tf];
        tf.backgroundColor = [UIColor whiteColor];
        tf.delegate = self;
        
        if(i == 0){
            [tf becomeFirstResponder];
        }
        
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
