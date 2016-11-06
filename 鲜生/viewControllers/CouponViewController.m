//
//  CouponViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "CouponViewController.h"

@interface CouponViewController ()

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil], [NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"西瓜",@"title",@"¥9",@"price", nil],nil];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.label1.backgroundColor = UIColorFromRGB(0xE5E5E5);
    self.label1.text = @"已\n领\n取";
    
    self.label2.backgroundColor = UIColorFromRGB(0xD0D0D0);
    self.label2.text = @"未\n领\n取";
    
    self.showView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* ruleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleTapPress)];
    
    [self.ruleImage addGestureRecognizer:ruleTap];
    
    ruleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleTapPress)];
    
    [self.ruleLabel addGestureRecognizer:ruleTap];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ruleTapPress{
    NSLog(@"查看使用规则");
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellString = @"CouponTableViewCell";
    CouponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"CouponTableViewCell" owner:nil options:nil] firstObject];
        
        NSInteger count = cell.subView.frame.size.width/20+1;
        for (NSInteger i = 0; i < count; i++) {
            UIView* markView = [[UIView alloc] initWithFrame:CGRectMake(i*20-8, -10, 20, 20)];
            markView.backgroundColor = tabBarColor;
            markView.layer.cornerRadius = markView.frame.size.width/2;
            [cell.subView addSubview:markView];
        }
    }
    cell.subView.backgroundColor = [UIColor clearColor];
    cell.subView.layer.borderWidth = 0.5;
    cell.subView.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    
    cell.priceLabel.adjustsFontSizeToFitWidth = YES;
    cell.priceLabel.text = @"20";
    
    
    [cell.customBtn setBackgroundColor:UIColorFromRGB(0xED6C0A)];
    
    if (indexPath.row%2 == 0) {
        cell.customBtn.hidden = YES;
    }else{
        cell.customBtn.hidden = NO;
    }

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
