//
//  OrderListViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/24.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCell.h"
#import "OrderModel.h"
#import "AlipaySDK/AlipaySDK.h"

#import "MBProgressHUD.h"


@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *orderTableView;
    NSMutableArray *orderData;
    UIView *selectView;
}

@end

@implementation OrderListViewController
@synthesize selectCount;
-(void)getData:(NSInteger )select{
    NSString *status = [NSString stringWithFormat:@"%ld",(long)select];
    if (select == -1) {
        status = @"";
    }
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getId], @"uid",[[AppUtils shareAppUtils] getUserId],@"token",status, @"status", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_ORDER_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            [orderData removeAllObjects];
            NSArray *arr = [responseObject objectForKey:@"list"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = [arr objectAtIndex:i];
                OrderModel *model = [[OrderModel alloc] init];
                model.name = [dic objectForKey:@"name"];
                model.address = [dic objectForKey:@"address"];
                model.orderId = [dic objectForKey:@"id"];
                model.phone = [dic objectForKey:@"phone"];
                model.total = [dic objectForKey:@"total"];
                model.tradeId = [dic objectForKey:@"trade_id"];
                model.status = [dic objectForKey:@"status_name"];
                model.product = [dic objectForKey:@"product"];
                model.time = [[dic objectForKey:@"time"] substringToIndex:10];
                [orderData addObject:model];
            }
            [orderTableView reloadData];
            NSLog(@"orderdata = |%@|",orderData);
            
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    orderData = [[NSMutableArray alloc] init];
//    [self getData:selectCount];
    [self getView];
}
-(void)getView{
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"我的订单";
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    leftBtn.tag = 4000;
 
    
    NSArray *btnArr = @[@"全部",@"待支付",@"待发货",@"配送中",@"完成"];
    for (int i = 0; i < btnArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 + i*(mainScreenWidth/5), 64, mainScreenWidth/5, 35);
        [btn setTitle:btnArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = FONTSIZE3;
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    UILabel *line1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, mainScreenWidth, 1)];
    line1Lab.backgroundColor = [UIColor  grayColor];
    [self.view addSubview:line1Lab];
    selectView = [[UIView alloc] initWithFrame:CGRectMake((mainScreenWidth/5-15*2)/2, 100, 45, 2)];
    selectView.backgroundColor = UIColorFromRGB(0xE4511D);
    [self.view addSubview:selectView];
    
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 102, mainScreenWidth, mainScreenHeight-102) style:UITableViewStylePlain];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.rowHeight = 150.0f;
    [self.view addSubview:orderTableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 1000+selectCount;
    btn.frame = CGRectMake(0 + selectCount*(mainScreenWidth/5), 64, mainScreenWidth/5, 35);
    [self buttonClick:btn];
    
}
-(void)buttonClick:(UIButton *)button{
    UIButton *btn = (UIButton *)[self.view viewWithTag:selectCount+1000];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.1];
    selectView.frame = CGRectMake(0, selectView.frame.origin.y, 15*3, 2);
    selectView.center = CGPointMake(button.center.x, selectView.center.y);
    [UIView commitAnimations];
    selectCount = button.tag-1000;
    [self getData:selectCount-1];

}
#pragma mark ------tableView delegate--
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = [orderData objectAtIndex:indexPath.row];
    int num = model.product.count;
    return 65 +num*90 +25;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cellId";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        
    }
    OrderModel *model = [orderData objectAtIndex:indexPath.row];
    
    NSLog(@"model= |%@|%@|%@|%@|%@||",model.name,model.address,model.time,model.status,model.tradeId);
    [cell setModel:model];
    cell.payBtn.tag = indexPath.row +500;
    cell.deleteBtn.tag = indexPath.row +500;
    [cell.payBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)deleteOrder:(UIButton *)button{
    OrderModel *orderModel = [orderData objectAtIndex:button.tag-500];
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderModel.tradeId, @"order_id",[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString, @"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:DELETE_ORDER httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        [orderData removeObjectAtIndex:button.tag-500];
        [orderTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES ];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES ];
    }];

    
}
-(void)pay:(UIButton *)button{
//    AddressModel *model  = [[AppUtils shareAppUtils] getDefaultAddress];
    OrderModel *orderModel = [orderData objectAtIndex:button.tag-500];
    NSLog(@"order id = %@",orderModel.tradeId);

    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderModel.tradeId, @"order_id", orderModel.name, @"name", orderModel.address, @"address", orderModel.phone, @"phone", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString, @"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GO_PAY httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *appScheme = @"freshmanapp";
        NSString *signedString = [responseObject objectForKey:@"sign"];
        NSString *orderSpec    = [responseObject objectForKey:@"str"];
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            NSLog(@"orderStr = %@\n\n",orderString);
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslfwerut = %@\n\n",resultDic);
                if ([[resultDic objectForKey:@"result"] isEqualToString:@"1"]) {
                    [[AppUtils shareAppUtils] deleteAllGood];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES ];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES ];
    }];

}
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];

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
