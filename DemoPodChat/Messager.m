//
//  Messager.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "Messager.h"

@implementation Messager
-(id)initWitharray: (NSString*)messager :(NSString*)image :(NSString*)user{
    self.image = [image copy];
    self.messager = [messager copy];
    self.user =[user copy];
    return self;
}
@end
