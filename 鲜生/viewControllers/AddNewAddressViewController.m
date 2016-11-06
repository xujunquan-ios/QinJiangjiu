//
//  AddNewAddressViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "AddNewAddressViewController.h"

@interface AddNewAddressViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
//    NSString *name;
//    NSString *address;
//    NSString *phone;
    NSMutableArray *titleArr;
    NSMutableArray *textArr;
    UITableView *maintableView;
    UIButton *selectBtn;
}

@end

@implementation AddNewAddressViewController
@synthesize model,userType;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleArr = [[NSMutableArray alloc] initWithObjects:@"收货人：", @"地   址：", @"电   话：", nil];
    textArr = [[NSMutableArray alloc] initWithObjects:model.name, model.address, model.phone, nil];
    [self getView];
}
-(void)getView{
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touceBackground)];
    [self.view addGestureRecognizer:tapGes];

    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"添加新地址";
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    leftBtn.tag = 4000;
    
    maintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, 150) style:UITableViewStylePlain];
    maintableView.bounces = NO;
    maintableView.delegate = self;
    maintableView.dataSource = self;
    maintableView.rowHeight = 50.0f;
    [self.view addSubview:maintableView];
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(10, CGRectGetMaxY(maintableView.frame)+5, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:@"register_false"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"register_ture"] forState:UIControlStateSelected];
    [self.view addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag = 4001;
    UILabel *selectLab = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(maintableView.frame)+10, 100, 20)];
    selectLab.text = @"设为默认收货地址";
    selectLab.font = FONTSIZE4;
    [self.view addSubview:selectLab];
    if ([model.moren isEqualToString:@"1"]) {
        selectBtn.selected = YES;
    }
    
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(mainScreenWidth/2-100, CGRectGetMaxY(selectBtn.frame) + 20, 200, 40);
    [addBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    addBtn.layer.cornerRadius = 5;
    addBtn.titleLabel.font = FONTSIZE2;
    addBtn.backgroundColor = UIColorFromRGB(0xE4511D);
    addBtn.tag = 4002;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(mainScreenWidth/2-100, CGRectGetMaxY(addBtn.frame)+20, 200, 40);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.titleLabel.font = FONTSIZE2;
    deleteBtn.backgroundColor = UIColorFromRGB(0x666666);
    deleteBtn.tag = 4003;
    
    if ([userType isEqualToString:@"1"]) {
        deleteBtn.hidden = YES;
    }else if ([userType isEqualToString:@"3"]){
        deleteBtn.hidden = YES;
        [addBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
    }
    
}
-(void)touceBackground{
    [[UIApplication sharedApplication].keyWindow endEditing:NO];
    
}
-(void)deleteAddress{
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.addressId,@"aid",[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:DELETE_ADDRESS httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            
//            if ([userType isEqualToString:@"3"]) {
//
//                NSDictionary *dic = [NSDictionary dictionaryWithObject:model forKey:@"address"];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"addressPush" object:self userInfo:dic] ;
//                NSArray * ctrlArray = self.navigationController.viewControllers;
//                [self.navigationController popToViewController:[ctrlArray objectAtIndex:ctrlArray.count-2] animated:YES];
//            }else{
                [self.navigationController popViewControllerAnimated:YES];

//            }

        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
    }];
    
}
-(void)addAddress{
    [self touceBackground];
    if ([self isBlankString:model.name] ||[self isBlankString:model.address] ||[self isBlankString:model.phone]) {
        [self showAlt:@"内容不能为空"];
        return;
    }
    if (![self isTelephone:model.phone]) {
        [self showAlt:@"请输入正确电话号"];
        return;
    }
    NSError *error;
    NSString *moren = @"0";
    if (selectBtn.selected) {
        moren = @"1";
        [[AppUtils shareAppUtils] saveDefaultAddress:model];
    }
    
    NSLog(@"model = %@___｜%@_____｜%@_____｜%@",model.name,model.addressId,model.address,model.phone);
    
    NSDictionary *addDic = [NSDictionary dictionaryWithObjectsAndKeys:model.address, @"address",model.addressId, @"id",model.uid, @"uid",model.name, @"name", model.phone, @"phone", moren, @"acquiescent", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:addDic,@"address",[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    
    
    
    [[FMNetWorkManager sharedInstance] requestURL:SAVE_ADDRESS httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        
        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
//            [self.navigationController popViewControllerAnimated:YES];
//            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
//                [self.delegate UIViewControllerBack:self];
//            }
            
            
            if ([userType isEqualToString:@"3"]) {
                
                NSDictionary *dic = [NSDictionary dictionaryWithObject:model forKey:@"address"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"addressPush" object:self userInfo:dic] ;
                NSArray * ctrlArray = self.navigationController.viewControllers;
                [self.navigationController popToViewController:[ctrlArray objectAtIndex:ctrlArray.count-3] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
    }];
}
-(void)buttonClick:(UIButton *)button{
    
    switch (button.tag) {
        case 4000:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 4001:
            button.selected = !button.selected;
            break;
        case 4002:
            [self addAddress];
            break;
        case 4003:
            [self deleteAddress];
            break;
            
        default:
            break;
    }
}
#pragma mark ----textFeild delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 5000:
            model.name = textField.text;
            break;
        case 5001:
            model.address = textField.text;
            break;
        case 5002:
            model.phone = textField.text;
            break;
            
        default:
            break;
    }
}
#pragma mark ---tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    UITextField *feild = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, mainScreenWidth-100, 30)];
    feild.font = FONTSIZE3;
    feild.delegate = self;
    [cell.contentView addSubview:feild];
    if (indexPath.row == 2) {
        feild.keyboardType = UIKeyboardTypeNumberPad;
    }
    feild.tag = indexPath.row+5000;
    feild.text = [textArr objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    cell.textLabel.font = FONTSIZE2;
    return cell;
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
