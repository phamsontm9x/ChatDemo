//
//  LoginView.m
//  DemoPodChat
//
//  Created by ThanhSon on 3/2/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "LoginView.h"




@interface LoginView ()

@end

@implementation LoginView{
    NSString * image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc]init];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self createConnet];
    [self createActivity];
    [self rememberme];
};
- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)rememberme{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString*btn = [defaults objectForKey:@"button"];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *password = [defaults objectForKey:@"password"];
    if(username && password && [btn isEqualToString:@"check"]){
        self.text_UserName.text = username;
        self.text_UserPass.text = password;
        UIButton*btn = (UIButton*)[self.view viewWithTag:1];
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [btn setSelected:YES];
    }
}
-(void)createActivity{
    activityView = [[[NSBundle mainBundle] loadNibNamed:@"activityView" owner:self options:nil] lastObject];
    [activityView setFrame:CGRectMake(0, 0, 375, 677)];
    [self.view addSubview:activityView];
    activityView.hidden = YES;
    
}

- (void)controlActivity: (BOOL)control{
    if (control == YES) {
        activityView.hidden = NO;
    } else {
        activityView.hidden = YES;
    }
}

-(void)createConnet{
    NSURL* url = [[NSURL alloc] initWithString:@"http://nodejs-chatptit.rhcloud.com/"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @NO}];
    [self.socket connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) Loginwith: (NSString*)userName :(NSString*)password{

    
    [self.socket emit:@"client-send-login" withItems:@[userName,password]];
    [self controlActivity:YES];
    
    [self.socket on:@"result-login" callback:^(NSArray * data, SocketAckEmitter * ack) {

        User * user = [[User alloc]initWithArray:data];
        self.user = user;
        image = user.image;

        
        NSArray * noidung = [data valueForKey:@"noidung"];
        NSString * ketqua_dangki = [noidung valueForKey:@"kt"];
        NSString * kq;
        if ([ketqua_dangki  isEqual: @"\n2\n"]) {
            kq =[NSString stringWithFormat:@"Tai khoan dang nhap khong dung"];
        }else kq = [NSString stringWithFormat:@"Dang nhap thanh cong"];
        UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Xac Nhan" message:kq preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
           // RoomViewController *viewRoom =[self.storyboard instantiateViewControllerWithIdentifier:@"room"];
            if (![ketqua_dangki  isEqual: @"0"]){
                [self ParseListRoom];
                [self.socket off:@"result-login"];
                [self controlActivity:YES];
            }
        }];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
        [self controlActivity:NO];
    }];
}




- (IBAction)btn_Login:(id)sender {
    [self Loginwith:self.text_UserName.text :self.text_UserPass.text];
    
}

#pragma marks Dang ki tai khoan


- (IBAction)btn_DangKi:(id)sender {
    
    //Tao alert controller
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Dang ki" message:@"Usernam & Password" preferredStyle:UIAlertControllerStyleAlert];
    
    
    //Tao action cho alert
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Huy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //Dinh nghia cac tac vu o day
    }];
    
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Dang ki" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *txtUserName = alert.textFields.firstObject;
        UITextField *txtPassword = alert.textFields[1];
        UITextField *txtEmail = alert.textFields[2];
        UITextField *txtPhone = alert.textFields[3];
    

    //Dang ki tai khoan
        [self DangKiWith:txtUserName.text :txtPassword.text :txtEmail.text :txtPhone.text];
    // xet data gui ve de push view
        
    }];

    /// design textfiled
    [alert addTextFieldWithConfigurationHandler:^(UITextField *txtUserName){
        txtUserName.placeholder=@"Username";

    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *txtPassword){
        txtPassword.placeholder=@"Password";
        txtPassword.secureTextEntry=YES;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *txtEmail){
        txtEmail.placeholder=@"Email";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *txtPhone){
        txtPhone.placeholder=@"PhoneNumber";
    }];

    
    //Them action cho alert controller
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    

    //Hien thi alerController
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) DangKiWith: (NSString*)userName :(NSString*)password :(NSString*)email :(NSString*)phone{
    
    UIImage * someImage = [UIImage imageNamed: @"khang.jpg"];
    NSData *imageData=UIImagePNGRepresentation(someImage);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self.socket emit:@"client-send-information" withItems:@[userName,password,email,phone,base64]];

    [self.socket on:@"result-register" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSString * ketqua_dangki = [NSString stringWithFormat:@"%@",data];
        NSString * dangki;
        if ([dangki rangeOfString:@"1"].location ==NSNotFound) {
            ketqua_dangki =[NSString stringWithFormat:@"Tai khoan da ton tai"];
        }else dangki = [NSString stringWithFormat:@"Dang ki thanh cong"];
        UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Xac Nhan" message:dangki preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *  action) {
            
        }];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

-(void)ParseListRoom{
    RoomViewController *viewRoom =[self.storyboard instantiateViewControllerWithIdentifier:@"room"];
    [self.socket emit:@"client-login-successful" withItems:@[]];
    [self.socket on:@"server-send-list-room" callback:^(NSArray * data, SocketAckEmitter * ack) {
        NSLog(@"%@",data);
        NSArray * noidung = [data valueForKey:@"noidung"];
        NSArray * roomlist = [noidung objectAtIndex:0];
        viewRoom.lstRoom = [[NSMutableArray alloc]init];
        for(NSArray * room in roomlist){
            Room * RoomData = [[Room alloc]initWitharray:room];
            [viewRoom.lstRoom addObject:RoomData];
            NSLog(@"%lu",(unsigned long)viewRoom.lstRoom.count);
        }
        viewRoom.user = self.user;
        if(viewRoom.lstRoom.count >=2){
            [self.navigationController pushViewController:viewRoom animated:YES];
            [self controlActivity:NO];
            [self.socket off:@"server-send-list-room"];
        }
        
    }];
}

- (IBAction)btnRemember:(id)sender {
    UIButton * btn = (UIButton*)sender;
    if(btn.isSelected == NO){
        [btn setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [btn setSelected:YES];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString* textField1Text = self.text_UserName.text;
        [defaults setObject:textField1Text forKey:@"username"];
        NSString *textField2Text = self.text_UserPass.text;
        [defaults setObject:textField2Text forKey:@"password"];
        [defaults setObject:@"check" forKey:@"button"];
        [defaults synchronize];
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"uncheckbox.png"] forState:UIControlStateNormal];
        [btn setSelected:NO];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:@"uncheck" forKey:@"button"];
    }
}
@end
