//
//  ViewController.h
//  DemoPodChat
//
//  Created by ThanhSon on 2/24/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "User.h"
#import "Messager.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txt_Chat;

@property (strong, nonatomic) IBOutlet UITableView *tableviewChat;
- (IBAction)btn_Chat:(id)sender;
@property (strong,nonatomic) NSMutableArray * lstChat ;
@property (nonatomic,strong) User * user;
@property (strong,nonatomic) NSString* room;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * userImage;
@property SocketIOClient * socket;


@end

