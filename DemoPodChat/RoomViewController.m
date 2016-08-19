//
//  RoomViewController.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "RoomViewController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.lstRoom = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationController.title =@"ROOM";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self connetSocket];
    
}
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}


-(void)connetSocket{
    NSURL* url = [[NSURL alloc] initWithString:@"http://nodejs-chatptit.rhcloud.com/"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @NO, @"forcePolling": @NO}];
    [self.socket connect];
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

#pragma mark UITableViewCell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.lstRoom.count);
    return self.lstRoom.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * CellID = @"cellroom";
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
    }
    Room * room = self.lstRoom[indexPath.row];
    cell.lblTitle.text = room.name;
    cell.image.image = [self decodeBase64ToImage:room.image];
    cell.lblTotalUser.text = [NSString stringWithFormat:@"%@",room.totaluser];
    return cell;
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


#pragma UITableViewCellDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"chatview"];
    Room * room = self.lstRoom[indexPath.row];
    view.room = room.name;
    view.user = [[User alloc] init];
    view.user = self.user;

     [self.socket emit:@"client-join-room" withItems:@[room.name]];
//    [self.socket emit:@"client-send-message" withItems:@[@"room1",@"user1",@"asd",@"cc"]];
//    [self.socket on:@"server-send-message" callback:^(NSArray * data, SocketAckEmitter * ack) {
//      //  [self addData:data];
//        NSLog(@"co conet");
//    }];
    [self.navigationController pushViewController:view animated:YES];

}

@end
