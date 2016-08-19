//
//  ChatViewController.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/27/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController{
    NSArray * chatData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self connetSocket];
    self.lstChat = [[NSMutableArray alloc]init];
    
    self.tableView.estimatedRowHeight =50;
    self.tableView.rowHeight =UITableViewAutomaticDimension;
    self.tableView.separatorColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
     [self.view addGestureRecognizer:tap];
    
    ///

}

-(void)listenServer{
    [self.socket once:@"server-send-message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        [self addData:data];
        [self listenServer];
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connetSocket{
    NSURL* url = [[NSURL alloc] initWithString:@"http://nodejs-chatptit.rhcloud.com/"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @NO}];
    [self.socket connect];
    [self listenServer];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    //return chatData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellLeft =@"cellLeft";
    NSString * cellRight = @"cellRight";
//    NSString * cellID;
    ///Messager * mess = self.lstChat[indexPath.row];
//    if([mess.user isEqual: self.user.username]){
    if(indexPath.row %2 == 0){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellRight];
        UILabel * lbl_mes = (UILabel*)[cell viewWithTag:22];
        //lbl_mes.text = mess.messager;
        lbl_mes.text = @"asdas dasd asd aasda";
        lbl_mes.layer.masksToBounds = YES;
        lbl_mes.layer.cornerRadius = 5;
//        UIButton * btn_mes =(UIButton *)[cell viewWithTag:2];
//        UIImage* image = [self decodeBase64ToImage:mess.image];
//        [btn_mes setBackgroundImage:image forState:UIControlStateNormal];
//        [btn_mes addTarget:self action:@selector(chooseBtnProlife:) forControlEvents:UIControlEventTouchUpInside];
       // cell.userInteractionEnabled =NO;
        return cell;
    } else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellLeft];
        UILabel * lbl_mes = (UILabel*)[cell viewWithTag:11];
        //lbl_mes.text = mess.messager;
        lbl_mes.text = @"asd123 13213  213 as dasd asd aasda";
        lbl_mes.layer.masksToBounds = YES;
        lbl_mes.layer.cornerRadius = 5;
       // UIButton * btn_mes =(UIButton *)[cell viewWithTag:2];
//        UIImage* image = [self decodeBase64ToImage:mess.image];
//        [btn_mes setBackgroundImage:image forState:UIControlStateNormal];
//        [btn_mes addTarget:self action:@selector(chooseBtnProlife:) forControlEvents:UIControlEventTouchUpInside];
//        cell.userInteractionEnabled =NO;
        return cell;
    }
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}



#pragma mark button

- (IBAction)ChatButton:(id)sender {
    NSString * message = self.txtMessager.text;
    //  [self.socket emit:@"client-send-message" withItems:@[self.room,self.user.username,message,@"cc"]];
    [self.socket emit:@"client-join-room" withItems:@[self.room]];
    [self.socket emit:@"client-send-message" withItems:@[self.room,self.user.username,message,self.user.image]];
    self.txtMessager.text=@"";

}

-(IBAction)chooseBtnProlife:(id)sender{
    
}

#pragma mark Data

-(void)addData:(NSArray*)data{
    NSArray * info = [data valueForKey:@"noidung"];
    NSString * name = [[info valueForKey:@"name"]componentsJoinedByString:@""];
    NSString * mess = [[info valueForKey:@"message"]componentsJoinedByString:@""];
    NSArray * infoImag= [info objectAtIndex:0];
    NSString * image = [[infoImag valueForKey:@"image"]componentsJoinedByString:@""];
    Messager * message = [[Messager alloc]initWitharray:mess :image :name];
    [_lstChat addObject:message];
    [self.tableView reloadData];
    //[self.socket removeAllHandlers];
}
@end
