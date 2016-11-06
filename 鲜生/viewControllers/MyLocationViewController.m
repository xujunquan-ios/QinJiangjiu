//
//  MyLocationViewController.m
//  FreshMan
//
//  Created by Jie on 15/9/9.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AnnotationModel.h"
#import "MyAnnotation.h"
#import "MyAnnotationView.h"
#import "LoginViewController.h"
#import "MyLocationListViewController.h"
@interface MyLocationViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
    MKMapView *myMapView;
    CLLocationManager *locationManager;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    NSMutableArray *annotationArray;
    
//    UILabel *totalPriceLab;//
    UILabel *showLocationLab;//上部分的地址lab
    UILabel *totalLab;//bar上的地址lab
    
    AnnotationModel *defaultModel;
    
    UILabel *dateLab;//星期几
    UILabel *timeLab1;//上面时间
    UILabel *timeLab2;//下面时间
    UILabel *addressLab;//地址详情
    
}

@end

@implementation MyLocationViewController
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

////选取区域
//-(void)rightBtnClick{
//    MyLocationListViewController *mvc = [[MyLocationListViewController alloc] init];
//    [self.navigationController pushViewController:mvc animated:YES];
//}
-(void)buyBtnClick{
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
            [self toRootView];
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

//点击确认订单的按钮中的定位，或者点击列表中的详细地址
- (void)toRootView{

    NSArray * ctrlArray = self.navigationController.viewControllers;
    NSLog(@"所有的视图控制器:%@",ctrlArray);
    
    //有待修改会导致程序崩溃
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:ctrlArray.count-3] animated:YES];
}

//初始化视图
-(void)buildView{
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
//    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [navBarView addSubview:rightBtn];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight-44, mainScreenWidth, 44)];
        barView.backgroundColor = UIColorFromRGB(0x66c1b1);
//    barView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:barView];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 12, 44 )];
    locationIcon.image = [UIImage imageNamed:@"position_nav"];
    [barView addSubview:locationIcon];
    
    
    totalLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 220, 20)];
    totalLab.text = @"选择                                为取货点";
    totalLab.font = FONTSIZE4;
    [barView addSubview:totalLab];
    //    totalLab.backgroundColor = [UIColor redColor];
//    totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 80, 20)];
//    totalPriceLab.text = @"钱隆学府";
//    totalPriceLab.font = FONTSIZE2_BOLD;
//    totalPriceLab.textColor = [UIColor blackColor];
//    [barView addSubview:totalPriceLab];
    
    //确定按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor = UIColorFromRGB(0x519d90);
    [buyBtn setTitle:@"确定" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = FONTSIZE3;
    buyBtn.frame = CGRectMake(mainScreenWidth/2+100, 0, mainScreenWidth/2-100, 44);
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:buyBtn];
    
//    float funcHeight = mainScreenHeight/750*150;
//    if (mainScreenHeight == 480) {
//        funcHeight = 568*2/750*150-30;
//    }
    
    //？？
    UIView *funcView = [[UIView alloc] initWithFrame:CGRectMake(0, mainScreenHeight-44-120, mainScreenWidth, 120)];
    [self.view addSubview:funcView];
    UIImageView *showlocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 12, 44 )];
    showlocationIcon.image = [UIImage imageNamed:@"position_nav"];
    [funcView addSubview:showlocationIcon];
    showLocationLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 19)];
//    showLocationLab.text = @"您当前选的的提货地点是:天心区，钱隆学府";
    showLocationLab.font = FONTSIZE3_BOLD;
    [funcView addSubview:showLocationLab];
    
    
    UILabel *line1Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, mainScreenWidth, 0.5)];
    line1Lab.backgroundColor = [UIColor lightGrayColor];
    [funcView addSubview:line1Lab];
    
    UILabel *yingyeTime = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 15)];
    yingyeTime.text = @"营业时间";
    yingyeTime.textColor = [UIColor lightGrayColor];
    yingyeTime.font = FONTSIZE4;
    [funcView addSubview:yingyeTime];
    
    dateLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 140, 20)];
    dateLab.text = @"周一至周五";
    dateLab.font = FONTSIZE1_BOLD;
    dateLab.textColor = [UIColor grayColor];
    [funcView addSubview:dateLab];
    
    UILabel *dateDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, mainScreenWidth/2-15, 10)];
    dateDetailLab.text = @"(每天只有两个时间段可自取)";
    dateDetailLab.font = FONTSIZE5;
    dateDetailLab.textColor = [UIColor lightGrayColor];
    [funcView addSubview:dateDetailLab];
    
    timeLab1 = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 35, mainScreenWidth/2, 15)];
    timeLab1.text = @"11:00-12:30";
    timeLab1.font = FONTSIZE1_BOLD;
    timeLab1.textColor = [UIColor orangeColor];
    [funcView addSubview:timeLab1];
    
    timeLab2 = [[UILabel alloc] initWithFrame:CGRectMake(mainScreenWidth/2, 50, mainScreenWidth/2, 15)];
    timeLab2.text = @"17:00-18:30";
    timeLab2.font = FONTSIZE1_BOLD;
    timeLab2.textColor = [UIColor orangeColor];
    [funcView addSubview:timeLab2];
    
    UILabel *line2Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 65+5, mainScreenWidth, 0.5)];
    line2Lab.backgroundColor = [UIColor lightGrayColor];
    [funcView addSubview:line2Lab];
    
    UILabel *ziqudianLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 65+8, 120, 10)];
    ziqudianLab.text = @"自取点地址";
    ziqudianLab.font = FONTSIZE5;
    ziqudianLab.textColor = [UIColor lightGrayColor];
    [funcView addSubview:ziqudianLab];
    
    addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 75+8, mainScreenWidth-30, 15)];
    addressLab.text = @"每天只有两个时间段可自取每天只有两个时间段可自取";
    addressLab.font = FONTSIZE4_BOLD;
    [funcView addSubview:addressLab];
    
    UILabel *line3Lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, mainScreenWidth, 0.5)];
    line3Lab.backgroundColor = [UIColor lightGrayColor];
    [funcView addSubview:line3Lab];
    
    UILabel *xiaotieshiLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 101, mainScreenWidth-30, 19)];
    xiaotieshiLab.text = @"小贴士:需在24小时内把鲜果领回家";
    xiaotieshiLab.font = FONTSIZE5;
    xiaotieshiLab.textColor = [UIColor orangeColor];
    [funcView addSubview:xiaotieshiLab];
    
    
    
    
//    NSArray *arr = [NSArray arrayWithObjects:@"location_near", @"location_time", @"location_detail", nil];
//    NSArray *arr1 = [NSArray arrayWithObjects:@"取货点", @"到货时间", @"自取点位置", nil];
//    for (int i = 0; i < arr.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth*80/750 +i*mainScreenWidth*230/750, 30, mainScreenWidth*130/750, mainScreenWidth*130/750)];
//        imageView.image = [UIImage imageNamed:[arr objectAtIndex:i]];
//        [funcView addSubview:imageView];
//        
//        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-10, imageView.frame.origin.y+mainScreenWidth*130/750-5, imageView.frame.size.width+20, imageView.frame.size.height/1.5)];
//        textLab.text = [arr1 objectAtIndex:i];
//        textLab.font = FONTSIZE4;
//        textLab.numberOfLines = 2;
//        textLab.textAlignment = 1;
//        textLab.tag = 1000+i;
//        [funcView addSubview:textLab];
//        
//    }
    
    
    
    myMapView  = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-64-44-120)];
    [self.view addSubview:myMapView];
    myMapView.mapType = MKMapTypeStandard;
    myMapView.delegate = self;
    
    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
    
    float latitude = [model.coordinateX floatValue];
    float longitude = [model.coordinateY floatValue];
    
    //设置具体位置和显示范围
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude  ,longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    myMapView.showsUserLocation = YES;
    myMapView.region = region;
    
    
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
    
    
    
}
#pragma makr ----location delegate--
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error%@",error);
}

//当用户位置发生改变时调用，获取用户改变后的位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = locations[0];
    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
//    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
//    myMapView.showsUserLocation = YES;
//    myMapView.region = region;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //获取用户的具体位置
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       NSLog(@"%@",error);
                       for (CLPlacemark *place in placemarks) {
                           NSLog(@"name============%@",place.name);//位置名
                           NSLog(@"街道======%@",place.thoroughfare);// 街道
                           NSLog(@"子街道======%@",place.subThoroughfare);//子街道
                           NSLog(@"市======%@",place.locality);//市
                           NSLog(@"区======%@",place.subLocality);//区
                           NSLog(@"国家======%@",place.country);//国家
//                           [locationName setTitle:place.subLocality forState:UIControlStateNormal];
                       }
                   }];
    [locationManager stopUpdatingLocation];
    
}
#pragma mark ---myMapView delegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    [mapView removeAnnotations:mapView.annotations];
}

//区域发生改变
-(void)mapView: (MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{ //已经更改
    [mapView removeAnnotations:mapView.annotations];
    
//    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
//    MyAnnotation *appleStore1 = [[MyAnnotation alloc] init];
//    [appleStore1 setTitle:[dic objectForKey:@"name"]];
//    
//    [appleStore1 setAnnotationType:myMapAnnotationTypePig];
//    [appleStore1 setCoordinate:tmpCoordinate];
//    appleStore1.buttonTag = i;
//    //增加点
//    [myMapView addAnnotation:appleStore1];
    
    
    CGPoint beginPoint = CGPointMake(0, 0);//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D beginMapCoordinate = [myMapView convertPoint:beginPoint toCoordinateFromView:myMapView];
//    NSLog(@"coordinate ==  %f\n%f\n",beginMapCoordinate.longitude,beginMapCoordinate.latitude);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(mapView.frame), CGRectGetMaxY(mapView.frame));//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D endMapCoordinate = [myMapView convertPoint:endPoint toCoordinateFromView:myMapView];
//    NSLog(@"coordinate ==  %f\n%f\n",endMapCoordinate.longitude,endMapCoordinate.latitude);
    
    //区域发生改变时获取点的位置
    [self getData:beginMapCoordinate andEndPoint:endMapCoordinate];
}

////点击自取点的图标，获取具体位置
//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    MyAnnotation *anno = view.annotation;
//    
//    if (anno.buttonTag == 0) {
//        
//        //每次都显示当前位置和你选择的地点，所以取第一个就行
//        AnnotationModel *model = [annotationArray objectAtIndex:0];
//        NSArray *arr= [NSArray arrayWithObjects:model.name, model.time,model.address, nil];
//        for (int i = 0; i < arr.count; i++) {
//            UILabel *lab = (UILabel *)[self.view viewWithTag:1000+i];
//            lab.text = [arr objectAtIndex:i];
//        }
//        defaultModel = model;
//        totalLab.text = [NSString stringWithFormat:@"选择：%@ 为取货点",model.name];
//        showLocationLab.text = [NSString stringWithFormat:@"%@",model.name];
//        addressLab.text = model.address;
//        NSMutableArray *timeArr = (NSMutableArray *)[model.time componentsSeparatedByString:@" "];
//        for (int i = 0; i < 3-timeArr.count; i++) {
//            [timeArr addObject:@""];
//        }
//        dateLab.text =  [timeArr objectAtIndex:0];
//        timeLab1.text = [timeArr objectAtIndex:1];
//        timeLab2.text = [timeArr objectAtIndex:2];
//        
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.coordinateY floatValue]  ,[model.coordinateX floatValue]);
//        
//        //显示范围
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
//        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
//        myMapView.showsUserLocation = YES;
//        myMapView.region = region;
//        
//        [[AppUtils shareAppUtils] saveAddress:model];
//    }
//    
//    NSLog(@"怎么回事");
//}

//区域发生改变时获取点的位置
-(void)getData:(CLLocationCoordinate2D)beginPoint andEndPoint:(CLLocationCoordinate2D)endPoint{
    NSError *error;
    NSString *beginPonintX = [NSString stringWithFormat:@"%.6f",beginPoint.longitude];
    NSString *beginPonintY = [NSString stringWithFormat:@"%.6f",beginPoint.latitude];
    NSString *endPonintX = [NSString stringWithFormat:@"%.6f",endPoint.longitude];
    NSString *endPonintY = [NSString stringWithFormat:@"%.6f",endPoint.latitude];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:beginPonintX ,@"x_1" , endPonintX ,@"x_2" , beginPonintY ,@"y_1" , endPonintY,@"y_2" , nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_SHOP_LOCATION httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        NSMutableArray *adArr = [responseObject objectForKey:@"subject"];
        if ([status isEqualToString:@"1"]) {
            [annotationArray removeAllObjects];
            for (int i = 0; i < adArr.count; i ++) {
                NSDictionary *dic = [adArr objectAtIndex:i];
                
                //判断是否和选取的位置一样
                AnnotationModel *model1 = [[AppUtils shareAppUtils] getAddress];
                
                if ([model1.coordinateX isEqualToString:[dic objectForKey:@"coordinate_y"]]) {
                    
                    float latitude = [[dic objectForKey:@"coordinate_y"]  floatValue];
                    float longitude = [[dic objectForKey:@"coordinatex_x"] floatValue];
                    CLLocationCoordinate2D tmpCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    //                NSLog(@"coord = %f\n\n%f\n\n",tmpCoordinate.longitude,tmpCoordinate.latitude);
                    MyAnnotation *appleStore1 = [[MyAnnotation alloc] init];
                    [appleStore1 setTitle:[dic objectForKey:@"name"]];
                    
                    [appleStore1 setAnnotationType:myMapAnnotationTypePig];
                    [appleStore1 setCoordinate:tmpCoordinate];
                    appleStore1.buttonTag = 0;
                    //增加点
                    [myMapView addAnnotation:appleStore1];
                    AnnotationModel *model = [[AnnotationModel alloc] init];
                    model.name = [dic objectForKey:@"name"];
                    model.coordinateY = [dic objectForKey:@"coordinate_y"];
                    model.coordinateX = [dic objectForKey:@"coordinatex_x"];
                    model.annotationID = [dic objectForKey:@"id"];
                    model.address = [dic objectForKey:@"address"];
                    model.phone = [dic objectForKey:@"phone"];
                    model.staff = [dic objectForKey:@"staff"];
                    model.time = [dic objectForKey:@"time"];
                    [annotationArray addObject:model];
                }
                
            }
            
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}

//所有点视图的绘制
- (MyAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MyAnnotationView *annotationView = nil;
        MyAnnotation *myAnnotation = (MyAnnotation *)annotation;
//        NSLog(@"----%d",myAnnotation.annotationType);
        NSString *identifier = @"Pig";
        MyAnnotationView *newAnnotationView = (MyAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (nil == newAnnotationView) {
            newAnnotationView = [[MyAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
        }
        annotationView = newAnnotationView;
        [annotationView setEnabled:YES];
        [annotationView setCanShowCallout:YES];
        return annotationView;
        
    }
    return nil;
}

//视图将会出现的时候从AnnotationModel中获取地址详细信息
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
    NSArray *arr= [NSArray arrayWithObjects:model.name, model.time,model.address, nil];
    for (int i = 0; i < arr.count; i++) {
        UILabel *lab = (UILabel *)[self.view viewWithTag:1000+i];
        lab.text = [arr objectAtIndex:i];
    }
    defaultModel = model;
    totalLab.text = [NSString stringWithFormat:@"选择：%@ 为取货点",model.name];
    showLocationLab.text = [NSString stringWithFormat:@"%@",model.name];
    addressLab.text = model.address;
    NSMutableArray *timeArr = (NSMutableArray *)[model.time componentsSeparatedByString:@" "];
    for (int i = 0; i < 3-timeArr.count; i++) {
        [timeArr addObject:@""];
    }    dateLab.text =  [timeArr objectAtIndex:0];
    timeLab1.text = [timeArr objectAtIndex:1];
    timeLab2.text = [timeArr objectAtIndex:2];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    annotationArray = [[NSMutableArray alloc] init];
    defaultModel = [[AnnotationModel alloc] init];
    
    [self buildView];

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
