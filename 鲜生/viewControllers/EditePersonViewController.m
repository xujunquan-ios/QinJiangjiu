//
//  EditePersonViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "EditePersonViewController.h"
#import "ImportViewController.h"
#import "ChangePassWordViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface EditePersonViewController ()

@end

@implementation EditePersonViewController

-(void)getData{
    NSError *error;
    //    NSArray *data = (NSArray *)[[AppUtils shareAppUtils] getShoppingCarGood];
    
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    
    NSLog(@"d = %@",d);
    
    [[FMNetWorkManager sharedInstance] requestURL:GET_USERINFO httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);


        [currentUser setObject:[responseObject objectForKey:@"name"] forKey:@"nickname"];
        [currentUser setObject:[responseObject objectForKey:@"phone"] forKey:@"telephone"];
        [currentUser setObject:[responseObject objectForKey:@"address"] forKey:@"adderss"];
        if ([self isBlankString:[responseObject objectForKey:@"name"]]) {
            [currentUser setObject:@"" forKey:@"nickname"];
        }
        if ([self isBlankString:[responseObject objectForKey:@"phone"]]) {
            [currentUser setObject:@"" forKey:@"telephone"];
        }
        if ([self isBlankString:[responseObject objectForKey:@"address"]]) {
            [currentUser setObject:@"" forKey:@"adderss"];
        }
        
        [self.mTableView reloadData];

    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
//    dataArray = [[NSMutableArray alloc] initWithObjects:@"头    像",@"名    字",@"家庭住址",@"电    话",@"更改密码", nil];
    dataArray = [[NSMutableArray alloc] initWithObjects:@"头    像",@"名    字",@"电    话",@"更改密码", nil];
    
    currentUser = [[NSMutableDictionary alloc] init];
//    [currentUser setObject:@"宁静崽崽" forKey:@"nickname"];
//    [currentUser setObject:@"15355668589" forKey:@"telephone"];
//    [currentUser setObject:@"天心区新邵健康地方可分解大师看风景1455劳动法" forKey:@"adderss"];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.mTableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.mTableView.dataSource = self;
    self. mTableView.delegate = self;
    
    [self creatTableViewHeaderView];
    
    [self creatTableViewFooterView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatTableViewHeaderView{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.mTableView.tableHeaderView = headerView;
}

-(void)creatTableViewFooterView{
    
}

-(void)changeUserBtnPress{
    [[AppUtils shareAppUtils] savePassword:@""];
    [[AppUtils shareAppUtils] saveIsLogin:NO];
    [[AppUtils shareAppUtils] saveAccount:@""];
    [[AppUtils shareAppUtils] saveUserName:@""];
    [[AppUtils shareAppUtils] deleteAllGood];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginStateChange" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
        [self.delegate UIViewControllerBack:self];
    }
}

-(void)cancelBtnPress{
    [[AppUtils shareAppUtils] savePassword:@""];
    [[AppUtils shareAppUtils] saveIsLogin:NO];
    [[AppUtils shareAppUtils] deleteAllGood];
    [[AppUtils shareAppUtils] saveUserName:@""];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginStateChange" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark ---- UITableViewDataSource,UITableViewDelegate --------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return dataArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
        return 60;
    }
   
    return 140;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    if (indexPath.section == 0) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 60)];
        if (indexPath.row == 0) {
            titleLabel.frame = CGRectMake(20, 0, 80, 80);
        }
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FONTSIZE2;
        titleLabel.textColor = UIColorFromRGB(0x000000);
        titleLabel.text = [dataArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        
        if (indexPath.row == 0) {
            _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 10, 60, 60)];
            _portraitImageView.image = [UIImage imageNamed:@"edit_pic"];
            _portraitImageView.clipsToBounds = YES;
            _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.width/2;
            [cell.contentView addSubview:_portraitImageView];
            
        }else{
            if (indexPath.row != 4) {
                UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width+titleLabel.frame.origin.x+10, 0, self.view.frame.size.width-(titleLabel.frame.size.width+titleLabel.frame.origin.x+10+40), titleLabel.frame.size.height)];
                contentLabel.font = FONTSIZE2;
                contentLabel.textAlignment = NSTextAlignmentRight;
                contentLabel.textColor = UIColorFromRGB(0x666666);
                [cell.contentView addSubview:contentLabel];
                
                if (indexPath.row == 1) {
                    contentLabel.text = [currentUser objectForKey:@"nickname"];
                }
//                else if (indexPath.row == 2) {
//                    contentLabel.text = [currentUser objectForKey:@"adderss"];
//                }
                else if (indexPath.row == 2) {
                    contentLabel.text = [currentUser objectForKey:@"telephone"];
                }
                
            }
        }
        
        
        UIView* shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height-2, self.view.frame.size.width, 2)];
        shadowView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        [cell.contentView addSubview:shadowView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.section == 1){
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
        
        UIButton* changeUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeUserBtn.frame = CGRectMake(40, 40, self.view.frame.size.width-2*40, 40);
        changeUserBtn.layer.cornerRadius = 5;
        changeUserBtn.titleLabel.font = FONTSIZE2;
        changeUserBtn.backgroundColor = UIColorFromRGB(0xE4511D);
        [changeUserBtn setTitle:@"切换账号"forState:UIControlStateNormal];
        [changeUserBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [changeUserBtn addTarget:self action:@selector(changeUserBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:changeUserBtn];
        
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(40, 40+40+20, self.view.frame.size.width-2*40, 40);
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.titleLabel.font = FONTSIZE2;
        cancelBtn.backgroundColor = UIColorFromRGB(0xC9C9C9);
        [cancelBtn setTitle:@"注销"forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:cancelBtn];
        
        [cell.contentView addSubview:footerView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"去修改头像");
        [self editPortrait];
    }else if (indexPath.row == 1){
        NSLog(@"去修改名称");
        ImportViewController* importView = [[ImportViewController alloc] init];
        importView.title = @"昵称";
        importView.delegate = self;
        importView.isSingle = YES;
        importView.paraName = @"name";
        importView.maxCount = 10;
        importView.improtText = [currentUser objectForKey:@"nickname"];
        [self.navigationController pushViewController:importView animated:YES];
        
//    }else if (indexPath.row == 2){
//        NSLog(@"去修改地址");
//        ImportViewController* importView = [[ImportViewController alloc] init];
//        importView.title = @"家庭住址";
//        importView.delegate = self;
//        importView.isSingle = NO;
//        importView.maxCount = 60;
//        importView.paraName = @"address";
//        importView.improtText = [currentUser objectForKey:@"adderss"];
//        [self.navigationController pushViewController:importView animated:YES];
        
    }else if (indexPath.row == 2){
        NSLog(@"去修改电话");
//        ImportViewController* importView = [[ImportViewController alloc] init];
//        importView.title = @"电话";
//        importView.delegate = self;
//        importView.isSingle = YES;
//        importView.maxCount = 11;
//        importView.paraName = @"";
//        importView.improtText = [currentUser objectForKey:@"telephone"];
//        [self.navigationController pushViewController:importView animated:YES];
        
    }else if (indexPath.row == 3){
        NSLog(@"去修改密码");
//        SettingPasswordViewController* settingPasswordView = [[SettingPasswordViewController alloc] init];
//        settingPasswordView.passwordType = changeSelfPassword;
//        [self.navigationController pushViewController:settingPasswordView animated:YES];
        ChangePassWordViewController *cvc = [[ChangePassWordViewController alloc] init];
        cvc.delegate = self;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

#pragma mark ---- MyViewControllerDelegate -----
- (void)UIViewControllerBack:(MyViewController *)myViewController{
    if ([myViewController isKindOfClass:[ImportViewController class]]) {
        ImportViewController* importView = (ImportViewController*)myViewController;
        if ([importView.title isEqualToString:@"昵称"]) {
            [currentUser setObject:importView.improtText forKey:@"nickname"];
        }else if ([importView.title isEqualToString:@"家庭住址"]){
             [currentUser setObject:importView.improtText forKey:@"adderss"];
        }else if ([importView.title isEqualToString:@"电话"]){
             [currentUser setObject:importView.improtText forKey:@"telephone"];
        }
        [self.mTableView reloadData];
    }
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _portraitImageView.image = editedImage;
    
    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.width/2;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
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
