//
//  TableViewCell.m
//  DemoPodChat
//
//  Created by ThanhSon on 6/26/16.
//  Copyright © 2016 ThanhSon. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

@synthesize image;
@synthesize lblTitle;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [lblTitle setFrame:CGRectMake(80, 10, 200, 60)];
//    [lblTitle setFrame:CGRectMake(8, 10, 60, 60)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
