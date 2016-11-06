//
//  MyLocationListViewController.m
//  FreshMan
//
//  Created by Jie on 15/11/11.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "MyLocationListViewController.h"
#import "LoginViewController.h"
#import "AnnotationModel.h"
#import "AreaModel.h"
#import "AreaCell.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "MyLocationViewController.h"

@interface MyLocationListViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    UILabel *areaLab;
    NSMutableArray *areaArr;
    NSMutableArray *pointArr;
    UITableView *areaTableView;
    UITableView *pointTableView;
    int select;//所选区域；
    CLLocationManager *locationManager;

    double  logi;
    double  lati;
    BOOL    isLocation;
}

@end

@implementation MyLocationListViewController
@synthesize defaultModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    defaultModel = [[AnnotationModel alloc] init];
    areaArr = [[NSMutableArray alloc] init];
    pointArr = [[NSMutableArray alloc] init];
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            if (nil == locationManager)
                locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.distanceFilter = 10;
            if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
            {
                [locationManager requestWhenInUseAuthorization];// 前台定位
                [locationManager requestAlwaysAuthorization];// 前后台同时定位
            }
            [locationManager startUpdatingLocation];
            isLocation = YES;
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            NSLog(@"定位功能不可用，提示用户或忽略");
            isLocation = NO;
            [self getData];
            
    }
    
    
    [self buileView];
    
}

//对视图进行初始化
-(void)buileView{
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"自取点确定";
    titleLab.textColor = [UIColor whiteColor];
    [navBarView addSubview:titleLab];
    titleLab.textAlignment = 1;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(mainScreenWidth-44, 20, 44, 44);
//    [rightBtn setImage:[UIImage imageNamed:@"point_area"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:rightBtn];
    
    //底部选择视图
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight-44, mainScreenWidth, 44)];
    barView.backgroundColor = UIColorFromRGB(0x66c1b1);
    //    barView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:barView];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 12, 44 )];
    locationIcon.image = [UIImage imageNamed:@"position_nav"];
    [barView addSubview:locationIcon];
    
    areaLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 220, 20)];
    areaLab.text = @"选择                                为取货点";
    areaLab.font = FONTSIZE4;
    [barView addSubview:areaLab];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = UIColorFromRGB(0x519d90);
    [buyBtn setTitle:@"确定" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FONTSIZE3;
    buyBtn.frame = CGRectMake(mainScreenWidth/2+100, 0, mainScreenWidth/2-100, 44);
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:buyBtn];
    
    //表示地区列表
    areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 90, mainScreenHeight-64-44) style:UITableViewStylePlain];
    areaTableView.delegate = self;
    areaTableView.dataSource = self;
    areaTableView.rowHeight = 60;
//    areaTableView.tag = 1000;
    [self.view addSubview:areaTableView];
    areaTableView.bounces = NO;
    areaTableView.backgroundColor = [UIColor clearColor];
//    areaTableView 
//
    //表示具体地点列表
    pointTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 64, mainScreenWidth-90, mainScreenHeight-64-40) style:UITableViewStylePlain];
    pointTableView.dataSource = self;
    pointTableView.delegate = self;
    pointTableView.rowHeight = 60;
//    pointTableView.tag = 1001;
    [self.view addSubview:pointTableView];
    

}
#pragma mark ----TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    for (int i = 0 ;i < pointArr.count; i ++) {
//        AnnotationModel *md = [pointArr objectAtIndex:i];
//        NSLog(@"i = %@",md.name);
//    }
    
    if ([tableView isEqual:areaTableView]) {
        
        NSLog(@"areaArr:%ld",areaArr.count);
        return areaArr.count;
    }else{
        return pointArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //判断显示那个列表
    if ([tableView isEqual:areaTableView]) {
        static NSString *cellID1 = @"cellid1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        cell.backgroundColor = [UIColor clearColor];
        AreaModel *md = [areaArr objectAtIndex:indexPath.row];
        cell.textLabel.text = md.name;
        
        return cell;
    }else{
        static NSString *cellID2 = @"cellid2";
        AreaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (cell == nil) {
            cell = [[AreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
        }
        
        cell.locationBtn.tag = indexPath.row;
        [cell.locationBtn addTarget:self action:@selector(toCurrentView:) forControlEvents:UIControlEventTouchUpInside];
        
        AnnotationModel *amd = [pointArr objectAtIndex:indexPath.row];
//        cell.textLabel.text = amd.name;
        [cell setModel:amd];
        
        return cell;
        
    }
//    return nil;
}

//跳转页面
-(void)toCurrentView:(UIButton *)button{
    
    NSLog(@"数据:%d",button.tag);
    AnnotationModel *model = [pointArr objectAtIndex:button.tag];
    defaultModel = model;
    [[AppUtils shareAppUtils] saveAddress:defaultModel];
    areaLab.text = [NSString stringWithFormat:@"选择：%@ 为取货点",model.name];
    MyLocationViewController *myLocationVC = [[MyLocationViewController alloc] init];
    [self.navigationController pushViewController:myLocationVC animated:YES];
}

//根据经纬度计算二个地点的距离
-(double)distanceBetweenOrderBy:(double)lat2 :(double)lng2{
    NSLog(@"%f|%f",lat2,lng2);
    
    double dd = M_PI/180;
    double x1=lati*dd,x2=lat2*dd;
    double y1=logi*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    //km  返回
    if (isLocation==NO) {
        return 0;
    }
    return distance/1000;
    //返回 m
//    return distance;

}

//点击地区列表或者地方列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:areaTableView]) {
        AreaModel *md = [areaArr objectAtIndex:indexPath.row];
        pointArr = md.areaArray;
        NSLog(@"这是个什么东西:%@",md.areaArray);
        [pointTableView reloadData];
    }else{
        
        //除去点击之后的阴影部分
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        AnnotationModel *model = [pointArr objectAtIndex:indexPath.row];
        defaultModel = model;
        NSLog(@"地点:%@",model.address);
        areaLab.text = [NSString stringWithFormat:@"选择：%@ 为取货点",model.name];
//        MyLocationViewController *mlv = [[MyLocationViewController alloc] init];
//        [self.navigationController pushViewController:mlv animated:YES];

    }
}
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)rightBtnClick{
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
    NSArray *arr= [NSArray arrayWithObjects:model.name, model.time,model.address, nil];
    for (int i = 0; i < arr.count; i++) {
        UILabel *lab = (UILabel *)[self.view viewWithTag:1000+i];
        lab.text = [arr objectAtIndex:i];
    }
    defaultModel = model;
    areaLab.text = [NSString stringWithFormat:@"选择：%@ 为取货点",model.name];
}
#pragma mark 定位delegeate
//定位时调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = locations[0];
    logi = newLocation.coordinate.longitude;
    lati = newLocation.coordinate.latitude;
    [locationManager stopUpdatingLocation];
    [self getData];
}
-(void)getData{//获取
//    [[AppUtils shareAppUtils] saveAddress:defaultModel];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:defaultModel.annotationID, @"id",[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    
    //发出网络请求获取数据
    [[FMNetWorkManager sharedInstance] requestURL:GET_DISTRICT_LIST httpMethod:@"POST" parameters:nil success:^(NSURLSessionDataTask * task, id responseObject) {
//        NSLog(@"response%@",responseObject);        
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            
            //清除以前的数据，清空数组
            [areaArr removeAllObjects];

            NSLog(@"服务器请求的数据:%@",responseObject);
            
            NSMutableArray *tmpArr = [responseObject objectForKey:@"district"];
            for (int i = 0; i < tmpArr.count; i++) {
                NSMutableArray *ptArray = [[tmpArr objectAtIndex:i] objectForKey:@"zitidian"];
                NSMutableArray *ptA = [[NSMutableArray alloc] init];
                //排序前距离数组，距离数组，排序后数组
                NSMutableArray *distanceMutableArray = [[NSMutableArray alloc] init];
                NSMutableArray *pXFirstMutableArray = [[NSMutableArray alloc] init];
                NSMutableArray *pXSecondMutableArray = [[NSMutableArray alloc] init];
                
                for (int j = 0; j < ptArray.count; j++) {
                    
                    NSString *coordinateY = [[ptArray objectAtIndex:j] objectForKey:@"coordinate_y"];
                    NSString *coordinateX = [[ptArray objectAtIndex:j] objectForKey:@"coordinatex_x"];
                    
                    //表示二个点之间的距离
                    double dis = [self distanceBetweenOrderBy:[coordinateY doubleValue] :[coordinateX doubleValue]];
                    
                    NSLog(@"dis = %f",dis);
                    [distanceMutableArray addObject:[NSString stringWithFormat:@"%f",dis]];
                    [pXFirstMutableArray addObject:[NSString stringWithFormat:@"%f",dis]];
                }
                
                [self paiXuArray:distanceMutableArray];
                //排序后
                pXSecondMutableArray = distanceMutableArray;
                
                NSLog(@"第一个数组:%@",pXFirstMutableArray);
                NSLog(@"第二个数组:%@",pXSecondMutableArray);
                
                for (int g = 0; g < distanceMutableArray.count; g++) {
                    
                    NSLog(@"tmp = %@",[[ptArray objectAtIndex:g] objectForKey:@"name"]);
                    NSString *flagStr = [pXSecondMutableArray objectAtIndex:g];
                    for (int k = 0; k<[distanceMutableArray count]; k++) {
                        
                        if ([flagStr isEqualToString:[pXFirstMutableArray objectAtIndex:k]]) {
                            
                            NSLog(@"k的值:%i",k);
                            
                            AnnotationModel *model = [[AnnotationModel alloc] init];
                            model.name = [[ptArray objectAtIndex:k] objectForKey:@"name"];
                            
                            NSLog(@"自取点的名字:%@",model.name);
                            
                            model.coordinateY = [[ptArray objectAtIndex:k] objectForKey:@"coordinate_y"];
                            model.coordinateX = [[ptArray objectAtIndex:k] objectForKey:@"coordinatex_x"];
                            model.annotationID = [[ptArray objectAtIndex:k] objectForKey:@"id"];
                            model.address = [[ptArray objectAtIndex:k] objectForKey:@"address"];
                            model.phone = [[ptArray objectAtIndex:k] objectForKey:@"phone"];
                            model.staff = [[ptArray objectAtIndex:k] objectForKey:@"staff"];
                            model.time = [[ptArray objectAtIndex:k] objectForKey:@"time"];
                            
                            double dis = [flagStr doubleValue];
                            if (dis > 98) {
                                model.distance = @"-1";
                            }else if (dis == 0){
                                model.distance = @"-2";
                            }else{
                                model.distance = [NSString stringWithFormat:@"距离您:%.1fkm",dis];
                            }
                                                
                            [ptA addObject:model];
                        }
                    }
                    
                    
                    
                    NSLog(@"模型:%@",ptA);
                    
                }
                
                AreaModel *amodel = [[AreaModel alloc] init];
                amodel.name = [[tmpArr objectAtIndex:i] objectForKey:@"name"];
                amodel.areaID = [[tmpArr objectAtIndex:i] objectForKey:@"id"];
                amodel.areaArray = [NSMutableArray arrayWithArray:ptA];
                [areaArr addObject:amodel];
            }
            
            pointArr = [[areaArr objectAtIndex:1] areaArray];
            
            NSLog(@"这是个什么东西 = %@",[areaArr objectAtIndex:1]);
            
            NSLog(@"pointAprr = %@",pointArr);
//            [self leftBtnClick];
            [areaTableView reloadData];
            [pointTableView reloadData];
            NSIndexPath *first = [NSIndexPath indexPathForRow:1 inSection:0];
            [areaTableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
            
        }else if ([status isEqualToString:@"5"]){
            LoginViewController * loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            [self.navigationController pushViewController:loginView animated:YES];
            //            [self showAlt:@"您还没有登录"];
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}

//进行数组的排序
- (void)paiXuArray:(NSMutableArray *)mutableArray{
    
    [mutableArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *a = (NSString *)obj1;
        NSString *b = (NSString *)obj2;
        
        double aNum = [[a substringFromIndex:0] doubleValue];
        double bNum = [[b substringFromIndex:0] doubleValue];
        
        if (aNum > bNum) {
            return NSOrderedDescending;
        }
        else if (aNum < bNum){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
}


//确定按钮
-(void)buyBtnClick{//提交
    [[AppUtils shareAppUtils] saveAddress:defaultModel];
    
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:defaultModel.annotationID, @"id",[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:SAVE_GETPOINT httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        //        NSMutableArray *adArr = [responseObject objectForKey:@"subject"];
        if ([status isEqualToString:@"1"]) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            NSArray * ctrlArray = self.navigationController.viewControllers;
            NSLog(@"所有的视图控制器:%@",ctrlArray);
            
            //有待修改会导致程序崩溃
            [self.navigationController popToViewController:[ctrlArray objectAtIndex:ctrlArray.count-2] animated:YES];
        }else if ([status isEqualToString:@"5"]){
            LoginViewController * loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            [self.navigationController pushViewController:loginView animated:YES];
            //            [self showAlt:@"您还没有登录"];
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
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
