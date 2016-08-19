//
//  Room.h
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject
@property  NSInteger  id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * totaluser;
@property (nonatomic,strong) NSString * owner;
-(id)initWitharray: (NSArray*)data;
@end
