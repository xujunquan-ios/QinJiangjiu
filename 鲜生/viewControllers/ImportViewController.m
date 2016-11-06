//
//  ImportViewController.m
//  FreshMan
//
//  Created by MacPro on 15-8-14.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController ()

@end

@implementation ImportViewController
@synthesize isEnter,isSingle,maxCount,placeholder,improtText,keyboardType,paraName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    [self.leftBtn addTarget:self action:@selector(leftBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.TitleLabel.text = self.title;
    
    if (!isSingle){
        self.showViewHeight.constant+=60;
    }
    
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.delegate = self;
    self.mTextView.text = improtText;
    self.mTextView.placeholder = placeholder;
    self.mTextView.keyboardType = self.keyboardType;
    
    [self.mTextView becomeFirstResponder];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)leftBtnPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnPress{
    
    NSError *error;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[AppUtils shareAppUtils] getUserId],@"token",self.mTextView.text, paraName, nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr = %@",jsonString);
    
    
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"project", nil];
    
    NSLog(@"d = %@",d);
    
    [[FMNetWorkManager sharedInstance] requestURL:SAVE_USERINFO httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            improtText = self.mTextView.text;
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(UIViewControllerBack:)]) {
                [self.delegate UIViewControllerBack:self];
            }
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"err_msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alt show];
        }
        

    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
    }];
    

}

#pragma mark ----textView功能实现 -------

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!isEnter){
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    NSMutableString* newStr = [[NSMutableString alloc] initWithFormat:@"%@",textView.text];
    [newStr replaceCharactersInRange:range withString:text];
    if (newStr.length > maxCount){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
