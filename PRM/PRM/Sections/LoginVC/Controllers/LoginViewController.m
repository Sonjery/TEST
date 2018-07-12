//
//  LoginViewController.m
//  PRM
//
//  Created by JoinupMac01 on 17/2/6.
//  Copyright © 2017年 JoinupMac01. All rights reserved.
//

#import "LoginViewController.h"
#import "IPSetViewController.h"
#import "MainViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setViewAndTFData];

}
- (void)setViewAndTFData {
  if ([[UserDefaultManager shareUserDefaultManager]getFirstRun]) {
        self.userNameTF.text = @"";
        self.passwordTF.text = @"";
        [self.rememberPasswordButton.imageView setImage: [UIImage imageNamed:@"deSelect"]];
    }else{
        self.userNameTF.text = [[UserDefaultManager shareUserDefaultManager]getUserName];
        self.passwordTF.text = [[UserDefaultManager shareUserDefaultManager]getPassword];
        if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]) {
            [self.rememberPasswordButton.imageView setImage:[UIImage imageNamed:@"selected"]];
        }else{
            [self.rememberPasswordButton.imageView setImage:[UIImage imageNamed:@"deSelect"]];
        }
    }
}
- (IBAction)rememberPasswordAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected =!sender.selected;
    if (sender.selected) {
        [self.rememberPasswordButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];//:[UIImage imageNamed:@"selected"]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberPassword"];
        [[UserDefaultManager shareUserDefaultManager] saveUserName:self.userNameTF.text password:self.passwordTF.text];
    }else{
        [self.rememberPasswordButton setImage:[UIImage imageNamed:@"deSelected"] forState:UIControlStateSelected];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rememberPassword"];
        [[UserDefaultManager shareUserDefaultManager] saveUserName:self.userNameTF.text password:@""];
    }
}
- (IBAction)loginButtonAction:(UIButton *)sender {
    NSDictionary *paraDic;
    if (self.userNameTF.text.length != 0 && self.passwordTF.text.length != 0) {
        paraDic = @{@"loginName":self.userNameTF.text,@"password":self.passwordTF.text};
        [self requestLoginPostInfoWithParaDic:paraDic];
    }else{
        [self showMessageLabel:@"用户名或密码为空" withBackColor:kGeneralColor_lightCyanColor];
    }
}
-(void)requestLoginPostInfoWithParaDic:(NSDictionary *)paraDic{
    [self showProgressHUDWithStr:@"加载中..."];
    [NewNetWorkManager requestPOSTWithURLStr:kRequestUrl(@"LogApp") parDic:paraDic finish:^(id responder) {
        kMyLog(@"%@",responder);
        NSDictionary *dic = responder;
        if ([[dic objectForKey:@"success"] integerValue] == 1) {
            [self showProgressHUDWithStr:@"登录成功"];
            [[UserDefaultManager shareUserDefaultManager] saveUserName:self.userNameTF.text password:self.passwordTF.text];
            [[UserDefaultManager shareUserDefaultManager] saveEmployeeName:[dic valueForKey:@"employeeName"] Dt_Info:[dic valueForKey:@"dt"] EmployeeID:[dic valueForKey:@"employeeID"] DepartmentID:[dic valueForKey:@"departmentID"] PositionID:[dic valueForKey:@"positionID"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             MainViewController *mainVC = [board instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.navigationController pushViewController:mainVC animated:YES];
        
            
        }else{
                [self showProgressHUDWithStr:@"登录失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                self.passwordTF.text = @"";
                [[UserDefaultManager shareUserDefaultManager] saveUserName:self.userNameTF.text password:self.passwordTF.text];
                [self  showMessageLabel:@"用户名或密码错误" withBackColor:kGeneralColor_lightCyanColor];
            });
        }
    } conError:^(NSError *error) {        
        [self showProgressHUDWithStr:@"登录超时,请检查IP设置..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
              [self  showMessageLabel:@"服务器链接失败..."withBackColor:kGeneralColor_lightCyanColor];
        });
    }];

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
