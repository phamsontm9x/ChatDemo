//
//  ViewController.m
//  DemoPodChat
//
//  Created by ThanhSon on 2/24/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "ViewController.h"
#import <SocketIOClientSwift/SocketIOClientSwift-Swift.h>
#import "JVFloatLabeledTextField.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connetSocket];
    
    self.lstChat = [[NSMutableArray alloc]init];
    
    [self.socket on:@" server-send-message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        [self addData:data];
        NSLog(@"co conet");
    }];
    
}

-(void) connetSocket{
    NSURL* url = [[NSURL alloc] initWithString:@"http://nodejs-chatptit.rhcloud.com/"];
    self.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @NO}];
    [self.socket connect];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UITableViewCellDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lstChat.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        NSString * cellLeft =@"cellLeft";
        NSString * cellRight = @"cellRight";
        Messager * mess = self.lstChat[indexPath.row];
        if(mess.user == self.user.username){
           UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellRight];
            UILabel * lbl_mes = (UILabel*)[cell viewWithTag:2];
            lbl_mes.text = mess.messager;
            UIImage * image_mes =(UIImage *)[cell viewWithTag:22];
            image_mes = [self decodeBase64ToImage:mess.image];
            return cell;
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellLeft];
            UILabel * lbl_mes = (UILabel*)[cell viewWithTag:1];
            lbl_mes.text = mess.messager;
            UIImage * image_mes =(UIImage *)[cell viewWithTag:11];
            image_mes = [self decodeBase64ToImage:mess.image];
            return cell;
        }

}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


#pragma mark SocKetio




- (IBAction)btn_Chat:(id)sender {
    NSString * message = self.txt_Chat.text;
  //  [self.socket emit:@"client-send-message" withItems:@[self.room,self.user.username,message,@"cc"]];
    [self.socket emit:@"client-send-message" withItems:@[@"room1",@"user1",message,@"cc"]];
    [self.socket on:@"server-send-message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        [self addData:data];
        NSLog(@"co conet");
    }];
    

}

-(void)addData:(NSArray*)data{
    NSArray * info = [data valueForKey:@"noidung"];
    NSString * name = [info valueForKey:@"name"];
    NSString * mess = [info valueForKey:@"message"];
    NSString * image = [info valueForKey:@"image"];
    Messager * message = [[Messager alloc]initWitharray:mess :image :name];
    [_lstChat addObject:message];
    //[self.tableView reloadData];
}
@end
