//
//  PersonViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "PersonViewController.h"
#import "LoginViewController.h"
#import "MessageViewController.h"
#import "EditePersonViewController.h"
#import "MyOrderListViewController.h"
#import "CouponViewController.h"
#import "AddressListViewController.h"
#import "OrderListViewController.h"
#import "RegisterSeccussViewController.h"

@interface PersonViewController ()<LoginDelegate>{
    UILabel* usernameLabel;
    UILabel* addressLabel;
    UIView* personMessageView;
    UIButton* loginBtn;
}

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"收货地址管理",@"title",@"addressManager.png",@"image", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的消息",@"title",@"myselfMessage.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的收藏",@"title",@"shoucang.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的邀请码",@"title",@"coupon.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"帮助与反馈",@"title",@"setting.png",@"image", nil],nil];
    
//    orderArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"待领取",@"title",@"personOrder1.png",@"image", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"配送中",@"title",@"personOrder2.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"待付款",@"title",@"personOrder3.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"完成",@"title",@"personOrder4.png",@"image", nil],nil];
    orderArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"待支付",@"title",@"personOrder3.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"待发货",@"title",@"personOrder1.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"配送中",@"title",@"personOrder2.png",@"image", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"完成",@"title",@"personOrder4.png",@"image", nil],nil];
    
    [self showMainView];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)headRightBtnPress{

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[AppUtils shareAppUtils] getIsLogin]) {
        personMessageView.hidden = NO;
        loginBtn.hidden = YES;
    }else{
        personMessageView.hidden = YES;
        loginBtn.hidden = NO;
    }

    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_USERINFO httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        usernameLabel.text = [responseObject objectForKey:@"name"];
        addressLabel.text = [responseObject objectForKey:@"address"];
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}
//显示主要视图
-(void)showMainView{
    
    self.mTableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.bounces = NO;
    
    [self creatTableViewHeaderView];
}


//创建个人信息视图
-(void)creatTableViewHeaderView{
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 110+120)];
    
    personMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 110)];
    personMessageView.backgroundColor = [UIColor colorWithRed:51.0/255 green:77.0/255 blue:124.0/255 alpha:1];;
    [headerView addSubview:personMessageView];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake((personMessageView.frame.size.width-140)/2, personMessageView.frame.size.height/2, 140, 30);
    loginBtn.titleLabel.font = FONTSIZE2;
    loginBtn.backgroundColor = UIColorFromRGB(0xEBEBEB);
    loginBtn.layer.cornerRadius = 5;
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:navigationBarColor forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(goLoginPress) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:loginBtn];
    
//    if ([[AppUtils shareAppUtils] getIsLogin]) {
        UIImageView* headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, personMessageView.frame.size.height-60-20, 60, 60)];
        headImageView.image = [UIImage imageNamed:@"edit_pic"];
        headImageView.clipsToBounds = YES;
        headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
        [personMessageView addSubview:headImageView];
        
        usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x+headImageView.frame.size.width+10, headImageView.frame.origin.y, personMessageView.frame.size.width-(headImageView.frame.origin.x+headImageView.frame.size.width+10+20), 30)];
        usernameLabel.font = FONTSIZE3;
        usernameLabel.text = @"佚名";
        [personMessageView addSubview:usernameLabel];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(usernameLabel.frame.origin.x, usernameLabel.frame.origin.y+usernameLabel.frame.size.height, usernameLabel.frame.size.width-30, 30)];
        addressLabel.font = FONTSIZE3;
        addressLabel.text = @"地址不详";
        [personMessageView addSubview:addressLabel];
        
        UIButton* editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editeBtn.frame = CGRectMake(personMessageView.frame.size.width-30-20, addressLabel.frame.origin.y, 30, 30);
        editeBtn.titleLabel.font = FONTSIZE3;
        [editeBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editeBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [editeBtn addTarget:self action:@selector(editeBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [personMessageView addSubview:editeBtn];
        
//    }else{
        

        
//    }
    
    UIView* orderView = [[UIView alloc] initWithFrame:CGRectMake(0, personMessageView.frame.size.height+personMessageView.frame.origin.y, mainScreenWidth, 120)];
    orderView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [headerView addSubview:orderView];
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, orderView.frame.size.width, orderView.frame.size.height/2)];
    view1.backgroundColor = [UIColor clearColor];
    [orderView addSubview:view1];
    
    
    CGFloat width = (mainScreenWidth-4*44-10*2)/3;
    for (NSInteger i = 0 ; i < orderArray.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.frame = CGRectMake(10+i*(44+width), (60-44)/2, 44, 44);
        btn.titleLabel.font = FONTSIZE4;
        [btn setImage:[UIImage imageNamed:[[orderArray objectAtIndex:i] objectForKey:@"image"]] forState:UIControlStateNormal];
        [btn setTitle:[[orderArray objectAtIndex:i] objectForKey:@"title"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(-14, 10,0,0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(30, -22,0,0);
        [btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goSubOrderView:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:btn];
    }
    
    
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-1, orderView.frame.size.width, 1)];
    shadowView.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:shadowView];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, orderView.frame.size.height/2, orderView.frame.size.width, orderView.frame.size.height/2)];
    view2.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAllOrderView)];
    oneTap.numberOfTapsRequired = 1;
    [view2 addGestureRecognizer:oneTap];
    
    [orderView addSubview:view2];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (view2.frame.size.height-24)/2, 24, 24)];
    imageView.image = [UIImage imageNamed:@"personOrderAll.png"];
    [view2 addSubview:imageView];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+20, imageView.frame.origin.y, 80, imageView.frame.size.height)];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = FONTSIZE2;
    label1.text = @"全部订单";
    [view2 addSubview:label1];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(view2.frame.size.width-130 , imageView.frame.origin.y, 120, imageView.frame.size.height)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = UIColorFromRGB(0x666666);
    label2.font = FONTSIZE4;
    label2.text = @"查看全部订单详情";
    [view2 addSubview:label2];
    
    UIImageView * markView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"joinMark.png"]];
    markView.frame = CGRectMake(label2.frame.size.width-20, (label2.frame.size.height-20)/2, 20, 20);
    [label2 addSubview:markView];
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, view2.frame.size.height-3, orderView.frame.size.width, 3)];
    shadowView.backgroundColor = UIColorFromRGB(0xD4D4D4);
    [view2 addSubview:shadowView];
    
    
//    headerView.backgroundColor = UIColorFromRGB(0x305380);
    headerView.backgroundColor = [UIColor colorWithRed:51.0/255 green:77.0/255 blue:124.0/255 alpha:1];
    self.mTableView.tableHeaderView = headerView;
}


-(void)goLoginPress{
    NSLog(@"去登录");
    LoginViewController * loginView = [[LoginViewController alloc] init];
    loginView.delegate = self;
    [self.navigationController pushViewController:loginView animated:YES];
}

-(void)editeBtnPress{
    NSLog(@"去编辑");
    EditePersonViewController* editeView = [[EditePersonViewController alloc] init];
    editeView.delegate = self;
    [self.navigationController pushViewController:editeView animated:YES];
}

//创建订单显示界面
- (void)orderViewCreat{
    
}

-(void)goSubOrderView:(UIButton*)sender{
    NSLog(@"去订单界面");
    if ([[AppUtils shareAppUtils] getIsLogin]) {
        OrderListViewController* myOrderListView = [[OrderListViewController alloc] init];
        myOrderListView.selectCount = sender.tag - 100 +1;
        [self.navigationController pushViewController:myOrderListView animated:YES];
        
    }else{
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = sender.titleLabel.text;
        [self.navigationController pushViewController:loginView animated:YES];
    }
    
}

-(void)goAllOrderView{
    NSLog(@"去订单界面");
    if ([[AppUtils shareAppUtils] getIsLogin]) {
//        MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
//        myOrderListView.selectCount = 0;
//        [self.navigationController pushViewController:myOrderListView animated:YES];
        OrderListViewController *ovc = [[OrderListViewController alloc] init];
        ovc.selectCount = 0;
        [self.navigationController pushViewController:ovc animated:YES];
    }else{
        LoginViewController* loginView = [[LoginViewController alloc] init];
        loginView.delegate = self;
        loginView.typeString = @"全部订单";
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* FVCellString = @"cellstring";
    PersonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:FVCellString];
    if (!cell) {
        cell = [[PersonTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FVCellString];
    }
    cell.imageView.image = [UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([[AppUtils shareAppUtils] getIsLogin]) {
            AddressListViewController* addressManagerListView = [[AddressListViewController alloc] init];
            addressManagerListView.fathType = @"1";
            [self.navigationController pushViewController:addressManagerListView animated:YES];
        }else{
            LoginViewController* loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            loginView.typeString = @"地址管理";
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }else if (indexPath.row == 1){
        if ([[AppUtils shareAppUtils] getIsLogin]) {
            MessageViewController* messageVC = [[MessageViewController alloc] init];
            messageVC.delegate = self;
            [self.navigationController pushViewController:messageVC animated:YES];
            
        }else{
            LoginViewController* loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            loginView.typeString = @"消息";
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }else if (indexPath.row == 2){
//        if ([[AppUtils shareAppUtils] getIsLogin]) {
//            CouponViewController* couponView = [[CouponViewController alloc] init];
//            [self.navigationController pushViewController:couponView animated:YES];
//        }else{
//            LoginViewController* loginView = [[LoginViewController alloc] init];
//            loginView.delegate = self;
//            loginView.typeString = @"我的收藏";
//            [self.navigationController pushViewController:loginView animated:YES];
//        }
    }else if (indexPath.row == 3){
        if ([[AppUtils shareAppUtils] getIsLogin]) {
//            CouponViewController* couponView = [[CouponViewController alloc] init];
//            [self.navigationController pushViewController:couponView animated:YES];
            RegisterSeccussViewController* couponView = [[RegisterSeccussViewController alloc] init];
            couponView.is_invite = @"2";
            [self.navigationController pushViewController:couponView animated:YES];
        }else{
            LoginViewController* loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            loginView.typeString = @"优惠券";
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
//    else if (indexPath.row == 3){
//        
//    }
}

#pragma mark ---- 登录状态改变 --------

-(void)LoginStateNotification:(NSNotification *)notification{
    [self creatTableViewHeaderView];
}

#pragma mark ---- 登录状态改变 --------
-(void)UIViewControllerBack:(MyViewController *)myViewController{
    if ([myViewController isKindOfClass:[EditePersonViewController class]]) {
        [self goLoginPress];
    }
    if ([myViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginView = (LoginViewController*)myViewController;
        if ([loginView.typeString isEqualToString:@"消息"]) {
            MessageViewController* messageVC = [[MessageViewController alloc] init];
            messageVC.delegate = self;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
//        else if ([loginView.typeString isEqualToString:@"地址管理"]){
//            AddressManagerListViewController* addressManagerListView = [[AddressManagerListViewController alloc] init];
//            [self.navigationController pushViewController:addressManagerListView animated:YES];
//        }
        else if ([loginView.typeString isEqualToString:@"优惠券"]){
            CouponViewController* couponView = [[CouponViewController alloc] init];
            [self.navigationController pushViewController:couponView animated:YES];
        }else if ([loginView.typeString isEqualToString:@"我的收藏"]){
            
        }
        else if ([loginView.typeString isEqualToString:@"全部订单"]){
            MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
            myOrderListView.selectCount = 0;
            [self.navigationController pushViewController:myOrderListView animated:YES];
        }else if ([loginView.typeString isEqualToString:@"待领取"]){
            MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
            myOrderListView.selectCount = 1;
            [self.navigationController pushViewController:myOrderListView animated:YES];
        }else if ([loginView.typeString isEqualToString:@"配送中"]){
            MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
            myOrderListView.selectCount = 2;
            [self.navigationController pushViewController:myOrderListView animated:YES];
        }else if ([loginView.typeString isEqualToString:@"待付款"]){
            MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
            myOrderListView.selectCount = 3;
            [self.navigationController pushViewController:myOrderListView animated:YES];
        }else if ([loginView.typeString isEqualToString:@"待评价"]){
            MyOrderListViewController* myOrderListView = [[MyOrderListViewController alloc] init];
            myOrderListView.selectCount = 4;
            [self.navigationController pushViewController:myOrderListView animated:YES];
        }
    }
}
-(void)LoginSuccessInData:(NSString *)message{
    
    NSLog(@"message = %@",message);

}
-(void)LoginFailInData:(NSString *)message{


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
