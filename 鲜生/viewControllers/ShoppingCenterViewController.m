//
//  ShoppingCenterViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ShoppingCenterViewController.h"
#import "GoodViewController.h"
#import "GoodViewNewViewController.h"
#import "FMNetWorkManager.h"
#import "GoodModel.h"
#import "GoodDetailViewController.h"
@interface ShoppingCenterViewController ()<UIAlertViewDelegate>{
    NSString *shopType;
    NSMutableArray *menuIconArray;
    NSMutableArray *menuSelectIconArray;
//    NSInteger selectType;
    UIView *nullView;
}

@end

@implementation ShoppingCenterViewController
-(void)getFirstDataWithType:(NSString *)type{
    [MBProgressHUD showHUDAddedTo:self.goodTableView animated:YES];
    self.menuTableView.userInteractionEnabled = NO;
    if ([type isEqualToString:@"2"]) {
        [[FMNetWorkManager sharedInstance] requestURL:GET_GOODS_ONSALE httpMethod:@"POST" parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
            NSLog(@"response%@",responseObject);
            self.menuTableView.userInteractionEnabled = YES;

            [MBProgressHUD hideAllHUDsForView:self.goodTableView animated:YES];
            NSMutableArray* response = (NSMutableArray*)[responseObject objectForKey:@"product"];
            NSLog(@"返回的数据:%@",response);
            [dataArray removeAllObjects];
            for (int i = 0; i < response.count; i++) {
                GoodModel *model = [[GoodModel alloc] init];
                model.goodId = [[response objectAtIndex:i] objectForKey:@"id"];
                model.goodName = [[response objectAtIndex:i] objectForKey:@"name"];
                model.goodPicUrl = [[response objectAtIndex:i] objectForKey:@"pic"];
                model.goodPid = [[response objectAtIndex:i] objectForKey:@"pid"];
//                model.goodId = [[[response objectAtIndex:i] objectAtIndex:0] objectForKey:@"id"];
//                model.goodName = [[[response objectAtIndex:i] objectAtIndex:0] objectForKey:@"name"];
//                model.goodPicUrl = [[[response objectAtIndex:i] objectAtIndex:0] objectForKey:@"pic"];
//                model.goodPid = [[[response objectAtIndex:i] objectAtIndex:0] objectForKey:@"pid"];
                [dataArray addObject:model];
            }
            [self.goodTableView reloadData];
        }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            NSLog(@"Error: %@", error);
            self.menuTableView.userInteractionEnabled = YES;
            [MBProgressHUD hideAllHUDsForView:self.goodTableView animated:YES];
            [dataArray removeAllObjects];
            [self.goodTableView reloadData];
            
        }];
        return;
    }
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type", nil];
    [[FMNetWorkManager sharedInstance] requestURL:GET_GOODS_Catagory httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        self.menuTableView.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.goodTableView animated:YES];
        NSMutableArray* response = (NSMutableArray*)[responseObject objectForKey:@"product"];
        [dataArray removeAllObjects];
        for (int i = 0; i < response.count; i++) {
            GoodModel *model = [[GoodModel alloc] init];
            model.goodId = [[response objectAtIndex:i] objectForKey:@"id"];
            model.goodName = [[response objectAtIndex:i] objectForKey:@"name"];
            model.goodPicUrl = [[response objectAtIndex:i] objectForKey:@"pic"];
            [dataArray addObject:model];
        }
        [self.goodTableView reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        self.menuTableView.userInteractionEnabled = YES;
        [MBProgressHUD hideAllHUDsForView:self.goodTableView animated:YES];
        [dataArray removeAllObjects];
        [self.goodTableView reloadData];

    }];
}
-(void)buttonClick:(UIButton *)button{
    switch (button.tag) {
        case 4000:
            [self backToRootViewControllerWithType:INDEX_HOME];
            break;
        case 4001:
            NSLog(@"add new address") ;
            break;
            
        default:
            break;
    }
}
#pragma mark ------NSNotificationCenter

-(void)goShoppingCenter:(NSNotification *)notification{
    //拿到通知内容。
    NSLog(@"run here");
    NSDictionary *dic = [notification userInfo];
    shopType = [dic objectForKey:@"type"];
    NSIndexPath *index = [NSIndexPath indexPathForRow:[shopType intValue] inSection:0];


    [self tableView:self.menuTableView didSelectRowAtIndexPath:index];
    NSLog(@"index = %d  %d",index.row,index.section);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    shopType = @"0";
    menuIconArray = [[NSMutableArray alloc] initWithObjects:@" fruitIcon.png", @"vegetablesIcon.png", @"activeIcon.png", nil];
    menuSelectIconArray = [[NSMutableArray alloc] initWithObjects:@"fruitafterIcon.png", @"vegetablesafterIcon.png", @"activeafterIcon.png", nil];
    

    [self getFirstDataWithType:shopType];
    dataArray = [[NSMutableArray alloc] init];

//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 20, 44, 44);
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    leftBtn.tag = 4000;
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //竖直的线
    UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(self.menuTableView.frame.size.width-0.5, 44+STATUSBAR_OFFSET , 0.5, self.view.frame.size.height)];
    separatorView.backgroundColor = UIColorFromRGB(0x666666);
    [self.view addSubview:separatorView];
    
    self.goodTableView.delegate = self;
    self.goodTableView.dataSource = self;
    self.goodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goShoppingCenter:) name:@"goShoppingCenter" object:nil];

    
    
    nullView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.menuTableView.frame), 64, mainScreenWidth-CGRectGetMaxX(self.menuTableView.frame), mainScreenHeight-64-49)];
    [self.view addSubview:nullView];
    nullView.backgroundColor = [UIColor whiteColor];
    UIImageView *nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (nullView.frame.size.height-(mainScreenWidth/750*500))/2, mainScreenWidth-CGRectGetMaxX(self.menuTableView.frame), mainScreenWidth/750*500-CGRectGetMaxX(self.menuTableView.frame))];
    nullImageView.image = [UIImage imageNamed:@"特惠商城"];
    [nullView addSubview:nullImageView];
    nullView.hidden = YES;
//    nullImageView.userInteractionEnabled = YES;
//    nullView.userInteractionEnabled = YES;
}


#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return 3;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView) {
        return 200;
    }
    NSInteger itemCount = 3;
    NSInteger row = dataArray.count/itemCount;
    if (dataArray.count % itemCount != 0) {
        row ++;
    }
    CGFloat itemWidth = self.goodTableView.frame.size.width/itemCount;
    return (itemWidth+80)*row;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuTableView){
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((50-24)/2, 100-24, 24, 24)];
        [cell.contentView addSubview:imageView];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 50, 24)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONTSIZE2;
        titleLabel.textColor = UIColorFromRGB(0x999999);
        if (indexPath.row == 0) {
            titleLabel.text = @"水果";
            imageView.image = [UIImage imageNamed:@"fruitIcon.png"];
        }else if (indexPath.row == 1){
            titleLabel.text = @"蔬菜";
            imageView.image = [UIImage imageNamed:@"vegetablesIcon.png"];
        }else if (indexPath.row == 2){
            titleLabel.text = @"活动";
            imageView.image = [UIImage imageNamed:@"activeIcon.png"];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:titleLabel];
        
        UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 200-0.5, 50, 0.5)];
        separatorView.backgroundColor = UIColorFromRGB(0x666666);
        [cell.contentView addSubview:separatorView];
        
        cell.backgroundColor = UIColorFromRGB(0xE6E6E6);
        if([shopType intValue] == indexPath.row){
            imageView.image = [UIImage imageNamed:[menuSelectIconArray objectAtIndex:indexPath.row]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    NSInteger itemCount = 3;
    NSInteger row = dataArray.count/itemCount;
    if (dataArray.count % itemCount != 0) {
        row ++;
    }
    CGFloat itemWidth = self.goodTableView.frame.size.width/itemCount;
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.goodTableView.frame.size.width, (itemWidth+80)*row)];
    headerView.userInteractionEnabled = YES;
    
    //通过算法遍历出所有的图片
    for (NSInteger i = 0 ; i < dataArray.count; i++) {
        GoodModel *model = [dataArray objectAtIndex:i];
        
        UIView* itemView = [[UIView alloc] initWithFrame:CGRectMake(i%itemCount*itemWidth, i/itemCount*(itemWidth+80), itemWidth, itemWidth+80)];
//        itemView.backgroundColor = [UIColor redColor];
        itemView.tag = 300+i;
        
        UITapGestureRecognizer* itemPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemPress:)];
        itemPress.numberOfTapsRequired = 1;
        [itemView addGestureRecognizer:itemPress];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, itemWidth-2*10, itemWidth-2*10)];
        imageView.userInteractionEnabled = YES;
//        imageView.image = [UIImage imageNamed:@"测试1.png"];
        
        //实现图片的异步加载和网络缓存
        [imageView sd_setImageWithURL:model.goodPicUrl placeholderImage:[UIImage imageNamed:@"ios_商场 活动"]];
        [itemView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y+10, itemWidth, 20)];
        label.userInteractionEnabled = YES;
        label.textColor  = UIColorFromRGB(0x999999);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONTSIZE3;
        label.text = model.goodName;
        [itemView addSubview:label];
        
        [headerView addSubview:itemView];
        
    }
    
    [cell.contentView addSubview:headerView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.menuTableView){
//        if (indexPath.row == 2) {
//            nullView.hidden = NO;
//        }else{
//            nullView.hidden = YES;
//        }
//        if (indexPath.row == 2) {
//            self
//        }
        [self getFirstDataWithType:[NSString stringWithFormat:@"%d",indexPath.row]];
        shopType = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self.menuTableView reloadData];

    }
    
}


-(void)itemPress:(UITapGestureRecognizer*)gesture{
    GoodModel *model = [dataArray objectAtIndex:gesture.view.tag-300];
    NSLog(@"pid = %@",model.goodPid);
    NSLog(@"点击了第%ld个果蔬",(long)gesture.view.tag-300);
    if ([shopType isEqualToString:@"2"]) {
        GoodDetailViewController* goodDetailView = [[GoodDetailViewController alloc] init];
        goodDetailView.title = @"果蔬购买";
        goodDetailView.pid = model.goodPid;
        goodDetailView.isZero = @"1";
        [self.navigationController pushViewController:goodDetailView animated:YES];
    }else{
        GoodViewNewViewController* goodListView = [[GoodViewNewViewController alloc] init];
        //    GoodViewController* goodListView = [[GoodViewController alloc] init];
        goodListView.title = model.goodName;
        goodListView.goodId = model.goodId;
        goodListView.goodType = shopType;
        [self.navigationController pushViewController:goodListView animated:YES];

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
