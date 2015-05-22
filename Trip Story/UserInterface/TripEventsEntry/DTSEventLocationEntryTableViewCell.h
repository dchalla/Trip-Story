//
//  DTSEventLocationEntryTableViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/24/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSLocation.h"

@interface DTSEventLocationEntryTableViewCell : UITableViewCell


@property (nonatomic, strong) DTSLocation *fieldValue;
@property (nonatomic, strong) NSString *placeHolderValue;
@property (nonatomic, strong) id identifier;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
