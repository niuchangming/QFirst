//
//  EditEmailViewController.m
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import "EditMeInfoViewController.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Utils.h"
#import "User.h"
#import "ConstantValues.h"
#import "MozTopAlertView.h"
#import <JCAlertView/JCAlertView.h>

@interface EditMeInfoViewController (){
    UIAlertController *alertVC;
    JCAlertView *verifyPopView;
}

@end

@implementation EditMeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.type isEqualToString:@"mobile"]){
        UILabel *phonePrefixLbl = [[UILabel alloc] initWithFrame:CGRectMake(4, 12, 32, 16)];
        [phonePrefixLbl setTextColor:[Utils colorFromHexString:@"#4A4A4A"]];
        [phonePrefixLbl setText:@"+65"];
        [phonePrefixLbl setFont:[UIFont systemFontOfSize:14]];
        phonePrefixLbl.textAlignment = NSTextAlignmentCenter;
        self.editTf.leftViewMode = UITextFieldViewModeAlways;
        self.editTf.leftView = phonePrefixLbl;
        
        self.title = @"Edit Mobile";
        [self.titleLbl setText:@"Mobile:"];
        [self.editTf setPlaceholder:@"Your mobile number"];
        self.noteTv.text = @"Please take a note that changing the mobile number will cause the current registed mobile number invalid, that means you cannot use the current mobile number to login this application. It will no longer exist in the system. So you should use the new mobile number to login this application.";
    }else if([self.type isEqualToString:@"email"]){
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        self.editTf.leftViewMode = UITextFieldViewModeAlways;
        self.editTf.leftView = spaceView;
        
        self.title = @"Edit Email";
        [self.titleLbl setText:@"Email:"];
        [self.editTf setPlaceholder:@"Your email"];
        self.noteTv.text = @"";
    }else if([self.type isEqualToString:@"ic"]){
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        self.editTf.leftViewMode = UITextFieldViewModeAlways;
        self.editTf.leftView = spaceView;
        
        self.title = @"Edit IC";
        [self.titleLbl setText:@"IC number:"];
        [self.editTf setPlaceholder:@"IC Number"];
        self.noteTv.text = @"";
    }else if([self.type isEqualToString:@"name"]){
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
        self.editTf.leftViewMode = UITextFieldViewModeAlways;
        self.editTf.leftView = spaceView;
        
        self.title = @"Edit Name";
        [self.titleLbl setText:@"Your name:"];
        [self.editTf setPlaceholder:@"Your name"];
        self.noteTv.text = @"";
    }
    
    self.editTf.layer.cornerRadius = 4;
    self.editTf.clipsToBounds = YES;
    
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.clipsToBounds = YES;
}

- (IBAction)submitBtnClicked:(id)sender {
    if([Utils IsEmpty:self.editTf.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[NSString stringWithFormat: @"%@ cannot be empty.", [self.type capitalizedString]] doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([self.type isEqualToString:@"email"] && ![Utils isValidEmail:self.editTf.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Email format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([self.type isEqualToString:@"ic"] && ![Utils isSingaporeIC:self.editTf.text]) {
        [MozTopAlertView showWithType:MozAlertTypeError text:@"IC format is incorrect." doText:nil doBlock:nil parentView:self.view];
        return;
    }
    
    if([self.type isEqualToString:@"mobile"]){
        [self popupAlert];
    }else{
        [self submitUpdateInfo];
    }

}

-(void) popupAlert{
    if(alertVC == nil){
        alertVC = [UIAlertController
                   alertControllerWithTitle:@"Important"
                   message:@"Changing current mobile number means your account will be replaced by your mobile number\nAre you sure to continue?"
                   preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action){
                                       [self submitUpdateInfo];
                                   }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
    }
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void) popupVerifyDialog{
    if(verifyPopView == nil){
        PasscodeView *passView = [[PasscodeView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        passView.delegate = self;
        verifyPopView = [[JCAlertView alloc] initWithCustomView:passView dismissWhenTouchedBackground:NO];
    }
    
    [verifyPopView show];
}

-(void) submitUpdateInfo{
    [self.loadingBar startAnimating];
    [self.submitBtn setEnabled:false];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: [Utils accessToken] forKey: @"accessToken"];
    if([self.type isEqualToString:@"mobile"]) {
        [params setObject: [NSString stringWithFormat:@"+65%@", self.editTf.text] forKey: self.type];
    }else{
        [params setObject: self.editTf.text forKey: self.type];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@UserController/updateUser", baseUrl] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *obj = (NSDictionary *)responseObject;
            NSString *errMsg = [obj valueForKey:@"error"];
            
            if(![Utils IsEmpty:errMsg]) {
                [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
            }else{
                if([self.type isEqualToString:@"mobile"]) {
                    [self parseUser:responseObject];
                    [self popupVerifyDialog];
                }else{
                    [self.delegate updateCompletedWithResponseData:self.editTf.text withType:self.type];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error" doText:nil doBlock:nil parentView:self.view];
        }
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MozTopAlertView showWithType:MozAlertTypeError text:[error localizedDescription] doText:nil doBlock:nil parentView:self.view];
        [self.loadingBar stopAnimating];
        [self.submitBtn setEnabled:true];
    }];
}

-(void) verifyCompletedWithResponseData:(id)resp withError:(NSString *)err{
    if(![Utils IsEmpty:err]){
        [MozTopAlertView showWithType:MozAlertTypeError text:err doText:nil doBlock:nil parentView:self.view];
    }else{
        [self parseUser:resp];
        [self.delegate updateCompletedWithResponseData:self.editTf.text withType:self.type];
        [verifyPopView dismissWithCompletion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) parseUser:(id) responseObject{
    if([responseObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *obj = (NSDictionary *)responseObject;
        NSString *errMsg = [obj valueForKey:@"error"];
        
        if(![Utils IsEmpty:errMsg]) {
            [MozTopAlertView showWithType:MozAlertTypeError text:errMsg doText:nil doBlock:nil parentView:self.view];
        }else{
            User *user = [[User alloc] initWithJson:obj];
            [self updateUserInfo:user];
        }
    }else{
        [MozTopAlertView showWithType:MozAlertTypeError text:@"Unknown error." doText:nil doBlock:nil parentView:self.view];
    }
}

-(void) updateUserInfo: (User *) user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.mobile forKey:@"mobile"];
    [defaults setBool:user.isActive forKey:@"is_active"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
