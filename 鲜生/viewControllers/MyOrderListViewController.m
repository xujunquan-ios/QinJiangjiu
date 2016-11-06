//
//  MyOrderListViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "ETUlityCommon.h"

@interface MyOrderListViewController ()

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 6; i ++) {
        NSMutableDictionary * order = [[NSMutableDictionary alloc] init];
        [order setObject:[NSDate date] forKey:@"finishTime"];
       
        if (i == 0) {
            [order setObject:@"配送中" forKey:@"state"];
        }else if (i == 1){
            [order setObject:@"待发货" forKey:@"state"];
        }else if (i == 2){
            [order setObject:@"待付款" forKey:@"state"];
        }else if (i == 3){
            [order setObject:@"待领取" forKey:@"state"];
        }else if (i == 4){
            [order setObject:@"待评价" forKey:@"state"];
        }else if (i == 5){
            [order setObject:@"交易完成" forKey:@"state"];
        }
        
        [order setObject:@"38" forKey:@"totalPrice"];
        
        
        NSMutableDictionary* fvData = [[NSMutableDictionary alloc] init];
        [fvData setObject:@"2" forKey:@"buyNumber"];
        [fvData setObject:@"测试水果" forKey:@"title"];
        
        [order setObject:[NSMutableArray arrayWithObjects:fvData, nil] forKey:@"FVArray" ];
        
        [dataArray addObject:order];
    }
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.showView.backgroundColor = [UIColor whiteColor];
    self.shadowView.backgroundColor = UIColorFromRGB(0x999999);
    
    selectView = nil;
    
    
    
    if (self.selectCount == 0) {
        [self.btn1 setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
        selectView = [[UIView alloc] initWithFrame:CGRectMake((mainScreenWidth/5-15*2)/2, self.showView.frame.size.height-2, 15*2, 2)];
    }else if (self.selectCount == 1){
        [self.btn2 setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
        selectView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth/5+(mainScreenWidth/5-15*3)/2, 38, 15*3, 2)];
    }else if (self.selectCount == 2){
        [self.btn3 setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
        selectView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth/5*2+(mainScreenWidth/5-15*3)/2, 38, 15*3, 2)];
    }else if (self.selectCount == 3){
        [self.btn4 setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
       selectView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth/5*3+(mainScreenWidth/5-15*3)/2, 38, 15*3, 2)];
    }else if (self.selectCount == 4){
        [self.btn5 setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
       selectView = [[UIView alloc] initWithFrame:CGRectMake(mainScreenWidth/5*4+(mainScreenWidth/5-15*3)/2,38, 15*3, 2)];
    }
//    mainScreenWidth/5
    NSLog(@"%f %f %f",selectView.frame.origin.x,self.view.frame.size.width,mainScreenWidth);
    
    selectView.backgroundColor = UIColorFromRGB(0xE4511D);
    [self.showView addSubview:selectView];
    
    [self.btn1 addTarget:self action:@selector(menuBtnPress:) forControlEvents:UIControlEventTouchDown];
    [self.btn2 addTarget:self action:@selector(menuBtnPress:) forControlEvents:UIControlEventTouchDown];
    [self.btn3 addTarget:self action:@selector(menuBtnPress:) forControlEvents:UIControlEventTouchDown];
    [self.btn4 addTarget:self action:@selector(menuBtnPress:) forControlEvents:UIControlEventTouchDown];
    [self.btn5 addTarget:self action:@selector(menuBtnPress:) forControlEvents:UIControlEventTouchDown];
    
   
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)menuBtnPress:(UIButton*)sender{
    if (self.selectCount == 0) {
        [self.btn1 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }else if (self.selectCount == 1){
        [self.btn2 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }else if (self.selectCount == 2){
        [self.btn3 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }else if (self.selectCount == 3){
        [self.btn4 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }else if (self.selectCount == 4){
        [self.btn5 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
    [sender setTitleColor:UIColorFromRGB(0xE4511D) forState:UIControlStateNormal];
    
    if (sender == self.btn1) {
        self.selectCount = 0;
    }else if (sender == self.btn2){
        self.selectCount = 1;
    }else if (sender == self.btn3){
        self.selectCount = 2;
    }else if (sender == self.btn4){
        self.selectCount = 3;
    }else if (sender == self.btn5){
        self.selectCount = 4;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.1];
    
    selectView.frame = CGRectMake(0, selectView.frame.origin.y, 15*3, 2);
    selectView.center = CGPointMake(sender.center.x, selectView.center.y);
    
    [UIView commitAnimations];
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellHeightWithOrder:[dataArray objectAtIndex:indexPath.row]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    
    NSMutableDictionary* order = [dataArray objectAtIndex:indexPath.row];
    UIView* cellView = [self getCellViewWithOrder:order];
    [cell.contentView addSubview:cellView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)getCellHeightWithOrder:(NSMutableDictionary*)order{
    NSMutableArray* fvArray = [order objectForKey:@"FVArray"];
    if ([[order objectForKey:@"state"] isEqualToString:@"配送中"]) {
        return 30+fvArray.count*90+40+5;
    }
    return 30+fvArray.count*90+30+40+5;
}

-(UIView*)getCellViewWithOrder:(NSMutableDictionary*)order{
    UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self getCellHeightWithOrder:order])];
    cellView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    UIImageView* markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    markImageView.image = [UIImage imageNamed:@"myOrderIcon.png"];
    [cellView addSubview:markImageView];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(markImageView.frame.size.width+markImageView.frame.origin.x+5, 0, 160, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.text = [[AppUtils shareAppUtils] getDateString:[NSDate date] withFormat:@"yyyy年MM月dd日"];
    titleLabel.font = FONTSIZE3;
    [cellView addSubview:titleLabel];
    
    UILabel* stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellView.frame.size.width-70, 0, 60, 30)];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.font = FONTSIZE4;
    stateLabel.textColor = UIColorFromRGB(0xE4511D);
    stateLabel.text = [order objectForKey:@"state"];
    [cellView addSubview:stateLabel];
    
    NSMutableArray* FVArray = [order objectForKey:@"FVArray"];
    for (NSInteger i = 0; i < FVArray.count; i++) {
        
        UIView* fvView = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i*90, self.view.frame.size.width, 90)];
        fvView.backgroundColor = UIColorFromRGB(0xF4F4F4);
        [cellView addSubview:fvView];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 90-2*10)];
        imageView.image = [UIImage imageNamed:@"测试1.png"];;
        [fvView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+10, imageView.frame.origin.y+10, self.view.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+10+10+30), imageView.frame.size.height/2-5)];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONTSIZE2;
        titleLabel.text = @"11111111";
        [fvView addSubview:titleLabel];
        
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 0, 80, fvView.frame.size.height)];
        priceLabel.numberOfLines = 0;
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.font = FONTSIZE4;
        priceLabel.textColor = UIColorFromRGB(0x999999);
        priceLabel.text = [NSString stringWithFormat:@"¥%@\nx %ld",@"18",(long)90];
        
        CGSize size = [ETUlityCommon getcontnetsize:[NSString stringWithFormat:@"¥%@",@"18"] font:priceLabel.font constrainedtosize:CGSizeMake(1000, 1000) linemode:NSLineBreakByWordWrapping];
        
        CGSize tempSize = [ETUlityCommon getcontnetsize:[NSString stringWithFormat:@"x %ld",(long)90] font:priceLabel.font constrainedtosize:CGSizeMake(1000, 1000) linemode:NSLineBreakByWordWrapping];
        
        size.width = MAX(size.width, tempSize.width);
        
        priceLabel.frame = CGRectMake(self.view.frame.size.width-10-size.width, 0, size.width, fvView.frame.size.height);
        
        [fvView addSubview:priceLabel];
        
        UILabel* subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+10, imageView.frame.origin.y+titleLabel.frame.size.height, self.view.frame.size.width-(imageView.frame.size.width+imageView.frame.origin.x+10+10+size.width), imageView.frame.size.height/2-5)];
        subTitleLabel.numberOfLines = 0;
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = FONTSIZE3;
        subTitleLabel.textColor = UIColorFromRGB(0x666666);
        subTitleLabel.text = @"详细文本";
        [fvView addSubview:subTitleLabel];
        
        UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, fvView.frame.size.height-2, fvView.frame.size.width, 2)];
        shadowView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [fvView addSubview:shadowView];
        
    }
    
    
    UILabel* decriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30+FVArray.count*90, cellView.frame.size.width-2*20, 30)];
    decriptionLabel.backgroundColor = [UIColor clearColor];
    decriptionLabel.textAlignment = NSTextAlignmentRight;
    decriptionLabel.font = FONTSIZE4;
    decriptionLabel.textColor = UIColorFromRGB(0x333333);
    decriptionLabel.text = [NSString stringWithFormat:@"共%lu件商品  合计¥%@",(unsigned long)FVArray.count,@"120"];
    [cellView addSubview:decriptionLabel];
    
    UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, decriptionLabel.frame.origin.y+decriptionLabel.frame.size.height-0.5, cellView.frame.size.width, 0.5)];
    shadowView.backgroundColor = UIColorFromRGB(0xDFDFDF);
    [cellView addSubview:shadowView];
    
    
    NSMutableArray* btnArray = [[NSMutableArray alloc] init];
    if ([[order objectForKey:@"state"] isEqualToString:@"待发货"]) {
        [btnArray addObject:@"提醒发货"];
        
    }else if ([[order objectForKey:@"state"] isEqualToString:@"待付款"]){
        [btnArray addObject:@"去付款"];
        [btnArray addObject:@"删除订单"];
    }else if ([[order objectForKey:@"state"] isEqualToString:@"待领取"]){
        [btnArray addObject:@"确定收货"];
        [btnArray addObject:@"延长收货"];
    }else if ([[order objectForKey:@"state"] isEqualToString:@"待评价"]){
        [btnArray addObject:@"去评价"];
        [btnArray addObject:@"删除订单"];
    }else if ([[order objectForKey:@"state"] isEqualToString:@"交易完成"]){
        [btnArray addObject:@"删除订单"];
    }
    
    for (NSInteger i = 0; i<btnArray.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = tabBarColor;
        btn.titleLabel.font = FONTSIZE3;
        btn.layer.cornerRadius = 5;
        btn.frame = CGRectMake(cellView.frame.size.width-90*(i+1), decriptionLabel.frame.origin.y+decriptionLabel.frame.size.height+7, 80, 26);
        [btn setTitle:[btnArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:btn];
    }
    
    if (btnArray.count > 0) {
        shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, cellView.frame.size.height-5.5, cellView.frame.size.width, 0.5)];
        shadowView.backgroundColor = UIColorFromRGB(0xDFDFDF);
        [cellView addSubview:shadowView];
    }
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, cellView.frame.size.height-5, cellView.frame.size.width, 5)];
    shadowView.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [cellView addSubview:shadowView];
    
    return cellView;
}

-(void)btnPress:(UIButton*)sender{
    NSLog(@"%@",[NSString stringWithFormat:@"去%@",sender.titleLabel.text]);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
