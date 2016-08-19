//
//  ChatViewController.h
//  DemoPodChat
//
//  Created by ThanhSon on 6/27/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "User.h"
#import "Messager.h"

@interface ChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMessager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)ChatButton:(id)sender;

@property (strong,nonatomic) NSMutableArray * lstChat ;
@property (nonatomic,strong) User * user;
@property (strong,nonatomic) NSString* room;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * userImage;
@property SocketIOClient * socket;


@end
