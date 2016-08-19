//
//  User.h
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * password;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * phone;
-(id)initWithArray: (NSArray*)data;

@end
