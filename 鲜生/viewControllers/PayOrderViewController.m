//
//  PayOrderViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/15.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PayOrderCell.h"
#import "MBProgressHUD.h"
#import "FMNetWorkManager.h"
#import "AlipaySDK/AlipaySDK.h"
#import "GoodModel.h"
#import "LoginViewController.h"
#import "AddressListViewController.h"
#import "AddressModel.h"
#import "MyLocationViewController.h"
#import "PaySeccussViewController.h"
#import "MyLocationListViewController.h"

@interface PayOrderViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,LoginDelegate,AddressListDelegate,UIScrollViewDelegate>{
    UILabel *totalPriceLab;
    MBProgressHUD *hud;
    UITableView *goodTableView;
    NSString *orderID;
//    AddressModel *model;
    UILabel *ziqudianLab;
    
    UILabel *addressNameLab;
    UILabel *addressDetailLab;
    
    UILabel *sendFeeLab;
    UILabel *goodTotolFeeLab;
    int sendFee;
    int send_time;
    
    UIView *tihuodianView;
    UIView *itemView2;
    UIButton *locationBtn1;
    UILabel *ziqudianLineLab;
    
    UIScrollView *scrollView;
}

@end

@implementation PayOrderViewController
@synthesize orderArray,totalPrice,dataArray;
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touceBackground{
    [[UIApplication sharedApplication].keyWindow endEditing:NO];

}
//-(void)newAddressModel:(AddressModel *)newModel{
//    UITextField *field1 = (UITextField *)[self.view viewWithTag:1000];
//    UITextField *field2 = (UITextField *)[self.view viewWithTag:1001];
//    UITextField *field3 = (UITextField *)[self.view viewWithTag:1002];
//    field1.text = newModel.address;
//    field2.text = newModel.name;
//    field3.text = newModel.phone;
//}
-(void)selectAddress:(AddressModel *)model{
    UITextField *field1 = (UITextField *)[self.view viewWithTag:1000];
    UITextField *field2 = (UITextField *)[self.view viewWithTag:1001];
//    UITextField *field3 = (UITextField *)[self.view viewWithTag:1002];
    field1.text = model.name;
    field2.text = model.phone;
//    field3.text = model.phone;
}

//跳转地址列表视图
-(void)getAddress{
    AddressListViewController *avc = [[AddressListViewController alloc] init];
    avc.fathType = @"3";
    avc.addressDelegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}
-(void)addressPush:(NSNotification *)notification
{
    //拿到通知内容。
    NSLog(@"run here");
    NSDictionary *dic = [notification userInfo];
    AddressModel *model = [dic objectForKey:@"address"];
    [self selectAddress:model];

}
-(void)buttonClick:(UIButton *)button{
    //02表示自取点，03表示送货上门，04表示选择自取点，05表示点击定位按钮，06表示微信支付，07表示支付宝支付，00表示结算
    UIButton *ziti = (UIButton *)[self.view viewWithTag:2002];
    UIButton *tihuo = (UIButton *)[self.view viewWithTag:2003];
    UIButton *songhuoTitle = (UIButton *)[self.view viewWithTag:2004];
    UIButton *locationBtn = (UIButton *)[self.view viewWithTag:2005];
    UIButton *wechat = (UIButton *)[self.view viewWithTag:2006];
    UIButton *alipay = (UIButton *)[self.view viewWithTag:2007];
    UIButton *am = (UIButton *)[self.view viewWithTag:2008];
    UIButton *pm = (UIButton *)[self.view viewWithTag:2009];
    AddressModel *sendAd = [[AppUtils shareAppUtils] getDefaultAddress];
    AnnotationModel *getPt = [[AppUtils shareAppUtils] getAddress];
    
    
    switch (button.tag) {
        case 2000:
//            [self goPay:orderID];
            [self getData];
            break;
        case 2001:
            [self getAddress];
            break;
        case 2002:
            NSLog(@"2002");
            
            //修改视图位置
            tihuodianView.frame = CGRectMake(0, 224, mainScreenWidth, 30);
            itemView2.frame = CGRectMake(0, 164, mainScreenWidth, 20);
            addressNameLab.frame = CGRectMake(30, 190, 200, 10);
            addressDetailLab.frame = CGRectMake(30, 200, 200, 20);
            locationBtn1.frame = CGRectMake(mainScreenWidth - 60, 190, 30, 30);
            ziqudianLineLab.frame = CGRectMake(0, 90, mainScreenWidth, 0.5);
            
            //运送费用
            sendFeeLab.text = [NSString stringWithFormat:@"¥0.00"];
            double fe = [[goodTotolFeeLab.text substringFromIndex:1] doubleValue];
            totalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",fe];

            
            button.selected = YES;
            tihuo.selected = NO;
            [songhuoTitle setTitle:@"选择自取点(自取点无额外费用)" forState:UIControlStateNormal];
            [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];

            addressNameLab.text = getPt.name;
            addressDetailLab.text = getPt.address;
            sendFee = 0;
            break;
        case 2003:
            NSLog(@"2003");
            
            //修改视图位置
            tihuodianView.frame = CGRectMake(0, 164, mainScreenWidth, 30);
            itemView2.frame = CGRectMake(0, 194, mainScreenWidth, 20);
            addressNameLab.frame = CGRectMake(30, 220, 200, 10);
            addressDetailLab.frame = CGRectMake(30, 230, 200, 20);
            locationBtn1.frame = CGRectMake(mainScreenWidth - 60, 220, 30, 30);
            ziqudianLineLab.frame = CGRectMake(0, 29, mainScreenWidth, 0.5);
            
            sendFeeLab.text = [NSString stringWithFormat:@"¥5.00"];
            double fe2 = [[goodTotolFeeLab.text substringFromIndex:1] doubleValue];
            totalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",fe2+5];
            //    locationBtn.backgroundColor = [UIColor redColor];
            [locationBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];

            button.selected = YES;
            ziti.selected = NO;
            [songhuoTitle setTitle:@"送货地址" forState:UIControlStateNormal];
            addressNameLab.text = sendAd.name;
            addressDetailLab.text = sendAd.address;
            sendFee = 5;
            break;
        case 2005:
            NSLog(@"2005");
            if (ziti.selected) {
                [self goSelectGetPoint];
            }else{
                [self getAddress];
            }
            
            break;
        case 2006:
            NSLog(@"2006");
            button.selected = YES;
            alipay.selected = NO;
            
            break;
        case 2007:
            NSLog(@"2007");
            button.selected = YES;
            wechat.selected = NO;
            break;
            
        case 2008:
            NSLog(@"2008");
            send_time = 0;
            button.selected = YES;
            pm.selected = NO;
            break;
            
        case 2009:
            NSLog(@"2009");
            send_time = 1;
            button.selected = YES;
            am.selected = NO;
            
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIButton *ziti = (UIButton *)[self.view viewWithTag:2002];
    UIButton *tihuo = (UIButton *)[self.view viewWithTag:2003];

    AddressModel *model2  = [[AppUtils shareAppUtils] getDefaultAddress];
    [self selectAddress:model2];
    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
    if ([self isBlankString:model.name]) {
        ziqudianLab.text = [NSString stringWithFormat:@"可到自取点取货，查看详细的自取点信息"];
    }else{
        ziqudianLab.text = [NSString stringWithFormat:@"您的自取点为:%@",model.name];
    }
    if (ziti.selected) {
        [self buttonClick:ziti];
    }else{
        [self buttonClick:tihuo];
    }

    
}

//选取定位
-(void)goSelectGetPoint{
    
    MyLocationListViewController *mLLVC = [[MyLocationListViewController alloc] init];
    [self.navigationController pushViewController:mLLVC animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hud = [[MBProgressHUD alloc] init];
//    orderArray = (NSMutableArray *)orderArray;
//    dataArray = (NSMutableArray *)dataArray;
//    [self getData];
    sendFee = 0;
    send_time = 0;
    
    NSLog(@"totalPrice=%@",totalPrice);
    NSLog(@"dataArray=%@",dataArray);
    NSLog(@"orderArray=%@",orderArray); 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressPush:) name:@"addressPush" object:nil];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -18, mainScreenWidth, mainScreenHeight+24)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(mainScreenWidth, 726);
    scrollView.scrollEnabled = YES;
    
    [self.view addSubview:scrollView];
    
    //导航视图
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"确认订单";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = 1;
    [navBarView addSubview:titleLab];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touceBackground)];
    [scrollView addGestureRecognizer:tapGes];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    //时间选择视图
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 20)];
    timeView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:timeView];
    
    UIButton *timeTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeTitleBtn.titleLabel.font = FONTSIZE5;
    [timeTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [timeTitleBtn setImage:[UIImage imageNamed:@"order_time"] forState:UIControlStateNormal];
    [timeTitleBtn setTitle:@"时间段选择" forState:UIControlStateNormal];
    timeTitleBtn.frame = CGRectMake(15, 0, 110, 20);
    [timeView addSubview:timeTitleBtn];
    timeTitleBtn.enabled = NO;
    timeTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    timeTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    
    //上午视图
    UIView *amView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, mainScreenWidth, 30)];
    amView.backgroundColor = UIColorFromRGB(0xfffdf6);
    [scrollView addSubview:amView];
    
    UIButton *amBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    amBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [amBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [amBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [amBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [amBtn setTitle:[NSString stringWithFormat:@"上午(11点后)"] forState:UIControlStateNormal];
    amBtn.frame = CGRectMake(15, 0, 150, 30);
    amBtn.tag = 2008;
    [amView addSubview:amBtn];
    amBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    amBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    amBtn.selected = YES;
    [amBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //下午按钮
    UIButton *pmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [pmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pmBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [pmBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [pmBtn setTitle:[NSString stringWithFormat:@"下午(17点后)"] forState:UIControlStateNormal];
    pmBtn.frame = CGRectMake(mainScreenWidth/2 - 15, 0, 150, 30);
    pmBtn.tag = 2009;
    [amView addSubview:pmBtn];
    pmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    pmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    pmBtn.selected = NO;
    [pmBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //配送方式选择视图
    UIView *itemView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 114, mainScreenWidth, 20)];
    itemView1.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:itemView1];
    
    UIButton *titleBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    titleBtn1.titleLabel.textColor = [UIColor blackColor];
    titleBtn1.titleLabel.font = FONTSIZE5;
    [titleBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn1 setImage:[UIImage imageNamed:@"order_send"] forState:UIControlStateNormal];
    [titleBtn1 setTitle:@"配送方式选择" forState:UIControlStateNormal];
    titleBtn1.frame = CGRectMake(15, 0, 110, 20);
    [itemView1 addSubview:titleBtn1];
    titleBtn1.enabled = NO;
    titleBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
//    titleBtn1.backgroundColor = [UIColor redColor];
    
    //自取点视图
    UIView *ziqudianView = [[UIView alloc] initWithFrame:CGRectMake(0, 134, mainScreenWidth, 30)];
    ziqudianView.backgroundColor = UIColorFromRGB(0xfffdf6);
    [scrollView addSubview:ziqudianView];
    
    UIButton *ziqudianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ziqudianBtn.titleLabel.font = FONTSIZE3;
    [ziqudianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ziqudianBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [ziqudianBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [ziqudianBtn setTitle:@"自取点提货" forState:UIControlStateNormal];
    ziqudianBtn.frame = CGRectMake(15, 0, 110, 30);
    ziqudianBtn.tag = 2002;
    [ziqudianView addSubview:ziqudianBtn];
    ziqudianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    ziqudianBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    ziqudianBtn.selected = YES;
    [ziqudianBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    ziqudianLineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, mainScreenWidth, 0.5)];
    [ziqudianView addSubview:ziqudianLineLab];
    ziqudianLineLab.backgroundColor = [UIColor lightGrayColor];
    
    //送货上门视图
    tihuodianView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, mainScreenWidth, 30)];
//    tihuodianView.backgroundColor = UIColorFromRGB(0xfffdf6);
    [scrollView addSubview:tihuodianView];
    
    UIButton *tihuodianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tihuodianBtn.titleLabel.font = FONTSIZE3;
    [tihuodianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tihuodianBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [tihuodianBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [tihuodianBtn setTitle:@"送货上门" forState:UIControlStateNormal];
    tihuodianBtn.frame = CGRectMake(15, 0, 100, 30);
    tihuodianBtn.tag = 2003;
    tihuodianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tihuodianBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [tihuodianBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tihuodianView addSubview:tihuodianBtn];
    if ([totalPrice isEqualToString:@"0.01"]) {
        tihuodianBtn.enabled = NO;
    }
    
    //选择自取点视图
    itemView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 164, mainScreenWidth, 20)];
    itemView2.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:itemView2];
    
    UIButton *titleBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn2.titleLabel.font = FONTSIZE5;
    [titleBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn2 setImage:[UIImage imageNamed:@"order_address"] forState:UIControlStateNormal];
    [titleBtn2 setTitle:@"选择自取点(自取点无额外费用)" forState:UIControlStateNormal];
    titleBtn2.frame = CGRectMake(15, 0, 220, 20);
    [itemView2 addSubview:titleBtn2];
    titleBtn2.enabled = NO;
    titleBtn2.tag = 2004;
    titleBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    
    
    //地址label
    AnnotationModel *getPt = [[AppUtils shareAppUtils] getAddress];

    addressNameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 190, 200, 10)];
    addressNameLab.font = FONTSIZE5;
    addressNameLab.text = getPt.name;
    addressNameLab.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:addressNameLab];
    
    //详细地址label
    addressDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, mainScreenWidth - 30, 20)];
    addressDetailLab.font = FONTSIZE3;
    addressDetailLab.text = getPt.address;
    [scrollView addSubview:addressDetailLab];
    
    
    //定位视图
    locationBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn1.frame = CGRectMake(mainScreenWidth-60, 190, 30, 30);
//    locationBtn.backgroundColor = [UIColor redColor];
    [locationBtn1 setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locationBtn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:locationBtn1];
    locationBtn1.tag = 2005;
    
    //支付方式视图
    UIView *itemView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 255, mainScreenWidth, 20)];
    itemView3.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:itemView3];
    
    UIButton *titleBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn3.titleLabel.font = FONTSIZE5;
    [titleBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn3 setImage:[UIImage imageNamed:@"order_pay"] forState:UIControlStateNormal];
    [titleBtn3 setTitle:@"支付方式" forState:UIControlStateNormal];
    titleBtn3.frame = CGRectMake(15, 0, 230, 20);
    [itemView3 addSubview:titleBtn3];
    titleBtn3.enabled = NO;
    titleBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn3.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    
    //微信支付
    UIView *wechatView = [[UIView alloc] initWithFrame:CGRectMake(0, 275, mainScreenWidth, 30)];
    wechatView.backgroundColor = UIColorFromRGB(0xfffdf6);
    [scrollView addSubview:wechatView];
    
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.titleLabel.font = FONTSIZE3;
    [wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [wechatBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    wechatBtn.frame = CGRectMake(15, 0, 110, 30);
    wechatBtn.tag = 2006;
    [wechatView addSubview:wechatBtn];
    wechatBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    wechatBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    wechatBtn.selected = YES;
    [wechatBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *wechatLineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, mainScreenWidth, 0.5)];
    [wechatView addSubview:wechatLineLab];
    wechatLineLab.backgroundColor = [UIColor lightGrayColor];
    
    //支付宝支付视图
    UIView *aliPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 305, mainScreenWidth, 30)];
    //    tihuodianView.backgroundColor = UIColorFromRGB(0xfffdf6);
    [scrollView addSubview:aliPayView];
    
    UIButton *aliPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aliPayBtn.titleLabel.font = FONTSIZE3;
    [aliPayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aliPayBtn setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [aliPayBtn setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [aliPayBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    aliPayBtn.frame = CGRectMake(15, 0, 120, 30);
    aliPayBtn.tag = 2007;
    aliPayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    aliPayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    [aliPayBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [aliPayView addSubview:aliPayBtn];
    
    //蔬果列表
    UIView *itemView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 335, mainScreenWidth, 20)];
    itemView4.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:itemView4];
    
    UIButton *titleBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn4.titleLabel.font = FONTSIZE5;
    [titleBtn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn4 setImage:[UIImage imageNamed:@"order_list2"] forState:UIControlStateNormal];
    [titleBtn4 setTitle:@"果蔬列表" forState:UIControlStateNormal];
    titleBtn4.frame = CGRectMake(15, 0, 180, 20);
    [itemView4 addSubview:titleBtn4];
    titleBtn4.enabled = NO;
    titleBtn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn4.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    
    //价格列表
    UIView *itemView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 604, mainScreenWidth, 20)];
    itemView5.backgroundColor = UIColorFromRGB(0xeeeeee);
    [scrollView addSubview:itemView5];
    
    UIButton *titleBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn5.titleLabel.font = FONTSIZE5;
    [titleBtn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn5 setImage:[UIImage imageNamed:@"order_list2"] forState:UIControlStateNormal];
    [titleBtn5 setTitle:@"价格列表" forState:UIControlStateNormal];
    titleBtn5.frame = CGRectMake(15, 0, 180, 20);
    [itemView5 addSubview:titleBtn5];
    titleBtn5.enabled = NO;
    titleBtn5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn5.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    
    
    //果蔬总价
    UIView *totolFeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 624, mainScreenWidth, 25)];
    [scrollView addSubview:totolFeeView];
    UILabel *totolFeeNameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 25)];
    totolFeeNameLab.font = FONTSIZE3;
    totolFeeNameLab.text = @"果蔬总价";
    [totolFeeView addSubview:totolFeeNameLab];
    goodTotolFeeLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 0, mainScreenWidth/2-15, 25)];
    goodTotolFeeLab.font = FONTSIZE3;
    goodTotolFeeLab.textAlignment = 2;
    goodTotolFeeLab.text = [NSString stringWithFormat:@"¥%@",totalPrice];
    [totolFeeView addSubview:goodTotolFeeLab];
    UILabel *totolFeeLineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, mainScreenWidth, 0.5)];
    [totolFeeView addSubview:totolFeeLineLab];
    totolFeeLineLab.backgroundColor = [UIColor lightGrayColor];
    
    
    //运送费用
    UIView *sendFeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 649, mainScreenWidth, 25)];
    [scrollView addSubview:sendFeeView];
    UILabel *sendFeeNameLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 25)];
    sendFeeNameLab.font = FONTSIZE3;
    sendFeeNameLab.text = @"运送费用";
    [sendFeeView addSubview:sendFeeNameLab];
    sendFeeLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 0, mainScreenWidth/2-15, 25)];
    sendFeeLab.font = FONTSIZE3;
    sendFeeLab.textAlignment = 2;
    sendFeeLab.text = [NSString stringWithFormat:@"¥0.00"];
    [sendFeeView addSubview:sendFeeLab];
    
    
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 40)];
//    titleView.backgroundColor = UIColorFromRGB(0xf0f6e5);
//    [self.view addSubview:titleView];
    
    NSArray *titleArr = @[@"收货人：",@"手机号："];
//    NSArray *imgName = @[@"order_user",@"order_telephone"];
    for (int i = 0; i < titleArr.count; i++) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 64+i*40+12, 16, 16)];
//        imgView.image = [UIImage imageNamed:[imgName objectAtIndex:i]];
//        [self.view addSubview:imgView];
//        
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(27, 64 + i*40, 60, 40)];
//        lab.font = FONTSIZE3;
//        lab.text = titleArr[i];
//        lab.textAlignment = 2;
//        [self.view addSubview:lab];
//        
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + (i+1)*40, mainScreenWidth, 2)];
//        line.backgroundColor = UIColorFromRGB(0xf0f6e5);
//        [self.view addSubview:line];
        
        UITextField *inputFeild = [[UITextField alloc] initWithFrame:CGRectMake(85, 64 + i*40, mainScreenWidth-90, 40)];
        inputFeild.font = FONTSIZE3;
        inputFeild.delegate = self;
        inputFeild.returnKeyType = UIReturnKeyDone;
        [scrollView addSubview:inputFeild];
        inputFeild.tag = 1000+i;
        inputFeild.hidden = YES;
    }
//
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 144+2+10, 20, 20)];
//    lab.text = @"取";
//    lab.textAlignment = 1;
//    lab.backgroundColor = UIColorFromRGB(0xb0c876);
//    lab.textColor = [UIColor whiteColor];
//    lab.font = FONTSIZE4_BOLD;
//    lab.layer.cornerRadius = 10;
//    lab.layer.masksToBounds = YES;
//    [self.view addSubview:lab];
//
//    
//    ziqudianLab = [[UILabel alloc] initWithFrame:CGRectMake(35, 146, mainScreenWidth-15, 40)];
//    ziqudianLab.font = FONTSIZE4_BOLD;
//    ziqudianLab.textColor = UIColorFromRGB(0x666666);
//    ziqudianLab.text = @"到自取点取货，查看自取点详细信息";
//    [self.view addSubview:ziqudianLab];
//    ziqudianLab.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSelectGetPoint)];
//    [ziqudianLab addGestureRecognizer:ges];
//    
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth-30, 156, 20, 20)];
//    imgView.image= [UIImage imageNamed:@"joinMark"];
//    [self.view addSubview:imgView];
//    
//    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 164, mainScreenWidth, 20)];
//    [self.view addSubview:imageView1];
//    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
//    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    CGFloat lengths[] = {5,5};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, UIColorFromRGB(0xb0c876).CGColor);
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
//    CGContextAddLineToPoint(line, 310.0, 20.0);
//    CGContextStrokePath(line);
//    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    
    goodTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 355, mainScreenWidth, 240) style:UITableViewStylePlain];
    goodTableView.dataSource = self;
    goodTableView.delegate = self;
    [scrollView addSubview:goodTableView];
    goodTableView.rowHeight = 120;
//
//
    //下部分结算合计视图
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight - 44, mainScreenWidth, 44)];
    //    barView.backgroundColor = UIColorFromRGB(0xffffff);
    barView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:barView];
    
    
    
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 50, 20)];
    totalLab.text = @"合计:  ";
    totalLab.font = FONTSIZE2;
    [barView addSubview:totalLab];
    
//    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 12, 80, 20)];
//    markLab.text = @"不含运费";
//    markLab.font = FONTSIZE3;
//    [barView addSubview:markLab];
    
    //    totalLab.backgroundColor = [UIColor redColor];
    totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2-10, 12, 100, 20)];
    totalPriceLab.text = [NSString stringWithFormat:@"￥ %@",totalPrice];
    totalPriceLab.font = FONTSIZE2;
    totalPriceLab.textColor = [UIColor orangeColor];
    [barView addSubview:totalPriceLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = UIColorFromRGB(0x66c2b0);
    [buyBtn setTitle:@"结算" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FONTSIZE2_BOLD;
    buyBtn.frame = CGRectMake(mainScreenWidth-80, 0, 80, 44);
    [barView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.tag = 2000;
    
    
    AddressModel *model  = [[AppUtils shareAppUtils] getDefaultAddress];
    [self selectAddress:model];
}

#pragma mark ------- tableView delegate--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cellID";
    PayOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[PayOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];
//    cell.nameLabel.text = @"西瓜";
//    cell.subNameLabel.text = @"营养丰富，汁甜味美";
//    cell.priceLaberl.text = @"¥19.80 元";
    cell.nameLabel.text = model.goodName;
    cell.subNameLabel.text = @"营养丰富，汁甜味美";
    cell.priceLaberl.text = [NSString stringWithFormat:@"¥%@ 元",model.goodPrice];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.goodPicUrl] placeholderImage:[UIImage imageNamed:@"ios_商场选购.png"]];
    
    
    [cell.addBtn addTarget:self action:@selector(changeGoodAccountAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.subBtn.tag = indexPath.row;
    
    [cell.subBtn addTarget:self action:@selector(changeGoodAccountSub:) forControlEvents:UIControlEventTouchUpInside];
    int number = [model.goodNumber intValue];
    if (number < 2) {
        cell.subBtn.enabled = NO;
    }else{
        cell.subBtn.enabled = YES;
    }
    cell.addBtn.tag = indexPath.row+4000;
    cell.subBtn.tag = indexPath.row+4000;
    cell.numberLab.text = model.goodNumber;
    
    return cell;
}
-(void)changeGoodAccountAdd:(UIButton *)button{
    NSLog(@"changeGoodAccountAdd = %ld",(long)button.tag);
    GoodModel *model = [dataArray objectAtIndex:button.tag -4000];
    
    int number = [model.goodNumber intValue];
    if (number > 98) {
        return;
    }
    number++;
    model.goodNumber = [NSString stringWithFormat:@"%d",number];
    [self.dataArray replaceObjectAtIndex:button.tag-4000 withObject:model];
    [goodTableView reloadData];
    [[AppUtils shareAppUtils] changeGoodNumber:1 andModel:model];
    
    if (model.select) {
        float totalPri = [[goodTotolFeeLab.text substringFromIndex:1] floatValue];
        float price = [model.goodPrice floatValue];
        totalPri = totalPri+price;
        totalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",totalPri+sendFee];
        goodTotolFeeLab.text = [NSString stringWithFormat:@"¥%.2f",totalPri];
    }
    
}

-(void)changeGoodAccountSub:(UIButton *)button{
    NSLog(@"changeGoodAccountSub = %ld",(long)button.tag-4000);
    GoodModel *model = [dataArray objectAtIndex:button.tag-4000];
    int number = [model.goodNumber intValue];
    if (number < 2) {
        return;
    }
    number--;
    model.goodNumber = [NSString stringWithFormat:@"%d",number];
    [self.dataArray replaceObjectAtIndex:button.tag-4000 withObject:model];
    [goodTableView reloadData];
    [[AppUtils shareAppUtils] changeGoodNumber:-1 andModel:model];
    if (model.select) {
        float totalPri = [[goodTotolFeeLab.text substringFromIndex:1] floatValue];
        float price = [model.goodPrice floatValue];
        totalPri = totalPri-price;
        totalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",totalPri+sendFee];
        goodTotolFeeLab.text = [NSString stringWithFormat:@"¥%.2f",totalPri];
        
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)goPay:(NSString *)orderId{

    UITextField *feild1 = (UITextField *)[self.view viewWithTag:1000];//姓名
    UITextField *feild2 = (UITextField *)[self.view viewWithTag:1001];//电话
    UIButton *wechatBtn = (UIButton *)[self.view viewWithTag:2006];//
    UIButton *ziti = (UIButton *)[self.view viewWithTag:2002];//
    UIButton *am = (UIButton *)[self.view viewWithTag:2008];
    UIButton *pm = (UIButton *)[self.view viewWithTag:2009];

    if (![[AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    NSLog(@"Account = %@",[[AppUtils shareAppUtils] getAccount]);
    NSLog(@"Account = %@",[[AppUtils shareAppUtils] getUserName]);

//    if ([feild1.text isEqualToString: @""] || feild1.text == nil ||[feild2.text isEqualToString: @""] || feild2.text == nil ) {
//        UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示" message:@"请完善您的信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alt show];
//        return;
//    }
//    if (![self isTelephone:feild2.text]) {
//        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
//        return;
//    }
    AnnotationModel *model2 = [[AppUtils shareAppUtils] getAddress];//自提点
//
//    //提示设置自提点
//    if (model2.address.length < 1 ||  model2.name.length < 1) {
//        UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示" message:@"请设置自提点" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alt show];
//        return;
//    }
    AddressModel *model  = [[AppUtils shareAppUtils] getDefaultAddress];//收获地址
    [self selectAddress:model];
    NSString *orderAddress = [NSString stringWithFormat:@"%@,%@",model2.name,model2.address];
    if (ziti.selected==NO) {
        orderAddress = model.address;
    }
    NSString *name = feild1.text;
    NSString *phone = feild2.text;
    if (ziti.selected) {
        name = [[AppUtils shareAppUtils] getUserName];
        phone = [[AppUtils shareAppUtils] getAccount];
    }

    
    NSError *error;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:orderId, @"order_id",  name, @"name", orderAddress, @"address",  phone, @"phone", nil];//支付宝
    
    if (wechatBtn.selected) {
        [dic setObject:@"weixin" forKey:@"type"];
    }
    if (ziti.selected) {
        [dic setObject:@"1" forKey:@"ziti"];
    }
    if (am.selected) {
        
        [dic setObject:@"0" forKey:@"send_time"];
    }
    if (pm.selected) {
        
        [dic setObject:@"1" forKey:@"send_time"];
    }
    
//    NSLog(@"选择时间类型:%@",[dic objectForKey:@"send_time"]);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString, @"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GO_PAY httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        
        
        NSString *appScheme = @"freshmanapp";
        NSString *signedString = [responseObject objectForKey:@"sign"];
        NSString *orderSpec    = [responseObject objectForKey:@"str"];
        NSString *orderString = nil;
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {

        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
            return ;
        }
        
        if (wechatBtn.selected) {
            
            
            PayReq *req = [[PayReq alloc] init];
            req.openID              = [responseObject objectForKey:@"appid"];
            req.partnerId           = [responseObject objectForKey:@"partnerid"];
            req.prepayId            = [responseObject objectForKey:@"prepayid"];
            req.nonceStr            = [responseObject objectForKey:@"noncestr"];
            req.timeStamp           = [[responseObject objectForKey:@"timestamp"] intValue];
            req.package             = [responseObject objectForKey:@"package"];
            req.sign                = [responseObject objectForKey:@"sign"];
//            [WXApi handleOpenURL:nil delegate:self];
            [WXApi sendReq:req];
        }else{
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                NSLog(@"orderStr = %@\n\n",orderString);
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslfwerut = %@\n\n",resultDic);
                    
                    if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                        [[AppUtils shareAppUtils] deleteAllGood];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
                        PaySeccussViewController *pvc  = [[PaySeccussViewController alloc] init];
                        pvc.orderId = orderId;
                        [self.navigationController pushViewController:pvc animated:YES];
                    }else{
                        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        alt.tag = 7000;
                        [alt show];
                    }
                }];
                
            }
        }


        
        [hud hide:YES];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        
        [hud hide:YES];
    }];
}
-(void) onResp:(BaseResp*)resp
{
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"success"];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
                PaySeccussViewController *pvc  = [[PaySeccussViewController alloc] init];
                pvc.orderId = orderID;
                [self.navigationController pushViewController:pvc animated:YES];

                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"fail"];
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alt.tag = 7000;
                [alt show];
                break;
            }
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 700) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)wecChatPay{
    
}
-(void)getData{
    
    [hud show:YES];
    NSError *error;
    UITextField *feild1 = (UITextField *)[self.view viewWithTag:1000];
    UITextField *feild2 = (UITextField *)[self.view viewWithTag:1001];
    UIButton *ziti = (UIButton *)[self.view viewWithTag:2002];

    //判断登陆
    if (![[AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
//    if ([feild1.text isEqualToString: @""] || feild1.text == nil ||[feild2.text isEqualToString: @""] || feild2.text == nil ) {
//        UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示" message:@"请完善您的信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alt show];
//        return;
//    }
//    if (![self isTelephone:feild2.text]) {
//        [[AppUtils shareAppUtils] showAlert:@"请输入正确手机号！"];
//        return;
//    }
    
//    AnnotationModel *model2 = [[AppUtils shareAppUtils] getAddress];
//    if (model2.address.length < 1 ||  model2.name.length < 1) {
//        UIAlertView *alt = [[UIAlertView  alloc] initWithTitle:@"提示" message:@"请设置自提点" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alt show];
//        return;
//    }
    NSLog(@"order arr = %@",orderArray);
//    [orderArray removeAllObjects];
//    if (![totalPrice isEqualToString:@"1"]) {
//        
//    }
    
//    NSMutableArray *data = (NSMutableArray *)[[AppUtils shareAppUtils] getShoppingCarGood];
//    for (int i = 0; i < dataArray.count; i++) {
//        GoodModel *mod = [dataArray objectAtIndex:i];
//        //        NSLog(@"model = %hhd name = %@  id = %@",mod.select,mod.goodName,mod.goodPid);
//        for (int j = 0; j < data.count; j++) {
//            NSMutableDictionary *dic  = [data objectAtIndex:j];
//            if ([mod.goodPid isEqualToString:[dic objectForKey:@"pid"]]) {
//                [orderArray addObject:dic];
//            }
//        }
//    }

    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:orderArray,@"product",[[AppUtils shareAppUtils] getUserId],@"token", @"0", @"sale", nil];
    if ([totalPrice isEqualToString:@"0.01"]) {
        [dic setObject:@"1" forKey:@"sale"];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    
    NSLog(@"d = %@",d);
    
    [[FMNetWorkManager sharedInstance] requestURL:MAKE_ORDER httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            orderID = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"order_id"]];
            NSLog(@"orderid = %@",orderID);
            NSLog(@"orderid = %@",[orderID class]);
            for (int i = 0 ; i < orderArray.count; i++) {
                GoodModel *model = [dataArray objectAtIndex:i];
                NSLog(@"mode id = %@",model.goodPid);
                [[AppUtils shareAppUtils] deleteOneGood:model];
            }
            [self goPay:orderID];
        }else{
            
            NSLog(@"提示的是什么:%@",[responseObject objectForKey:@"err_msg"]);
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
        
        

        
        
                
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
        [hud hide:YES];
    }];
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
