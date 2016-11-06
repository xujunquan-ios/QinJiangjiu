//
//  GoodDetailViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "GoodModel.h"
#import "PayOrderViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"

@interface GoodDetailViewController ()<UIScrollViewDelegate>{
    UIScrollView *showScrollView;
    GoodModel *model;
    UIPageControl *pageControll;
    UILabel *fruitName;
    UILabel *standard;
    UILabel *areaLab;
    MBProgressHUD *hud;

}

@end

@implementation GoodDetailViewController
@synthesize yingyang1,yingyang2,yingyang3,numberLab,priceLab,isZero;
//@synthesize pid,model;

-(void)changeGoodAccountAdd:(UIButton *)button{
    NSLog(@"changeGoodAccountAdd = %ld",(long)button.tag);
    int number = [numberLab.text intValue];
    number++;
    if (number > 98) {
        return;
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:4000];
    btn.enabled = YES;
    model.goodNumber = numberLab.text;
//    [[AppUtils shareAppUtils] changeGoodNumber:1 andModel:model];
    numberLab.text = [NSString stringWithFormat:@"%d",number];

}

-(void)changeGoodAccountSub:(UIButton *)button{
    NSLog(@"changeGoodAccountSub = %ld",(long)button.tag);
    int number = [numberLab.text intValue];
    if (number < 2) {
        button.enabled = NO;
        return;
    }else{
        button.enabled = YES;
    }
    model.goodNumber = numberLab.text;
//    [[AppUtils shareAppUtils] changeGoodNumber:-1 andModel:model];
    number--;
    numberLab.text = [NSString stringWithFormat:@"%d",number];
}
-(void)buildView{
    UIView *showBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-113)];
    [self.view addSubview:showBgView];
    showBgView.userInteractionEnabled = YES;
    
    showScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, showBgView.frame.size.height-223)];
    showScrollView.contentSize=CGSizeMake(4*mainScreenWidth, showScrollView.frame.size.height);
    showScrollView.pagingEnabled=YES;
    showScrollView.bounces=NO;
    showScrollView.showsHorizontalScrollIndicator=NO;
    showScrollView.showsVerticalScrollIndicator=NO;
    [showBgView addSubview:showScrollView];
    showScrollView.delegate = self;
    
    pageControll=[[UIPageControl alloc]init];
    pageControll.frame=CGRectMake(100, showScrollView.frame.size.height-30, mainScreenWidth-200, 20);
    pageControll.currentPage=0;
    //curPage=pageControll.currentPage;
//    [pageControll addTarget:self action:@selector(pageTap:) forControlEvents:UIControlEventValueChanged];
    [showBgView addSubview:pageControll];
    
    
    UIView *paraView = [[UIView alloc] initWithFrame:CGRectMake(0, showScrollView.frame.size.height, mainScreenWidth, 135)];
    [showBgView addSubview:paraView];
    paraView.backgroundColor = UIColorFromRGB(0xf1f7e8);
    
    
    fruitName = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 40)];
    fruitName.text = @"香蕉";
    fruitName.font = FONTSIZE1_BOLD;
    fruitName.textAlignment = 0;
    [paraView addSubview:fruitName];
    
    
    standard = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 140, 20)];
    standard.font = FONTSIZE4;
    standard.text = @"160g/份";
    [paraView addSubview:standard];
    
    areaLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth*390/750, 50, 100, 20)];
    areaLab.font = FONTSIZE4;
    areaLab.text = @"原产地：国产";
    [paraView addSubview:areaLab];
    
    priceLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 75, 140, 30)];
    priceLab.font = FONTSIZE1_BOLD;
    priceLab.textColor = UIColorFromRGB(0xee751e);
    [paraView addSubview:priceLab];
    
    UILabel *numberTitle = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth*390/750, 75, 50, 30)];
    numberTitle.text = @"购买数量";
    numberTitle.font = FONTSIZE4;
    [paraView addSubview:numberTitle];
    
    
    numberLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberTitle.frame)+4+30, numberTitle.frame.origin.y, 25, 30)];
    numberLab.backgroundColor = [UIColor whiteColor];
//    numberLab.text = @"1";
    numberLab.textAlignment = 1;
    numberLab.font = FONTSIZE3;
    [paraView addSubview:numberLab];
    
  
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"addafter"] forState:UIControlStateDisabled];
    addBtn.frame = CGRectMake(CGRectGetMaxX(numberTitle.frame)+4+55, numberTitle.frame.origin.y, 30, 30);
    [paraView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(changeGoodAccountAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subBtn setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
    [subBtn setImage:[UIImage imageNamed:@"cutafter"] forState:UIControlStateDisabled];
    subBtn.frame = CGRectMake(CGRectGetMaxX(numberTitle.frame)+4, numberTitle.frame.origin.y, 30, 30);
    [paraView addSubview:subBtn];
    [subBtn addTarget:self action:@selector(changeGoodAccountSub:) forControlEvents:UIControlEventTouchUpInside];
    subBtn.tag = 4000;

    if ([isZero isEqualToString:@"1"]) {
        numberLab.text = @"1";
        subBtn.enabled = NO;
        addBtn.enabled = NO;
    }

    UILabel *altLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 115, mainScreenWidth-30, 15)];
    altLab.backgroundColor = UIColorFromRGB(0xf0f6e5);
    altLab.text = @"果蔬堂小提示：00:00前下单明日送达，00:00后下单后日送达";
    [paraView addSubview:altLab];
    altLab.textColor = [UIColor orangeColor];
    altLab.font = FONTSIZE5;
    altLab.textAlignment = 0;
    
    
    UILabel *yingyangTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(paraView.frame)+10, 55, 15)];
    yingyangTitle.font = FONTSIZE4;
    yingyangTitle.textColor = [UIColor whiteColor];
    yingyangTitle.backgroundColor = [UIColor orangeColor];
    yingyangTitle.layer.cornerRadius = 5;
    yingyangTitle.layer.masksToBounds = YES;//
    yingyangTitle.text = @"营养含量";
    yingyangTitle.textAlignment = 1;
    [showBgView addSubview:yingyangTitle];
    
    for (int i = 0; i < 5; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15+(mainScreenWidth-30)/3*(i%3), CGRectGetMaxY(yingyangTitle.frame)+10+25*(i/3), (mainScreenWidth-30)/3, 15)];
        lab.font = FONTSIZE4;
        [showBgView addSubview:lab];
        lab.tag = 1000+i;
    }
    

    

    
}
-(void)getData{
    
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.pid,@"pid", nil];
    [[FMNetWorkManager sharedInstance] requestURL:GET_GOOES_DETAIL httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSDictionary* response = (NSDictionary*)responseObject;
        
        NSArray *imageArr = [response objectForKey:@"pic"];
        showScrollView.contentSize=CGSizeMake(imageArr.count*mainScreenWidth, showScrollView.frame.size.height);
        for (int i = 0; i < imageArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth*i, 0, mainScreenWidth, showScrollView.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"ios_商场选购"]];
            [showScrollView addSubview:imageView];
        }
        pageControll.numberOfPages=imageArr.count;

        model.goodId = [response objectForKey:@"id"];
        model.goodName = [response objectForKey:@"name"];
        model.goodPid = self.pid;
        model.goodPrice = [response objectForKey:@"price"];
        model.goodPicUrl = [imageArr objectAtIndex:0];
        
//        yingyang1.text = [NSString stringWithFormat:@"热量%@％,补充每日所需热量",[response objectForKey:@"cal"]];
//        yingyang2.text = [NSString stringWithFormat:@"碳水化合物%@％,补充每日所需碳水化合物",[response objectForKey:@"cho"]];
//        yingyang3.text = [NSString stringWithFormat:@"膳食纤维%@％,补充每日所需膳食纤维",[response objectForKey:@"ndf"]];
        float pr = [[response objectForKey:@"price"] floatValue];
        priceLab.text = [NSString stringWithFormat:@"¥  %.2f/份",pr];
        if ([isZero isEqualToString:@"1"]) {
            priceLab.text = @"0.01";
        }
        fruitName.text = model.goodName;
        standard.text = [NSString stringWithFormat:@"%@/份",[response objectForKey:@"unit"]];
        UILabel *lab1 = (UILabel *)[self.view viewWithTag:1000+0];
        UILabel *lab2 = (UILabel *)[self.view viewWithTag:1000+1];
        UILabel *lab3 = (UILabel *)[self.view viewWithTag:1000+2];
        UILabel *lab4 = (UILabel *)[self.view viewWithTag:1000+3];
        UILabel *lab5 = (UILabel *)[self.view viewWithTag:1000+4];
        lab1.text = [NSString stringWithFormat:@"热量：%@",[response objectForKey:@"cal"]];
        lab2.text = [NSString stringWithFormat:@"蛋白质：%@",[response objectForKey:@"pro"]];
        lab3.text = [NSString stringWithFormat:@"膳食纤维：%@",[response objectForKey:@"ndf"]];
        lab4.text = [NSString stringWithFormat:@"脂肪：%@",[response objectForKey:@"fat"]];
        lab5.text = [NSString stringWithFormat:@"碳水化合物：%@",[response objectForKey:@"cho"]];
        

        int number =[[AppUtils shareAppUtils] getGoodNumber:model];
        if (number<1) {
            number = 1;
        }
        if ([isZero isEqualToString:@"1"]) {
            numberLab.text = @"1";
        }else{
            numberLab.text = [NSString stringWithFormat:@"%d",number];
        }
        model.goodNumber = [NSString stringWithFormat:@"%d",number];
        areaLab.text = [NSString stringWithFormat:@"原产地:%@",[response objectForKey:@"area"]];
        
    
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);

        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getData];
    hud = [[MBProgressHUD alloc] init];

    model = [[GoodModel alloc] init];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.headTitleLabel.text = self.title;
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dianZan)];
    [self.zanView addGestureRecognizer:oneTap];
    
    
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoucang)];
    [self.shoucangView addGestureRecognizer:oneTap];

    
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share)];
    [self.shareView addGestureRecognizer:oneTap];

    self.shoppingCartBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.buyBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.buyBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    UIButton *btnAddCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddCart.frame = CGRectMake(0, mainScreenHeight-49, mainScreenWidth/2, 49);
    [btnAddCart setBackgroundColor:[UIColor colorWithRed:239.0/255 green:147.0/255 blue:20.0/255 alpha:1]];
    [btnAddCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnAddCart addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAddCart];
    
    UIButton *buybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    buybutton.frame = CGRectMake(mainScreenWidth/2, mainScreenHeight-49, mainScreenWidth/2, 49);
    buybutton.titleLabel.textColor = [UIColor whiteColor];
    [buybutton setBackgroundColor:[UIColor colorWithRed:224.0/255 green:88.0/255 blue:25.0/255 alpha:1]];
    [buybutton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buybutton addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buybutton];
    
    if ([isZero isEqualToString:@"1"]) {
        btnAddCart.enabled = NO;
    }
    [self buildView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnPress{
    NSLog(@"去购物车");
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self backToRootViewControllerWithType:INDEX_SHOPPING_CART];

}

-(void)dianZan{
    NSLog(@"点赞");
}

-(void)shoucang{
    NSLog(@"收藏");
}

-(void)share{
    NSLog(@"分享");
}

-(void)btnPress:(UIButton*)sender{
    NSLog(@"去%@",sender.titleLabel.text);
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"立即购买"]) {
        //        OrderViewController* orderView = [[OrderViewController alloc] init];
        //        [self.navigationController pushViewController:orderView animated:YES];
        
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [dataArr addObject:model];
        
        NSLog(@"pid = |%@|",model.goodPid);
        

        
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [newDic setObject:numberLab.text forKey:@"amount"];
//        if
        [newDic setObject:model.goodPid forKey:@"pid"];
        
        float price = [model.goodPrice floatValue];
        int number = [numberLab.text intValue];
        NSString *priceString = [NSString stringWithFormat:@"%.2f",price*number];
        NSLog(@"price = %@",priceString);
        NSMutableArray *data = [NSMutableArray arrayWithObject:newDic];
        PayOrderViewController *pvc = [[PayOrderViewController alloc] init];
        pvc.totalPrice = priceString;
        pvc.orderArray = data;
        pvc.dataArray = dataArr;
        if ([isZero isEqualToString:@"1"]) {
            pvc.totalPrice = @"0.01";
        }
        [self.navigationController pushViewController:pvc animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"加入购物车"]){
        if ([isZero isEqualToString:@"1"]) {
            return;
        }
        [self.view addSubview:hud];
        hud.labelText = @"加入购物车";
        [hud show:YES];
        hud.dimBackground = NO;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:0.6];
        
//        [[AppUtils shareAppUtils] saveToShoppingCar:model];
        
        [[AppUtils shareAppUtils] changeGoodNumberAs:[numberLab.text intValue] andModel:model];


    }
}
#pragma mark------scroll delegate

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    pageControll.currentPage=scrollView.contentOffset.x/mainScreenWidth;
//
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageControll setCurrentPage:offset.x / bounds.size.width];
    NSLog(@"%f",offset.x / bounds.size.width);
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
