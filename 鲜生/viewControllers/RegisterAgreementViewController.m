//
//  RegisterAgreementViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#define TITLE1 @"总则"
#define CONTENT1 @"鲜生为用户提供果蔬在线预定及购买平台，服务的所有权和运作权归鲜生所有。用户在接受本服务之前，请务必仔细阅读本条款。用户使用服务，或通过完成注册程序，表示用户接受所有服务条款。"

#define TITLE2 @"第一条 服务内容"
#define CONTENT2 @"鲜生的具体服务内容由鲜生根据当下的实际情况提供。鲜生保留变更、中断或终止部分网络服务的权利。鲜生保留根据实际情况随时调整鲜生提供的服务种类及形式。鲜生不承担因业务调整给用户造成的损失。"

#define TITLE3 @"第二条 内容的所有权"
#define CONTENT3 @"鲜生的信息内容包括但不限于：文字、软件、声音、相片、录象、图表；以及其它信息，所有这些内容受版权、商标、标签和其它财产所有权法律的保护。用户只能在授权下才能使用这些内容，而不能擅自复制、再造这些内容、或创造与内容有关的派生产品。"

#define TITLE4 @"第三条 用户管理"
#define CONTENT4 @"用户对经由鲜生平台上载、张贴或传送的内容承担全部责任。用户通过鲜生上传任何内容到鲜生应用的行为，即构成用户将其上传到鲜生应用的全部内容授权给鲜生。在用户评论的过程中，如发布内容涉及他人隐私、淫秽色情、暴力、血腥等违反国家法律法规、地方政策规定、公秩良俗的内容和图片，则用户需对自己在使用鲜生服务过程中的行为承担全部的法律责任。我们有判断用户行为是否符合服务条款的要求和精神的保留权利，并做出相应的管理措施。"

#define TITLE5 @"第四条 用户账号、密码和安全性"
#define CONTENT5 @"用户在鲜生注册成功后，将得到鲜生的账号与密码，用户在注册时提供的所有信息，都是基于自愿，并将对用户名和密码的安全负全部责任。\n因注册信息不真实而引起的问题及其后果，以及因黑客行为或用户的保管疏忽导致帐号、密码遭他人非法使用，鲜生不承担任何责任。如用户发现其帐号遭他人非法使用，应立即与鲜生客服人员联系以降低损失。"

#define TITLE6 @" 第五条 隐私保护"
#define CONTENT6 @"保护用户隐私是鲜生的重点原则。鲜生承诺未经您的同意不会公开、编辑或透露用户的注册资料及保存在鲜生各项服务中的非公开内容，除非鲜生在诚信的基础上认为透露这些信息在某些情况下是必要的。用户在同意鲜生服务协议之时，即视为用户已经同意隐私保护政策全部内容。"

#define TITLE7 @"第六条 免责声明"
#define CONTENT7 @"用户将照片等个人资料上传到互联网上，有可能会被其他组织或个人复制、转载、擅改或做其它非法用途，用户必须充分意识此类风险的存在。用户明确同意其使用鲜生的服务所存在的风险将完全由其自己承担；因其使用鲜生的服务而产生的一切后果也由其自己承担，我们对用户不承担任何责任。\n我们不保证服务一定能满足用户的要求，也不保证服务不会中断，对服务的及时性、安全性、准确性也都不作保证。对于因不可抗力或鲜生无法控制的原因造成的网络服务中断或其他缺陷，鲜生不承担任何责任。"

#define TITLE8 @"第七条 服务变更、中断或终止"
#define CONTENT8 @"鲜生可随时根据实际情况中断一项或多项服务，将尽可能事先在应用上进行通告，但不承诺对任何个人或第三方负责或知会。同时用户若反对任何服务条款的建议或对后来的条款修改有异议，或对服务不满，用户可以行使如下权利：(1) 不再使用本公司的服务；(2) 通知本公司停止对该用户的服务。"

#define TITLE9 @"第八条 服务条款的完善和修改"
#define CONTENT9 @"鲜生保留随时修改服务条款的权利，用户在使用鲜生平台服务时，有必要对最新的鲜生服务条款进行仔细阅读和重新确认，用户对鲜生服务平台服务的使用即构成同意并接受完善和修改后的最新鲜生服务条款，当发生有关争议时，以最新的服务条款为准。"

#define TITLE10 @"第九条 通知送达"
#define CONTENT10 @"鲜生对于用户所有的通知均可通过公告推送、系统通知等方式进行，通知于发送之日即视为已送达收件人。用户对于鲜生的通知应当通过鲜生对外正式公布的通信地址、服务电话、传真号码、电子邮件地址等联系信息进行送达。"

#define TITLE11 @"第十条 其他"
#define CONTENT11 @"本用户条款的订立、执行和解释及争议的解决均应适用中华人民共和国法律。如用户就本协议内容或其执行发生任何争议，用户应尽量与我们友好协商解决；协商不成时，任何一方均可向鲜生所在地的人民法院提起诉讼。我们未行使或执行本服务协议任何权利或规定，不构成对前述权利或权利之放弃。如本服务协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本用户条款的其余条款仍应有效并且有约束力。"

#import "RegisterAgreementViewController.h"
#import "RegisterAgreementTableViewCell.h"
#import "ETUlityCommon.h"

@interface RegisterAgreementViewController ()

@end

@implementation RegisterAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    titleArray = [[NSMutableArray alloc] initWithObjects:TITLE1,TITLE2,TITLE3,TITLE4,TITLE5,TITLE6,TITLE7,TITLE8,TITLE9,TITLE10,TITLE11, nil];
    contenctArray = [[NSMutableArray alloc] initWithObjects:CONTENT1,CONTENT2,CONTENT3,CONTENT4,CONTENT5,CONTENT6,CONTENT7,CONTENT8,CONTENT9,CONTENT10,CONTENT11, nil];
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"  请阅读服务条款";
    headerLabel.font = [UIFont systemFontOfSize:12];
    headerLabel.textColor = UIColorFromRGB(0xEE751C);
    self.mTableView.tableHeaderView = headerLabel;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [ETUlityCommon getcontnetsize:[contenctArray objectAtIndex:indexPath.row] font:[UIFont systemFontOfSize:12] constrainedtosize:CGSizeMake(self.view.frame.size.width-50, MAXFLOAT) linemode:NSLineBreakByWordWrapping];
    return 55+size.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* cellString = @"RegisterAgreementTableViewCell";
    RegisterAgreementTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"RegisterAgreementTableViewCell" owner:nil options:nil] firstObject];
    }
    NSLog(@"%f %f %f %f",cell.textLabel.frame.size.height,cell.detailTextLabel.frame.size.height,cell.detailTextLabel.frame.origin.y,cell.detailTextLabel.frame.size.width);
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.subTitleLabel.numberOfLines = 0;
    cell.subTitleLabel.text = [contenctArray objectAtIndex:indexPath.row];
    return cell;
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
