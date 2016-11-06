//
//  GoodViewNewViewController.m
//  FreshMan
//
//  Created by Jie on 15/10/30.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "GoodViewNewViewController.h"
#import "GoodDetailViewController.h"
#import "GoodModel.h"
#import "PayOrderViewController.h"
#import "LoginViewController.h"
#import "GoodCell.h"

@interface GoodViewNewViewController (){
    MBProgressHUD *hud;
    
    UITableView *goodTableView;
}

@end

@implementation GoodViewNewViewController
@synthesize goodId,goodType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    dataArray = [[NSMutableArray alloc] init];
    
    
    [self getView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getGoodDetailData];

}

-(void)getView{
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-80, 20, 160, 44)];
    titleLab.text = self.title;
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(mainScreenWidth-54, 20, 44, 44);
    [rightBtn setImage:[UIImage imageNamed:@"nav_shoppingCenter"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:rightBtn];
    rightBtn.tag = 4001;
    
    UILabel *altLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 20)];
    altLab.backgroundColor = UIColorFromRGB(0xf0f6e5);
    altLab.text = @"果蔬堂小提示：00:00前下单明日送达，00:00后下单后日送达";
    [self.view addSubview:altLab];
    altLab.textColor = [UIColor orangeColor];
    altLab.font = FONTSIZE5;
    altLab.textAlignment = 1;
    
    goodTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, mainScreenWidth, mainScreenHeight-84) style:UITableViewStylePlain];
    goodTableView.delegate = self;
    goodTableView.dataSource = self;
    [self.view addSubview:goodTableView];
    goodTableView.rowHeight = 100;
    
}
-(void)getGoodDetailData{
    if ([goodType isEqualToString:@"2"]) {
        goodType = @"1";
    }
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
            model.marketPrice = [[response objectAtIndex:i] objectForKey:@"market_price"];
            int number =[[AppUtils shareAppUtils] getGoodNumber:model];
            if (!number) {
                number = 1;
            }
            model.goodNumber = [NSString stringWithFormat:@"%d",number];
            [dataArray addObject:model];
        }
        [goodTableView reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        [dataArray removeAllObjects];
        [goodTableView reloadData];
        
    }];
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
//    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];
    
    GoodDetailViewController* goodDetailView = [[GoodDetailViewController alloc] init];
    goodDetailView.title = @"果蔬购买";
    goodDetailView.pid = model.goodPid;
    //    goodDetailView.model = model;
    [self.navigationController pushViewController:goodDetailView animated:YES];
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(mainScreenWidth-180, 50)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellString = @"GoodTableViewCell";
    GoodCell* cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell= [[GoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }

    cell.buyBtn.tag = indexPath.row;
    cell.shopingCartBtn.tag = indexPath.row;
    cell.addBtn.tag = indexPath.row;
    cell.subBtn.tag = indexPath.row;
    [cell.buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shopingCartBtn addTarget:self action:@selector(addCart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchUpInside];
    [cell.subBtn addTarget:self action:@selector(subNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];
    CGSize size = [self sizeWithString:model.goodName font:FONTSIZE3];
    cell.titleLabel.frame = CGRectMake(95, 20, size.width, size.height);

    [cell setModel:model];
    int number =[[AppUtils shareAppUtils] getGoodNumber:model];
    NSLog(@"%@=%d",model.goodName,number);
    return cell;
}
-(void)buy:(UIButton *)button{
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    GoodModel *model = [dataArray objectAtIndex:button.tag];    
    NSMutableArray *dataArr = [NSMutableArray arrayWithObject:model];
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
    [newDic setObject:model.goodNumber forKey:@"amount"];
    [newDic setObject:model.goodPid forKey:@"pid"];
    
    float price = [model.goodPrice floatValue];
    int number = [model.goodNumber intValue];
    NSString *priceString = [NSString stringWithFormat:@"%.2f",price*number];
    NSLog(@"price = %@",priceString);
    NSMutableArray *data = [NSMutableArray arrayWithObject:newDic];
    PayOrderViewController *pvc = [[PayOrderViewController alloc] init];
    pvc.totalPrice = priceString;
    pvc.orderArray = data;
    pvc.dataArray = dataArr;
    [self.navigationController pushViewController:pvc animated:YES];
    
    NSLog(@"shop car = %@",[[AppUtils shareAppUtils] getShoppingCarGood]);
}
-(void)addCart:(UIButton *)button{
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    [self.view addSubview:hud];
    hud.labelText = @"加入购物车";
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:0.6];
    
    GoodModel *model = [dataArray objectAtIndex:button.tag];
    NSLog(@"%@-%@",model.goodPid,model.goodName);
//    [[AppUtils shareAppUtils] saveToShoppingCar:model];
    [[AppUtils shareAppUtils] changeGoodNumberAs:[model.goodNumber intValue] andModel:model];
//    GoodModel *model = [dataArray objectAtIndex:button.tag];
//    
//    int number = [model.goodNumber intValue];
//    number++;
//    model.goodNumber = [NSString stringWithFormat:@"%d",number];
//    [dataArray replaceObjectAtIndex:button.tag withObject:model];
//    [goodTableView reloadData];
//    [[AppUtils shareAppUtils] changeGoodNumber:1 andModel:model];
}
-(void)addNumber:(UIButton *)button{
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    GoodModel *model = [dataArray objectAtIndex:button.tag];
    int number = [model.goodNumber intValue];
    if (number > 98) {
        return;
    }
    number++;
    model.goodNumber = [NSString stringWithFormat:@"%d",number];
    [dataArray replaceObjectAtIndex:button.tag withObject:model];
    [goodTableView reloadData];
//    [[AppUtils shareAppUtils] changeGoodNumber:1 andModel:model];

}
-(void)subNumber:(UIButton *)button{
    if (![[ AppUtils shareAppUtils] getIsLogin]) {
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
        return;
    }
    GoodModel *model = [dataArray objectAtIndex:button.tag];
    int number = [model.goodNumber intValue];
    if (number < 2) {
        return;
    }
    number--;
    model.goodNumber = [NSString stringWithFormat:@"%d",number];
    [dataArray replaceObjectAtIndex:button.tag withObject:model];
    [goodTableView reloadData];
//    [[AppUtils shareAppUtils] changeGoodNumber:-1 andModel:model];

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
