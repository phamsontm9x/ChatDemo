//
//  Messager.h
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Messager : NSObject
@property (nonatomic,strong) NSString * messager;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * user;
-(id)initWitharray: (NSString*)messagerWith :(NSString*)image :(NSString*)user;

@end
