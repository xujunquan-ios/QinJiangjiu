//
//  MessageViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageModel.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    dataArray = [[NSMutableArray alloc] init];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
//    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self creatTableViewHeaderView];
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    [MBProgressHUD showHUDAddedTo:self.mTableView animated:YES];
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token",[[AppUtils shareAppUtils] getId],@"uid", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:GET_MESSAGE_LIST httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        int result =[[responseObject objectForKey:@"status"] intValue];
        [MBProgressHUD hideAllHUDsForView:self.mTableView animated:YES];
        if (result == 1) {
            [dataArray removeAllObjects];
            NSArray *arr = [responseObject objectForKey:@"list"];
                for (int i = 0 ; i < arr.count; i++) {
                    MessageModel *model = [[MessageModel alloc] init];
                    model.message = [[arr objectAtIndex:i] objectForKey:@"content"];
                    model.messageId = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.time = [[arr objectAtIndex:i] objectForKey:@"ctime"];
                    [dataArray addObject:model];
                
            }

            [self.mTableView reloadData];
        }       
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.mTableView animated:YES];

    }];
}
-(void)deleteMessage:(NSIndexPath *)indexPath{
    MessageModel *model = [dataArray objectAtIndex:indexPath.row];
    NSError *error;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token",[[AppUtils shareAppUtils] getId],@"uid", model.messageId, @"nid", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    NSLog(@"d = %@",d);
    [[FMNetWorkManager sharedInstance] requestURL:DELETE_MESSAGE httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        [MBProgressHUD hideAllHUDsForView:self.mTableView animated:YES];
        int result =[[responseObject objectForKey:@"status"] intValue];
        if (result == 1) {
            [dataArray removeObjectAtIndex:indexPath.row];
            [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }
        
        
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.mTableView animated:YES];
    }];
}
-(void)creatTableViewHeaderView{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView* headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 60, 60)];
    headImageView.image = [UIImage imageNamed:@"edit_pic"];
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
    [headerView addSubview:headImageView];
    
    UILabel* usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x+headImageView.frame.size.width+30, headImageView.center.y-20, headerView.frame.size.width-(headImageView.frame.origin.x+headImageView.frame.size.width+30-20), 20)];
    usernameLabel.text = [[AppUtils shareAppUtils] getUserName];;
    usernameLabel.font = FONTSIZE3;
    [headerView addSubview:usernameLabel];
    
    UILabel* addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x+headImageView.frame.size.width+30, headImageView.center.y, headerView.frame.size.width-(headImageView.frame.origin.x+headImageView.frame.size.width+30-20), 20)];
//    addressLabel.text = @"湖南 长沙 岳麓区";
    addressLabel.font = FONTSIZE3;
    [headerView addSubview:addressLabel];
    
    self.mTableView.tableHeaderView = headerView;
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* messageCellString = @"messageCell";
    MessageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:messageCellString];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCellString];
    }
    MessageModel* model = [dataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = UIColorFromRGB(0xF8F8F8);
    if (indexPath.row % 2 == 0){
        [cell setMarkUIColor:UIColorFromRGB(0xED8607)];
    }else{
        [cell setMarkUIColor:UIColorFromRGB(0x427201)];
    }
    cell.contentLabel.text = model.message;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        MessageModel *model = [dataArray objectAtIndex:indexPath.row];
//        NSLog(@"mode id = %@",model.messageId);
//        [dataArray removeObjectAtIndex:indexPath.row];
//        [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteMessage:indexPath];
        [MBProgressHUD showHUDAddedTo:self.mTableView animated:YES];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
