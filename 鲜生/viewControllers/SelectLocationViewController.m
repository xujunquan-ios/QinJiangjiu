//
//  SelectLocationViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/9.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "SelectLocationViewController.h"

@interface SelectLocationViewController ()

@end

@implementation SelectLocationViewController
-(void)buildView{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight-44, mainScreenWidth, 44)];
    //    barView.backgroundColor = UIColorFromRGB(0xffffff);
    barView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:barView];
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2-30, 12, 50, 20)];
    totalLab.text = @"合计:  ¥";
    totalLab.font = FONTSIZE3;
    [barView addSubview:totalLab];
    //    totalLab.backgroundColor = [UIColor redColor];
    UILabel *totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2+20, 12, 50, 20)];
    totalPriceLab.text = @"158.29";
    totalPriceLab.font = FONTSIZE3;
    totalPriceLab.textColor = [UIColor orangeColor];
    [barView addSubview:totalPriceLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = UIColorFromRGB(0xee751b);
    [buyBtn setTitle:@"结算" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FONTSIZE3;
    buyBtn.frame = CGRectMake(mainScreenWidth/2+100, 0, mainScreenWidth/2-100, 44);
    [barView addSubview:buyBtn];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildView];
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
