//
//  RoomViewController.h
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "TableViewCell.h"
#import "Room.h"
#import "ChatViewController.h"
#import "User.h"
@interface RoomViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * lstRoom;
@property SocketIOClient * socket;
@property (nonatomic,strong) User * user;
@end
