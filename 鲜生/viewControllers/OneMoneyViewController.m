//
//  OneMoneyViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "OneMoneyViewController.h"

@interface OneMoneyViewController ()

@end

@implementation OneMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],nil];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    UIView *nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, mainScreenWidth, mainScreenHeight-64)];
    [self.view addSubview:nullView];
    nullView.backgroundColor = [UIColor whiteColor];
    UIImageView *nullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (nullView.frame.size.height-mainScreenWidth)/2, mainScreenWidth, mainScreenWidth/750*500)];
    nullImageView.image = [UIImage imageNamed:@"特惠商城"];
    [nullView addSubview:nullImageView];
    

}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellString = @"OneMoneyTableViewCell";
    OneMoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"OneMoneyTableViewCell" owner:nil options:nil] firstObject];
        
      
    }
    
    return cell;
    
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
