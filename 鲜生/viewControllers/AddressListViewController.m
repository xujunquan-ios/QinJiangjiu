//
//  AddressListViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressCell.h"
#import "AddNewAddressViewController.h"

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *addressTableView;
    NSMutableArray *addressData;
    NSInteger selectAddress;
    
    /*
        get为自取点前缀
        send为送货点前缀
     */
    
    NSMutableArray *getPointArray;
    NSMutableArray *sendPointArray;
    
    UIButton *getPointBtn;
    UIButton *sendPointBtn;
    UIView *selectView;

}

@end

@implementation AddressListViewController
@synthesize fathType;
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addressData = [[NSMutableArray alloc] init];
    getPointArray = [[NSMutableArray alloc] init];
    sendPointArray = [[NSMutableArray alloc] init];
    [self getView];
    [self getData2];

}
-(void)getData2{
    NSError *error;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token",[[AppUtils shareAppUtils] getId],@"uid", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_TRACKADDRESS_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response getData1 =%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        NSMutableArray *adArr = [responseObject objectForKey:@"list"];
        if ([status isEqualToString:@"1"]) {
//            [sendPointArray removeAllObjects];
//            for (int i = 0; i < adArr.count; i++) {
//                AddressModel *model = [[AddressModel alloc] init];
//                model.name = [[adArr objectAtIndex:i] objectForKey:@"name"];
//                model.phone = [[adArr objectAtIndex:i] objectForKey:@"phone"];
//                model.address = [[adArr objectAtIndex:i] objectForKey:@"address"];
//                model.addressId =[[adArr objectAtIndex:i] objectForKey:@"id"];
//                model.uid = [[adArr objectAtIndex:i] objectForKey:@"uid"];
//                model.moren = [[adArr objectAtIndex:i] objectForKey:@"acquiescent"];
//                if ([model.moren isEqualToString:@"1"]) {
//                    [[AppUtils shareAppUtils] saveDefaultAddress:model];
//                }
//                [sendPointArray addObject:model];
//            }
//            [addressData removeAllObjects];
//            [addressData addObjectsFromArray:sendPointArray];
            //            [addressTableView reloadData];
            
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}
-(void)getData{
    NSError *error;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token",[[AppUtils shareAppUtils] getId],@"uid", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_ADDRESS_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        NSMutableArray *adArr = [responseObject objectForKey:@"list"];
        if ([status isEqualToString:@"1"]) {
            [sendPointArray removeAllObjects];
            for (int i = 0; i < adArr.count; i++) {
                AddressModel *model = [[AddressModel alloc] init];
                model.name = [[adArr objectAtIndex:i] objectForKey:@"name"];
                model.phone = [[adArr objectAtIndex:i] objectForKey:@"phone"];
                model.address = [[adArr objectAtIndex:i] objectForKey:@"address"];
                model.addressId =[[adArr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[adArr objectAtIndex:i] objectForKey:@"uid"];
                model.moren = [[adArr objectAtIndex:i] objectForKey:@"acquiescent"];
                if ([model.moren isEqualToString:@"1"]) {
                    [[AppUtils shareAppUtils] saveDefaultAddress:model];
                }
                [sendPointArray addObject:model];
            }
            [addressData removeAllObjects];
            [addressData addObjectsFromArray:sendPointArray];
            [addressTableView reloadData];

        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

    }];

}
-(void)toAddNew{
    AddressModel *model = [[AddressModel alloc] init];
    model.name = @"";
    model.phone = @"";
    model.address = @"";
    model.addressId = @"";
    model.uid = [[AppUtils shareAppUtils] getId];
    AddNewAddressViewController *avc = [[AddNewAddressViewController alloc] init];
    avc.model = model;
    avc.userType = @"1";
    if ([fathType isEqualToString:@"3"]) {
        avc.userType = fathType;
    }
    [self.navigationController pushViewController:avc animated:YES];

}
-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 4000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 4001:
            NSLog(@"add new address") ;
            [self toAddNew];
            break;
        case 4002:
            NSLog(@"change to get") ;
            sendPointBtn.selected = NO;
            getPointBtn.selected = YES;
            sendPointBtn.backgroundColor = [UIColor clearColor];
            getPointBtn.backgroundColor = [UIColor whiteColor];

            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.1];
            selectView.frame = CGRectMake(0, selectView.frame.origin.y, mainScreenWidth/2-50, 2);
            selectView.center = CGPointMake(button.center.x, selectView.center.y);
            [UIView commitAnimations];
            if (getPointArray.count > 0) {
                [addressData removeAllObjects];
                [addressData addObjectsFromArray:getPointArray];
            }else{
                [addressData removeAllObjects];
            }
            [addressTableView reloadData];
            
            addressTableView.frame = CGRectMake(0, 64+30, mainScreenWidth, mainScreenHeight-64-30);
            break;
            
        case 4003:
            NSLog(@"change to send") ;
            sendPointBtn.selected = YES;
            getPointBtn.selected = NO;
            sendPointBtn.backgroundColor = [UIColor whiteColor];
            getPointBtn.backgroundColor = [UIColor clearColor];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.1];
            selectView.frame = CGRectMake(0, selectView.frame.origin.y, mainScreenWidth/2-50, 2);
            selectView.center = CGPointMake(button.center.x, selectView.center.y);
            [UIView commitAnimations];

            if (sendPointArray.count > 0) {
                [addressData removeAllObjects];
                [addressData addObjectsFromArray:sendPointArray];
            }else{
                [self getData];

            }
            [addressTableView reloadData];
            
            addressTableView.frame = CGRectMake(0, 64+30, mainScreenWidth, mainScreenHeight-64-35-30);


            break;
            
        default:
            break;
    }
}

//初始化视图
-(void)getView{
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"地址管理";
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    leftBtn.tag = 4000;
    
    
    //底部添加新地址视图和按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(mainScreenWidth/2-50, mainScreenHeight-42, 100, 30);
    btn.frame = CGRectMake(0, mainScreenHeight-50, mainScreenWidth, 50);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 0);
    //    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shippingadress_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    //    btn.backgroundColor = UIColorFromRGB(0xE4511D);
    btn.tag = 4001;
    
    
//    addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+30, mainScreenWidth, mainScreenHeight-64-30) style:UITableViewStylePlain];
    addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-64-35) style:UITableViewStylePlain];
    addressTableView.delegate = self;
    addressTableView.dataSource = self;
    addressTableView.rowHeight = 70;
    [self.view addSubview:addressTableView];
    
//    NSArray *btnArr = @[@"自取点地址",@"送货地址"];
    getPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getPointBtn.frame = CGRectMake(0, 64, mainScreenWidth/2, 30);
    [getPointBtn setTitle:@"自取点地址" forState:UIControlStateNormal];
    [getPointBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [getPointBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    getPointBtn.tag = 4002;
    [getPointBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:getPointBtn];
    getPointBtn.backgroundColor = [UIColor whiteColor];
//    getPointBtn.selected = YES;

    sendPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendPointBtn.frame = CGRectMake(mainScreenWidth/2+1, 64, mainScreenWidth/2, 30);
    [sendPointBtn setTitle:@"送货地址" forState:UIControlStateNormal];
    [sendPointBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sendPointBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    sendPointBtn.tag = 4003;
    sendPointBtn.selected = YES;
    [sendPointBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sendPointBtn];
//    sendPointBtn.backgroundColor = [UIColor whiteColor];
    

    selectView = [[UIView alloc] initWithFrame:CGRectMake(25, 92, mainScreenWidth/2-50, 2)];
    selectView.backgroundColor = UIColorFromRGB(0xE4511D);
//    [self.view addSubview:selectView];
    

    
}
//-(void)addNewAddress{
//    NSLog(@"addNewAddress");
//}
-(void)cellBtnClick:(UIButton *)button{
//    button.selected = !button.selected;
//    AddressModel *addModel = [addressData objectAtIndex:button.tag];
//    if ([self.addressDelegate respondsToSelector:@selector(selectAddress:)]) {
//        [self.addressDelegate selectAddress:addModel];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -----tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return addressData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity =@"cellId";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (nil == cell) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    AddressModel *model = [addressData objectAtIndex:indexPath.row];
    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.phone;
    cell.addressLabel.text = model.address;
    if ([model.moren isEqualToString:@"1"]) {
        cell.selectBtn.selected = YES;
        [cell.selectBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    }else{
        [cell.selectBtn setTitle:@"" forState:UIControlStateNormal];
    }
    [cell.selectBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    if ([fathType isEqualToString:@"1"]) {
//        cell.selectBtn.hidden = YES;
//    }
    cell.selectBtn.tag = indexPath.row;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (getPointBtn.selected) {
        return;
    }
    AddressModel *model = [addressData objectAtIndex:indexPath.row];
    AddNewAddressViewController *avc = [[AddNewAddressViewController alloc] init];
    avc.model = model;
    avc.userType = @"0";
    
    NSLog(@"type = %@",fathType);
//    if ([fathType isEqualToString:@"3"]) {
//        avc.userType = fathType;
//    }
    [self.navigationController pushViewController:avc animated:YES];
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
