//
//  DTSEntryTableViewCellDelegate.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSLocation.h"

@protocol DTSEntryTableViewCellDelegate <NSObject>

- (void)entryCompleteForIdentifier:(id)identifier withValue:(id)value;
- (void)didSelectCellForIdentifier:(id)identifier;
- (void)placeEntryCompletedWithValue:(DTSLocation *)location;

@end
