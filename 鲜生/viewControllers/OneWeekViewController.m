//
//  OneWeekViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "OneWeekViewController.h"
#import "ETUlityCommon.h"

@interface OneWeekViewController ()

@end

@implementation OneWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    selectCount = -1;
//    
//    dataArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],nil];
//    
//    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.fruitBtn addTarget:self action:@selector(headMenuBtnPress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.vegetablesBtn addTarget:self action:@selector(headMenuBtnPress:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.mTableView.dataSource = self;
//    self.mTableView.delegate = self;
    
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    navBarView.backgroundColor = UIColorFromRGB(0x305380);
    [self.view addSubview:navBarView];
    
    UILabel *titleLab = [[UILabel alloc ] initWithFrame:CGRectMake(mainScreenWidth/2-80, 20, 160, 44)];
    titleLab.text = @"一周购果蔬乐购";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = 1;
    [navBarView addSubview:titleLab];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 20, 44, 44);
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
    [self creatTableViewHeaderView];
    // Do any additional setup after loading the view from its nib.
    UIView *nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-64)];
    [self.view addSubview:nullView];
    nullView.backgroundColor = [UIColor whiteColor];
    UIImageView *nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (nullView.frame.size.height-mainScreenWidth)/2, mainScreenWidth, mainScreenWidth/750*500)];
    nullImageView.image = [UIImage imageNamed:@"一周购.jpg"];
    [nullView addSubview:nullImageView];

}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)headMenuBtnPress:(UIButton*)sender{
    [sender setBackgroundColor:navigationBarBtnColor];
    if (sender == self.fruitBtn) {
        [self.vegetablesBtn setBackgroundColor:navigationBarColor];
    }else{
        [self.fruitBtn setBackgroundColor:navigationBarColor];
    }
}

-(void)creatTableViewHeaderView{
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 0)];
    
    UIView* mealView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 140)];
    mealView.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIView* subView = [[UIView alloc] initWithFrame:CGRectMake(mealView.frame.size.width/3.0*i,0,mealView.frame.size.width/3.0 , mealView.frame.size.height)];
        subView.backgroundColor = [UIColor greenColor];
        
        UIImageView* subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, subView.frame.size.width-2*30, subView.frame.size.width-2*30)];
        subImageView.backgroundColor = [UIColor redColor];
        [subView addSubview:subImageView];
        
        UILabel* subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, subImageView.frame.size.height+subImageView.frame.origin.y, subView.frame.size.width, 30)];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.backgroundColor = [UIColor clearColor];
        subLabel.font = FONTSIZE2;
        subLabel.text = [NSString stringWithFormat:@"套餐1"];
        [subView addSubview:subLabel];
        
        [mealView addSubview:subView];
    }
    
    [headerView addSubview:mealView];
    
    headerView.frame = CGRectMake(0, 0, mainScreenWidth, headerView.frame.size.height+mealView.frame.size.height);
    
    UIView* decritionView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, headerView.frame.size.width, 0)];
    decritionView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    [headerView addSubview:decritionView];
    
    NSString* titileString = @"[樱桃＋雪梨＋香蕉＋芒果＋青柠]";
    NSString* subTitleString = @"敢于创新。很多水果放在一起打果汁会出现单独没有的美丽，让人惊喜不已。发挥你的创造力，多多尝试，一定会发现新的黄金组合。";
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, decritionView.frame.size.width-2*20, 20)];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONTSIZE2;
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.text = titileString;
    [decritionView addSubview:titleLabel];
    
    
    CGSize size = [ETUlityCommon getcontnetsize:titleLabel.text font:titleLabel.font constrainedtosize:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT) linemode:NSLineBreakByWordWrapping];
    titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, size.height);
    
    UILabel* subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLabel.frame.size.height+titleLabel.frame.origin.y+10, decritionView.frame.size.width-2*25, 20)];
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = FONTSIZE2;
    subTitleLabel.textColor = UIColorFromRGB(0x666666);
    subTitleLabel.text = subTitleString;
    [decritionView addSubview:subTitleLabel];
    
    size = [ETUlityCommon getcontnetsize:subTitleLabel.text font:subTitleLabel.font constrainedtosize:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT) linemode:NSLineBreakByWordWrapping];
    subTitleLabel.frame = CGRectMake(subTitleLabel.frame.origin.x, subTitleLabel.frame.origin.y, subTitleLabel.frame.size.width, size.height);
    
    decritionView.frame = CGRectMake(0, headerView.frame.size.height, decritionView.frame.size.width, subTitleLabel.frame.origin.y+subTitleLabel.frame.size.height+30);
    
    headerView.frame = CGRectMake(0, 0, mainScreenWidth, headerView.frame.size.height+decritionView.frame.size.height);
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, headerView.frame.size.height, headerView.frame.size.width-20*2, 80)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONTSIZE3;
    label.textColor = UIColorFromRGB(0x666666);
    label.text = subTitleString;
    [headerView addSubview:label];
    
    headerView.frame = CGRectMake(0, 0, mainScreenWidth, headerView.frame.size.height+label.frame.size.height);
    
    self.mTableView.tableHeaderView = headerView;
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = (dataArray.count+1)/3.0+1;
    if ((dataArray.count+1)%3 == 0) {
        row -- ;
    }
    
    CGFloat itemWidth = self.view.frame.size.width/3.0;
    return itemWidth*row;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    [cell.contentView addSubview:[self creatTableViewCellView]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView*)creatTableViewCellView{
    
    NSInteger row = (dataArray.count+1)/3.0+1;
    if ((dataArray.count+1)%3 == 0) {
        row -- ;
    }
    
    CGFloat itemWidth = self.view.frame.size.width/3.0;
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,itemWidth*row)];
    
    for (NSInteger i = 0; i < dataArray.count; i++) {
        UIImageView* itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3*itemWidth, i/3*itemWidth, itemWidth, itemWidth)];
        itemImageView.userInteractionEnabled = YES;
        itemImageView.image = [UIImage imageNamed:@"测试1.png"];
        itemImageView.tag = 1000+i;
        
        UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuPress:)];
        [itemImageView addGestureRecognizer:oneTap];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, itemWidth-10*2, 20)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"两个|0.6斤";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = UIColorFromRGB(0x666666);
        [itemImageView addSubview:label];
        
        UIView* showdaView = [[UIView alloc] initWithFrame:itemImageView.bounds];
        if (i != selectCount) {
            showdaView.hidden = YES;
        }
        showdaView.tag = 10000+i;
        showdaView.backgroundColor = [UIColor clearColor];
        
        oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenuPress:)];
        [showdaView addGestureRecognizer:oneTap];
        
        
        UIView* subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemImageView.frame.size.width, itemImageView.frame.size.height-40)];
        subView.backgroundColor = UIColorFromRGB(0x000000);
        subView.alpha = 0.27;
        [showdaView addSubview:subView];
        
        UIButton* deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(0, subView.frame.size.height, showdaView.frame.size.width/2, 40);
        deleteBtn.tag = 20000+i;
        deleteBtn.titleLabel.font = FONTSIZE3;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.backgroundColor = UIColorFromRGB(0xF4A117);
        [deleteBtn addTarget:self action:@selector(deleteBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [showdaView addSubview:deleteBtn];
        
        UIButton* changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(showdaView.frame.size.width/2, subView.frame.size.height, showdaView.frame.size.width/2, 40);
        changeBtn.tag = 30000+i;
        changeBtn.titleLabel.font = FONTSIZE3;
        [changeBtn setTitle:@"替换" forState:UIControlStateNormal];
        changeBtn.backgroundColor = UIColorFromRGB(0xE86E1E);
        [changeBtn addTarget:self action:@selector(changeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [showdaView addSubview:changeBtn];
        
        [itemImageView addSubview:showdaView];
        
        [footerView addSubview:itemImageView];
    }
    
    return footerView;
}

-(void)deleteBtnPress:(UIButton*)sender{
    selectCount = -1;
    [dataArray removeObjectAtIndex:sender.tag - 20000];
    [self.mTableView reloadData];
}

-(void)changeBtnPress:(UIButton*)sender{
    NSLog(@"去替换");
}

-(void)showMenuPress:(UITapGestureRecognizer*)gesture{
    if (selectCount >= 0) {
        UIView* shadowView = [self.view viewWithTag:10000+selectCount];
        shadowView.hidden = YES;
    }
    selectCount = gesture.view.tag - 1000;
    
    UIView* shadowView = [self.view viewWithTag:10000+selectCount];
    shadowView.hidden = NO;
}

-(void)hiddenMenuPress:(UITapGestureRecognizer*)getsture{
    selectCount = -1;
    getsture.view.hidden = YES;
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
