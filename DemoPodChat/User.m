//
//  User.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithArray: (NSArray*)data{
    
    NSArray * noidung = [data valueForKey:@"noidung"];
    NSArray * infomation =[noidung valueForKey:@"information"];
    

    self.username = [[infomation valueForKey:@"username"]componentsJoinedByString:@""];
    self.password =[[infomation valueForKey:@"password"]componentsJoinedByString:@""];
    self.image =[infomation valueForKey:@"image"];
    self.email =[[infomation valueForKey:@"email"]componentsJoinedByString:@""];
    self.phone =[[infomation valueForKey:@"phone"]componentsJoinedByString:@""];
    return self;
}

@end
