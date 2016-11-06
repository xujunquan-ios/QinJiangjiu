//
//  RegisterSeccussViewController.m
//  FreshMan
//
//  Created by Jie on 15/11/18.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "RegisterSeccussViewController.h"
#import "AppUtils.h"

@interface RegisterSeccussViewController ()

@end

@implementation RegisterSeccussViewController
@synthesize is_invite,inviteNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buileView];
}

-(void)buileView{
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"注册成功";
    if ([self.is_invite isEqualToString:@"2"]) {
        titleLab.text = @"我的邀请码";
    }
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    int iphone4 = 0;
    int index = 0;
    if (mainScreenHeight == 480) {
        iphone4 = 88;
    }else if (mainScreenHeight == 568){
        index = 5;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight+iphone4)];
    bgImageView.image = [UIImage imageNamed:@"邀请码页面"];
    [self.view addSubview:bgImageView];
    
    UILabel *seccussLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainScreenHeight*0.3, mainScreenWidth, 40)];
    if ([is_invite isEqualToString:@"1"]) {
        seccussLab.text = @"绑定成功";
    }else if([is_invite isEqualToString:@"2"]){
        seccussLab.text = @"我的邀请码";
    }else{
        seccussLab.text = @"注册成功";
    }
    seccussLab.textAlignment = 1;
    seccussLab.font = [UIFont systemFontOfSize:35 weight:14];
    [self.view addSubview:seccussLab];
    
    
    UILabel *titileLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainScreenHeight*0.3+55, mainScreenWidth, 10)];
    titileLab.text = @"您的邀请码";
    titileLab.textAlignment = 1;
    titileLab.font = FONTSIZE3;
    titileLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:titileLab];
    if ([is_invite isEqualToString:@"2"]) {
        titileLab.hidden = YES;
    }


    
    UILabel *orderNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainScreenHeight*0.45+5, mainScreenWidth, 40)];
    orderNumberLab.text = inviteNumber;
    
    if ([is_invite isEqualToString:@"2"]) {
        orderNumberLab.text = [[AppUtils shareAppUtils] getAccount];
    }
    orderNumberLab.textAlignment = 1;
    orderNumberLab.font = [UIFont systemFontOfSize:26 weight:5];
    [self.view addSubview:orderNumberLab];
    
    
//    UILabel *noteLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, mainScreenHeight*0.55+5, mainScreenWidth/2-30, 40)];
//    noteLab.text = @"无邀请码可不填写";
//    noteLab.textAlignment = 2;
//    noteLab.font = FONTSIZE4;
//    [self.view addSubview:noteLab];
    
    
}
-(void)leftBtnClick{
    if ([is_invite isEqualToString:@"2"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
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
