//
//  ChangePassWordViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ChangePassWordViewController.h"

@interface ChangePassWordViewController ()<UITextFieldDelegate>{

    NSString *oldPassWord;
    NSString *newPassWord;
    NSString *AgainNewPassWord;
    
}

@end

@implementation ChangePassWordViewController
@synthesize improtText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    oldPassWord = @"";
    newPassWord = @"";
    AgainNewPassWord = @"";
    [self getView];
}
-(void)showAlt:(NSString *)message{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alt show];
}
-(void)commitData{
    [self touceBackground];
    NSLog(@"%@__%@__%@",oldPassWord,newPassWord,AgainNewPassWord);
    if ([self isBlankString:oldPassWord] ||[self isBlankString:newPassWord]) {
        [self showAlt:@"内容不能为空"];
        return;
    }
    NSLog(@"new|%@|%@|",newPassWord,AgainNewPassWord);
    if ([newPassWord isEqualToString:AgainNewPassWord]) {
    }else{
        [self showAlt:@"两次密码不一样"];
        return;
    }
    NSError *error;
    oldPassWord = [self md5:oldPassWord];
    newPassWord = [self md5:newPassWord];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:oldPassWord, @"pwd", newPassWord, @"newpwd", [[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:SAVE_USERINFO httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
                [self.delegate UIViewControllerBack:self];
            }
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
            return ;
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
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
-(void)touceBackground{
    [[UIApplication sharedApplication].keyWindow endEditing:NO];
    
}
#pragma mark ------textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 5000:
            oldPassWord = textField.text;
            break;
        case 5001:
            newPassWord = textField.text;
            break;
        case 5002:
            AgainNewPassWord = textField.text;
            break;
            
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
    titleLab.textAlignment = 1;
    
    
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
    
    NSArray  *titleArr = [[NSMutableArray alloc] initWithObjects:@"旧密码：",@"新密码：",@"确认密码：", nil];
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 70 + i*40, 70, 30)];
        lab.font = FONTSIZE3;
        lab.textAlignment = 2;
        lab.text = [titleArr objectAtIndex:i];
        [self.view addSubview:lab];
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(70, 70 + 40*i, mainScreenWidth-90, 30)];
        tf.tag = 5000+i;
        [self.view addSubview:tf];
        tf.backgroundColor = [UIColor whiteColor];
        tf.delegate = self;
        tf.secureTextEntry = YES;
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
