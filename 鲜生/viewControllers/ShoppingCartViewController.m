//
//  ShoppingCartViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "FMNetWorkManager.h"
#import "MBProgressHUD.h"
#import "AlipaySDK/AlipaySDK.h"
#import "PayOrderViewController.h"
#import "LoginViewController.h"
@interface ShoppingCartViewController ()<UIAlertViewDelegate>{
    MBProgressHUD *hud;
    UILabel *totalPriceLab;
    NSMutableArray *selectArray;
    UIButton *selectAll;
    UIView *nullView;
    BOOL flag;
}

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag = true;
    
    selectArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.mTableView.frame = CGRectMake(self.mTableView.frame.origin.x, self.mTableView.frame.origin.y, self.mTableView.frame.size.width, self.mTableView.frame.size.height-100);
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(mainScreenWidth-60, 20, 60, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];

    
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight-49-44, mainScreenWidth, 44)];
//    barView.backgroundColor = UIColorFromRGB(0xffffff);
    barView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:barView];
    
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectAll setImage:[UIImage imageNamed:@"cart_not_selected"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    selectAll.titleLabel.font = FONTSIZE4;
    selectAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    selectAll.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [selectAll setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    selectAll.frame = CGRectMake(0, 0, 69.5, 44);
    [barView addSubview:selectAll];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    selectAll.tag = 2001;
    
//    UILabel *seleceAllLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2-30, 12, 50, 20)];
//    seleceAllLab.text = @"合计:  ¥";
//    seleceAllLab.font = FONTSIZE3;
//    [barView addSubview:seleceAllLab];
    
    
    
    UILabel *totalLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2-30, 12, 70, 20)];
    totalLab.text = @"合计:  ¥";
    totalLab.font = [UIFont systemFontOfSize:14.0];
    [barView addSubview:totalLab];
//    totalLab.backgroundColor = [UIColor redColor];
    totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2+20, 12, 50, 20)];
    totalPriceLab.text = @"0.00";
    totalPriceLab.font = FONTSIZE3;
    totalPriceLab.textColor = [UIColor orangeColor];
    [barView addSubview:totalPriceLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = UIColorFromRGB(0xee751b);
    [buyBtn setTitle:@"结算" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FONTSIZE3;
    buyBtn.frame = CGRectMake(mainScreenWidth/2+100, 0, mainScreenWidth/2-100, 44);
    [barView addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.tag = 2000;
    
    
    
    nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-64-49)];
    [self.view addSubview:nullView];
    nullView.backgroundColor = [UIColor whiteColor];
    UIImageView *nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (nullView.frame.size.height-mainScreenWidth)/2, mainScreenWidth, mainScreenWidth/750*622)];
    nullImageView.image = [UIImage imageNamed:@"空的购物车.jpg"];
    [nullView addSubview:nullImageView];
    nullImageView.userInteractionEnabled = YES;
    nullView.userInteractionEnabled = YES;
    
    
    UIButton *goShopping = [UIButton buttonWithType:UIButtonTypeCustom];

    goShopping.frame = CGRectMake(100, mainScreenWidth/750*507, mainScreenWidth-200, 60);
    [nullImageView addSubview:goShopping];
    [goShopping addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    goShopping.tag = 2002;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)editBtnClick:(UIButton *)button{
    if (button.selected) {
        button.selected = NO;
        self.mTableView.editing = NO;
    }else{
        button.selected = YES;
        self.mTableView.editing = YES;
    }
}
-(void)getShoppingData{
    NSError *error;
    NSArray *data = (NSArray *)[[AppUtils shareAppUtils] getShoppingCarGood];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:data,@"project", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    [[FMNetWorkManager sharedInstance] requestURL:GET_SHOPPINGCAR_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSMutableArray* response = (NSMutableArray*)[responseObject objectForKey:@"product"];
        [dataArray removeAllObjects];
        float totalPri = 0.00;
        if (response.count > 0) {
            nullView.hidden = YES;
        }else{
            nullView.hidden = NO;
        }
        
        for (int i = 0; i < response.count; i++) {
            GoodModel *model = [[GoodModel alloc] init];
            model.goodId = [[response objectAtIndex:i] objectForKey:@"id"];
            model.goodName = [[response objectAtIndex:i] objectForKey:@"name"];
            model.goodPicUrl = [[response objectAtIndex:i] objectForKey:@"pic"];
            model.goodPrice = [[response objectAtIndex:i] objectForKey:@"price"];
            model.goodNumber = [[data objectAtIndex:i] objectForKey:@"amount"];
            model.goodPid = [[data objectAtIndex:i] objectForKey:@"pid"];
            model.marketPrice = [[response objectAtIndex:i] objectForKey:@"market_price"];
            model.select =  NO;
            //            totalPriceLab.text =
            float price = [model.goodPrice floatValue];
            float count = [model.goodNumber intValue];
            
            totalPri = totalPri + price*count;
            NSString *isIn = [NSString stringWithFormat:@"%@",[[response objectAtIndex:i] objectForKey:@"is_in"]];
            if ([isIn isEqualToString:@"1"]) {
                [dataArray addObject:model];
                
            }
        }
        totalPriceLab.text = [NSString stringWithFormat:@"0.00"];
        [self.mTableView reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        [dataArray removeAllObjects];
        [self.mTableView reloadData];
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self getShoppingData];
    selectAll.selected = NO;
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jiesuan{
    
    float pri = [totalPriceLab.text floatValue];
    if (pri <= 0) {
        [self showAlt:@"请添加商品"];
        return;
    }
    
    
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    NSMutableArray *data = (NSMutableArray *)[[AppUtils shareAppUtils] getShoppingCarGood];
//    NSLog(@"data = %@ type = %@",data,data.class);
//    NSLog(@"dataArr = %@ type = %d",dataArray,dataArray.count);
    
    for (int i = 0; i < dataArray.count; i++) {
        GoodModel *mod = [dataArray objectAtIndex:i];
//        NSLog(@"model = %hhd name = %@  id = %@",mod.select,mod.goodName,mod.goodPid);

        if (mod.select) {
            [arr1 addObject:mod];
            for (int j = 0; j < data.count; j++) {
                NSMutableDictionary *dic  = [data objectAtIndex:j];
                if ([mod.goodPid isEqualToString:[dic objectForKey:@"pid"]]) {
                    [arr2 addObject:dic];
                }
            }
        }
    }
    NSLog(@"data = %@",data);
    NSLog(@"dataarr = %@",dataArray);
 
    //跳转确认订单页面
    PayOrderViewController *pvc = [[PayOrderViewController alloc] init];
    pvc.totalPrice = totalPriceLab.text;
    pvc.orderArray = arr2;
    pvc.dataArray = arr1;
    [self.navigationController pushViewController:pvc animated:YES];

}
-(void)selectAllBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    float totalPri = 0.00;

    for (int i = 0; i < dataArray.count; i++) {
        GoodModel *model = [dataArray objectAtIndex:i];
        model.select = button.selected;
        [dataArray replaceObjectAtIndex:i withObject:model];
        float price = [model.goodPrice floatValue];
        float count = [model.goodNumber intValue];
        totalPri = totalPri + price*count;
    }
    if (button.selected) {
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
    }else{
        totalPriceLab.text = [NSString stringWithFormat:@"0.00"];

    }
    [self.mTableView reloadData];
}
-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 2000:
            [self jiesuan];
            break;
            
        case 2002:
            [self backToRootViewControllerWithType:INDEX_SHOPPING_CENTER];
            break;
            
        default:
            break;
    }
}

//改变勾选状态
- (void)changeState:(UIButton *)button{

    selectAll.selected = NO;
    GoodModel *selectModel = [dataArray objectAtIndex:button.tag];
    selectModel.select = !selectModel.select;
    [dataArray replaceObjectAtIndex:button.tag withObject:selectModel];
    [self.mTableView reloadData];
    if (selectModel.select) {
        float totalPri = [totalPriceLab.text floatValue];
        float price = [selectModel.goodPrice floatValue];
        int selectNumber = [selectModel.goodNumber intValue];
        
        totalPri = totalPri+price*selectNumber;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
    }else{
        float totalPri = [totalPriceLab.text floatValue];
        float price = [selectModel.goodPrice floatValue];
        int selectNumber = [selectModel.goodNumber intValue];
        
        totalPri = totalPri-price*selectNumber;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
        
    }
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
    [dataArray replaceObjectAtIndex:button.tag-4000 withObject:model];
    [self.mTableView reloadData];
    [[AppUtils shareAppUtils] changeGoodNumber:1 andModel:model];
    
    if (model.select) {
        float totalPri = [totalPriceLab.text floatValue];
        float price = [model.goodPrice floatValue];
        totalPri = totalPri+price;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
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
    [dataArray replaceObjectAtIndex:button.tag-4000 withObject:model];
    [self.mTableView reloadData];
    [[AppUtils shareAppUtils] changeGoodNumber:-1 andModel:model];
    if (model.select) {
        float totalPri = [totalPriceLab.text floatValue];
        float price = [model.goodPrice floatValue];
        totalPri = totalPri-price;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];

    }


}

-(void)buy:(UIButton *)button{
    NSLog(@"buy = %ld",(long)button.tag);
    
}
-(void)deleteCell:(UIButton *)button{

}
#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(mainScreenWidth-210, 50)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* FVCellString = @"cellstring";
    ShoppingCartTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:FVCellString];
    if (!cell) {
        cell = [[ShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FVCellString];
    }
//    NSLog(@"%f %f",cell.textLabel.frame.size.height,cell.detailTextLabel.frame.size.height);
    GoodModel *model = [dataArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodPicUrl] placeholderImage:[UIImage imageNamed:@"测试1.png"]];
    cell.nameLabel.text = model.goodName;
    cell.priceLab.text = [NSString stringWithFormat:@"¥%@/份",model.goodPrice];
    cell.numberLab.text = model.goodNumber;
    float oneTotlePrice = [model.goodPrice floatValue]*[model.goodNumber intValue];
    cell.totolPriceLab.text = [NSString stringWithFormat:@"总计:%.2f元",oneTotlePrice];

    CGSize size = [self sizeWithString:model.goodName font:FONTSIZE3];
    cell.nameLabel.frame = CGRectMake(138, 20, size.width, size.height);
    
    cell.addBtn.tag = indexPath.row;
    cell.selectBtn.tag = indexPath.row;
    if (model.select) {
//        cell.selectView.backgroundColor = UIColorFromRGB(0xE55836);
        cell.selectBtn.selected = YES;
   }else{
//        cell.selectView.backgroundColor = [UIColor clearColor];
       cell.selectBtn.selected = NO;
    }
    
    
    if ([self isBlankString:model.marketPrice] || [model.marketPrice isEqualToString:@"0"]) {
        cell.marketPriceLab.text = [NSString stringWithFormat:@"暂无市场价"];
    }else{
        cell.marketPriceLab.text = [NSString stringWithFormat:@"市场价:¥%@",model.marketPrice];
    }
    
    //都选框添加点击方法
    [cell.selectBtn addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    
    //加减按钮与方法
    [cell.addBtn addTarget:self action:@selector(changeGoodAccountAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.subBtn.tag = indexPath.row;
    
    [cell.subBtn addTarget:self action:@selector(changeGoodAccountSub:) forControlEvents:UIControlEventTouchUpInside];
    int number = [model.goodNumber intValue];
    if (number < 2) {
        cell.subBtn.enabled = NO;
    }else{
        cell.subBtn.enabled = YES;
    }
    cell.delegate = self;

    cell.indexPath = indexPath;

    cell.addBtn.tag = indexPath.row+4000;
//    [cell.addBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.subBtn.tag = indexPath.row+4000;
//    [cell.subBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectAll.selected = NO;
    GoodModel *selectModel = [dataArray objectAtIndex:indexPath.row];
    selectModel.select = !selectModel.select;
    [dataArray replaceObjectAtIndex:indexPath.row withObject:selectModel];
    [self.mTableView reloadData];
    if (selectModel.select) {
        float totalPri = [totalPriceLab.text floatValue];
        float price = [selectModel.goodPrice floatValue];
        int selectNumber = [selectModel.goodNumber intValue];
        
        totalPri = totalPri+price*selectNumber;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
    }else{
        float totalPri = [totalPriceLab.text floatValue];
        float price = [selectModel.goodPrice floatValue];
        int selectNumber = [selectModel.goodNumber intValue];
        
        totalPri = totalPri-price*selectNumber;
        totalPriceLab.text = [NSString stringWithFormat:@"%.2f",totalPri];
        
    }
    

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GoodModel *model = [dataArray objectAtIndex:indexPath.row];
        NSLog(@"mode id = %@",model.goodPid);
        [[AppUtils shareAppUtils] deleteOneGood:model];
        [dataArray removeObjectAtIndex:indexPath.row];
        [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag >= 3000) {
        if (buttonIndex == 1) {
            GoodModel *model = [dataArray objectAtIndex:alertView.tag-3000];
            NSLog(@"mode id = %@",model.goodPid);
            [[AppUtils shareAppUtils] deleteOneGood:model];
            [self getShoppingData];
        }
    }
}
-(void)btnPress:(NSIndexPath *)indexPath andFunction:(NSString *)function{
    NSLog(@"%ld行 去%@",(long)indexPath.row,function);

    if ([function isEqualToString:@"结算"]) {
        if (![[ AppUtils shareAppUtils] getIsLogin]) {
            LoginViewController* loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            loginView.typeString = @"全部订单";
            [self.navigationController pushViewController:loginView animated:YES];
            return;
        }
        GoodModel *model = [dataArray objectAtIndex:indexPath.row];

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

    }else if ([function isEqualToString:@"删除"]){
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"您确定删除此果蔬？"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"取消",@"确定", nil];
        alt.delegate = self;
        alt.tag = 3000+indexPath.row;
        [alt show];

    }
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
