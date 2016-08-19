
//
//  Room.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "Room.h"

@implementation Room

-(id)initWitharray: (NSArray*)data{
    self.name = [data valueForKey:@"name"];
    self.image = [data valueForKey:@"image"];
    self.totaluser = [data valueForKey:@"totaluser"];
    self.owner = [data valueForKey:@"owner"];
    return self;
}

@end
