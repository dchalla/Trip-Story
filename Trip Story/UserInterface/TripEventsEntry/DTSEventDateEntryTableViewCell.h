//
//  DTSEventDateEntryTableViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEntryTableViewCellDelegate.h"

@interface DTSEventDateEntryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, strong) NSString *placeHolderValue;
@property (nonatomic, strong) id identifier;
@property (nonatomic, weak) id<DTSEntryTableViewCellDelegate> delegate;

@end
