//
//  GoodViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "GoodViewController.h"
#import "GoodDetailViewController.h"
#import "GoodModel.h"
#import "PayOrderViewController.h"
#import "LoginViewController.h"

@interface GoodViewController (){
    MBProgressHUD *hud;
}



@end

@implementation GoodViewController
@synthesize goodId,goodType;
-(void)getGoodDetailData{
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:goodType,@"type",self.goodId,@"category", nil];
    NSLog(@"d = %@",d);
    
    
    [[FMNetWorkManager sharedInstance] requestURL:GET_GOODS_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSMutableArray* response = (NSMutableArray*)[responseObject objectForKey:@"product"];
        [dataArray removeAllObjects];
        for (int i = 0; i < response.count; i++) {
            GoodModel *model = [[GoodModel alloc] init];
            model.goodId = [[response objectAtIndex:i] objectForKey:@"id"];
            model.goodName = [[response objectAtIndex:i] objectForKey:@"name"];
            model.goodPicUrl = [[response objectAtIndex:i] objectForKey:@"pic"];
            model.goodPid = [[response objectAtIndex:i] objectForKey:@"pid"];
            model.goodPrice = [[response objectAtIndex:i] objectForKey:@"price"];
            model.goodNumber = @"1";
            [dataArray addObject:model];
        }
        [self.mTableView reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        [dataArray removeAllObjects];
        [self.mTableView reloadData];
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    dataArray = [[NSMutableArray alloc] init];
    [self getGoodDetailData];
//    dataArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],nil];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.headTitleLabel.text = self.title;
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.mTableView.clipsToBounds = NO;
    // Do any additional setup after loading the view from its nib.
    
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = self.title;
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    leftBtn.tag = 4000;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(mainScreenWidth-54, 20, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"nav_shoppingCenter"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    rightBtn.tag = 4001;
    
    
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnPress{
    NSLog(@"去看购物车");
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self backToRootViewControllerWithType:INDEX_SHOPPING_CART];

}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellString = @"GoodTableViewCell";
    GoodTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GoodTableViewCell" owner:nil options:nil] firstObject];
    }
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];

    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.goodPicUrl] placeholderImage:[UIImage imageNamed:@"ios_商场 活动"]];
    cell.priceLabel.text = model.goodPrice;
    cell.titleLabel.text = model.goodName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];

    GoodDetailViewController* goodDetailView = [[GoodDetailViewController alloc] init];
    goodDetailView.title = @"果蔬购买";
    goodDetailView.pid = model.goodPid;
//    goodDetailView.model = model;
    [self.navigationController pushViewController:goodDetailView animated:YES];
}

#pragma mark ---- FVGroupTableViewCellDelegate --------

-(void)btnPress:(NSIndexPath *)indexPath andFunction:(NSString *)function{
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    NSLog(@"%ld行 去%@",(long)indexPath.row,function);
    if ([function isEqualToString:@"立即购买"]) {
//        OrderViewController* orderView = [[OrderViewController alloc] init];
//        [self.navigationController pushViewController:orderView animated:YES];
        GoodModel *model = [dataArray objectAtIndex:indexPath.row];
        
        NSArray *dataArr = [NSArray arrayWithObject:model];
        
        
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [newDic setObject:model.goodNumber forKey:@"amount"];
        [newDic setObject:model.goodPid forKey:@"pid"];
        
        float price = [model.goodPrice floatValue];
        int number = [model.goodNumber intValue];
        NSString *priceString = [NSString stringWithFormat:@"%.2f",price*number];
        NSLog(@"price = %@",priceString);
        NSArray *data = [NSArray arrayWithObject:newDic];
        PayOrderViewController *pvc = [[PayOrderViewController alloc] init];
        pvc.totalPrice = priceString;
        pvc.orderArray = data;
        pvc.dataArray = dataArr;
        [self.navigationController pushViewController:pvc animated:YES];
        
        NSLog(@"shop car = %@",[[AppUtils shareAppUtils] getShoppingCarGood]);
    }else if ([function isEqualToString:@"加入购物车"]){
        
        
        hud.labelText = @"加入购物车";
        [hud show:YES];
        hud.dimBackground = NO;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:0.6];
        GoodModel *model = [dataArray objectAtIndex:indexPath.row];
        NSLog(@"%@-%@",model.goodPid,model.goodName);
        [[AppUtils shareAppUtils] saveToShoppingCar:model];
        
        
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
