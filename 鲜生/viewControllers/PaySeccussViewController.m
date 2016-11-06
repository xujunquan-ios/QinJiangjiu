//
//  PaySeccussViewController.m
//  FreshMan
//
//  Created by Jie on 15/11/18.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "PaySeccussViewController.h"

@interface PaySeccussViewController ()

@end

@implementation PaySeccussViewController
@synthesize orderId;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buileView];

    
    
}

-(void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)buileView{
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"下单成功";
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
        index = 10;
    }
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight+iphone4)];
    bgImageView.image = [UIImage imageNamed:@"下单成功背景图.jpg"];
    [self.view addSubview:bgImageView];
    
    UILabel *titileLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainScreenHeight*0.49+index, mainScreenWidth, 10)];
    titileLab.text = @"订单号";
    titileLab.textAlignment = 1;
    titileLab.font = FONTSIZE3;
    titileLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:titileLab];
    
    UILabel *orderNumberLab = [[UILabel alloc] initWithFrame:CGRectMake(0, mainScreenHeight*0.51+index, mainScreenWidth, 40)];
    orderNumberLab.text = orderId;
//    orderNumberLab.text = @"234234324";
    orderNumberLab.textAlignment = 1;
    orderNumberLab.font = [UIFont systemFontOfSize:26 weight:5];
    [self.view addSubview:orderNumberLab];
    
    
    
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
