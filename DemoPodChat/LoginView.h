//
//  LoginView.h
//  DemoPodChat
//
//  Created by ThanhSon on 3/2/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "JVFloatLabeledTextField.h"
#import "ViewController.h"
#import "RoomViewController.h"
#import "User.h"
#import "Room.h"
#import "activityViewController.h"
@interface LoginView : UIViewController<UITextFieldDelegate>{
    activityViewController *activityView;
}
@property SocketIOClient * socket;
@property (strong, nonatomic) IBOutlet UITextField *text_UserName;
- (IBAction)btn_DangKi:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *text_UserPass;
@property (strong, nonatomic) IBOutlet UIButton *btn_DangKi;
- (IBAction)btn_Login:(id)sender;
@property (nonatomic,strong) User * user;
- (IBAction)btnRemember:(id)sender;

@end
