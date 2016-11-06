//
//  HomeViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "OneMoneyViewController.h"
#import "OneWeekViewController.h"
#import "QRCodeGenerator.h"
#import "MyLocationViewController.h"
#import "SelectLocationViewController.h"
#import "MyLocationListViewController.h"
@interface HomeViewController (){
//    CLLocationManager *location;
    UIButton *locationName;
    UIImageView * QRimageView;
    
    
    UILabel *areaLab;//自取点标题1
    UILabel *pointLab;//自取点标题2
    UIView *QRBgView;//二维码放大后的背景
}
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"pwd", nil];
    [[FMNetWorkManager sharedInstance] requestURL:@"/app.php/goods/index" httpMethod:@"POST" parameters:nil   success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSMutableArray* response = (NSMutableArray*)[responseObject objectForKey:@"img"];

//        [self.fruitView setImageWithURL:[NSURL URLWithString:[response objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"ios_首页-商场.png"]];
        [self.fruitView sd_setImageWithURL:[NSURL URLWithString:[response objectAtIndex:0]]  placeholderImage:[UIImage imageNamed:@"ios_首页-商场.png"]];
        [self.vegetablesView sd_setImageWithURL:[NSURL URLWithString:[response objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"ios_首页-商场.png"]];
        [self.oneMoneyView sd_setImageWithURL:[NSURL URLWithString:[response objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"ios_首页-商场.png"]];
        [self.oneWeekView sd_setImageWithURL:[NSURL URLWithString:[response objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"ios_首页-商场.png"]];
        [QRimageView sd_setImageWithURL:[NSURL URLWithString:[response objectAtIndex:5]] placeholderImage:[UIImage imageNamed:@"ios_购物车.png"]];

        
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);

    }];
    
    
    AnnotationModel *model = [[AppUtils shareAppUtils] getAddress];
    pointLab.text = model.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneMoneyView.userInteractionEnabled = YES;
    
//    location = [[CLLocationManager alloc] init];
//    location.delegate = self;
//    location.desiredAccuracy = kCLLocationAccuracyBest;
////    location.distanceFilter = 1000.0f;
//    [location startUpdatingLocation];
    
    
    if (nil == _locationManager)
        
        _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    //设置定位的精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置移动多少距离后,触发代理.
    _locationManager.distanceFilter = 10;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)
    {
        [_locationManager requestWhenInUseAuthorization];// 前台定位
        [_locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    
    //开始更新本地的位置
    [_locationManager startUpdatingLocation];
    

    //购物车按钮
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(mainScreenWidth-54, 20, 44, 44);
//    [rightBtn setImage:[UIImage imageNamed:@"nav_shoppingCenter"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightBtn];
//    rightBtn.tag = 4001;
    
    
    self.oneMoneyView.layer.cornerRadius = 5;
    self.oneMoneyView.clipsToBounds = YES;
    self.oneMoneyView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.oneMoneyView.layer.shadowOffset = CGSizeMake(4, 4);//偏移距离
    self.oneMoneyView.layer.shadowOpacity = 1;//不透明度
    self.oneMoneyView.layer.shadowRadius = 5.0;//半径
    
    
    QRBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, CGRectGetHeight(self.scrollView.frame))];
    QRBgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [self.scrollView addSubview:QRBgView];
    QRBgView.hidden = YES;
    
//    QRimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.QRCodeView.frame.size.width-2, self.QRCodeView.frame.size.height-2)];
    QRimageView = [[UIImageView alloc] initWithFrame:CGRectMake(mainScreenWidth-105, 290, self.QRCodeView.frame.size.width-2, self.QRCodeView.frame.size.height-2)];
    QRimageView.userInteractionEnabled = YES;
    QRimageView.backgroundColor = [UIColor whiteColor];
    QRimageView.image = [QRCodeGenerator qrImageForString:@"http://www.baidu.com" imageSize:self.QRCodeView.bounds.size.height-2];
    QRimageView.layer.cornerRadius = 5;
    QRimageView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    QRimageView.layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
    QRimageView.layer.shadowOpacity = 0.5;//不透明度
    QRimageView.layer.shadowRadius = 5.0;//半径
    [self.scrollView addSubview:QRimageView];
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goZarViewPress)];
    oneTap.numberOfTapsRequired = 1;
    [QRimageView addGestureRecognizer:oneTap];
    
    //本地名称，导航按钮
    locationName = [UIButton buttonWithType:UIButtonTypeCustom];
    locationName.frame = CGRectMake(15, 20, 60, 44);
    locationName.titleLabel.font = FONTSIZE3;
    locationName.titleLabel.textColor = [UIColor whiteColor];
//    [locationName setTitle:@"钱隆学府" forState:UIControlStateNormal];
    [locationName addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationName];
    
    areaLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 27, 100, 15)];
    areaLab.textColor = [UIColor whiteColor];
    areaLab.font = FONTSIZE4;
    [self.view addSubview:areaLab];
    pointLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 42, 100, 15)];
    pointLab.textColor = [UIColor whiteColor];
    pointLab.font = FONTSIZE4;
    [self.view addSubview:pointLab];
    
    
    
//    [self.QRCodeView addSubview:QRimageView];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    //购物车触发的方法
//    [self.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goFruitView)];
    [self.fruitView addGestureRecognizer:oneTap];

    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goVegetablesView)];
    [self.vegetablesView addGestureRecognizer:oneTap];

    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOneMoneyView)];
    [self.oneMoneyView addGestureRecognizer:oneTap];
    
    oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneOneWeekView)];
    [self.oneWeekView addGestureRecognizer:oneTap];
    
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-50, 20, 100, 44)];
    titleLab.text = @"果蔬堂";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = 1;
    [self.view addSubview:titleLab];
    
    // Do any additional setup after loading the view from its nib.
}

//位置列表
-(void)leftBtnPress{
    NSLog(@"去左视图");
    
//    //去查看自取点的视图
//    MyLocationViewController *mlv = [[MyLocationViewController alloc] init];
//    [self.navigationController pushViewController:mlv animated:YES];
    
    //地理位置列表
    MyLocationListViewController *mvc = [[MyLocationListViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
    
}

//-(void)rightBtnPress{
//    NSLog(@"去右试图");
//    if ([[AppUtils shareAppUtils] getIsLogin]) {
//        MessageViewController* messageVC = [[MessageViewController alloc] init];
//        messageVC.delegate = self;
//        [self.navigationController pushViewController:messageVC animated:YES];
//    }else{
//        LoginViewController* loginView = [[LoginViewController alloc] init];
//        loginView.delegate = self;
//        loginView.typeString = @"消息";
//        [self.navigationController pushViewController:loginView animated:YES];
//    }
//}

////点击购物车触发的方法
//-(void)rightBtnPress{
//    NSLog(@"去看购物车");
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self backToRootViewControllerWithType:INDEX_SHOPPING_CART];
//    
//}
-(void)goZarViewPress{
    NSLog(@"去分享");
    CGRect rect = QRimageView.frame;
    NSLog(@" %f--|%f",rect.origin.x,rect.origin.y);
    BOOL bgHidden;
    if (rect.origin.x != 0) {
        bgHidden = NO;
        rect = CGRectMake(0, (mainScreenHeight-mainScreenWidth)/2-64, mainScreenWidth, mainScreenWidth);
    }else{
        bgHidden = YES;
        rect = CGRectMake(mainScreenWidth-105, 290, self.QRCodeView.frame.size.width-2, self.QRCodeView.frame.size.height-2);

    }
    [UIView animateWithDuration:0.5 animations:^(){
//        QRimageView.frame = CGRectMake(0, (mainScreenHeight-mainScreenWidth)/2, mainScreenWidth, mainScreenWidth);
        QRimageView.frame = rect;
        QRBgView.hidden = bgHidden;
    }completion:^(BOOL isFinished){
    }];
}

-(void)goFruitView{
    NSLog(@"去水果");
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"0" forKey:@"type"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goShoppingCenter" object:self userInfo:dic] ;
    [self backToRootViewControllerWithType:INDEX_SHOPPING_CENTER];
}


-(void)goVegetablesView{
    NSLog(@"去蔬菜");
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1" forKey:@"type"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goShoppingCenter" object:self userInfo:dic] ;
    [self backToRootViewControllerWithType:INDEX_SHOPPING_CENTER];
}

-(void)goOneMoneyView{
    NSLog(@"去一元");
//    OneMoneyViewController* oneMoneyView = [[OneMoneyViewController alloc] init];
//    [self.navigationController pushViewController:oneMoneyView animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"2" forKey:@"type"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goShoppingCenter" object:self userInfo:dic] ;
    [self backToRootViewControllerWithType:INDEX_SHOPPING_CENTER];
    

}

-(void)oneOneWeekView{
    NSLog(@"去一周");
    OneWeekViewController* oneWeekView = [[OneWeekViewController alloc] init];
    [self.navigationController pushViewController:oneWeekView animated:YES];
}

#pragma mark ----下层视图返回 回调------

-(void)UIViewControllerBack:(MyViewController *)myViewController{
    if ([myViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginView = (LoginViewController*)myViewController;
        if ([loginView.typeString isEqualToString:@"消息"]) {
            MessageViewController* messageVC = [[MessageViewController alloc] init];
            messageVC.delegate = self;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
    }
}
#pragma makr ----location delegate--
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error%@",error);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
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
                           areaLab.text = place.subLocality;

                       }
                   }];
    [_locationManager stopUpdatingLocation];
    
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
