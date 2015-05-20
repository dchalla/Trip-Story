//
//  DTSEventsEntryDeleteView.m
//  Trip Story
//
//  Created by Dinesh Challa on 5/19/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSEventsEntryDeleteView.h"

@implementation DTSEventsEntryDeleteView

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.deleteButton.hidden = NO;
	self.confirmDeleteLabel.hidden = YES;
	self.yesDeleteButton.hidden = YES;
	self.noDeleteButton.hidden = YES;
}

- (IBAction)deleteButtonTapped:(id)sender {
	self.deleteButton.hidden = YES;
	self.confirmDeleteLabel.hidden = NO;
	self.yesDeleteButton.hidden = NO;
	self.noDeleteButton.hidden = NO;
}

- (IBAction)yesDeleteButtonTaped:(id)sender {
	[self.delegate eventDeleteButtonTapped];
}
- (IBAction)noDeleteButtonTapped:(id)sender {
	self.deleteButton.hidden = NO;
	self.confirmDeleteLabel.hidden = YES;
	self.yesDeleteButton.hidden = YES;
	self.noDeleteButton.hidden = YES;
}

@end
