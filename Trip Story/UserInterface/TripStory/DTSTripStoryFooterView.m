//
//  DTSTripStoryFooterView.m
//  Trip Story
//
//  Created by Dinesh Challa on 5/20/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripStoryFooterView.h"

@implementation DTSTripStoryFooterView


- (void)updateView
{
	if (self.isSharing || ![self.trip.user.username isEqualToString:[PFUser currentUser].username])
	{
		self.messageLabel.hidden = YES;
		self.addEventButton.hidden = YES;
		self.tripStoryLogoImageView.hidden = NO;
		self.tripStoryLogoLabel.hidden = NO;
		
		if (self.isSharing) {
			self.tripStoryLogoLabel.text = @"theTripStory\nAvailable on Apple App Store";
		}
		else
		{
			self.tripStoryLogoLabel.text = @"theTripStory";
		}
	}
	else
	{
		self.messageLabel.hidden = NO;
		self.addEventButton.hidden = NO;
		self.tripStoryLogoImageView.hidden = YES;
		self.tripStoryLogoLabel.hidden = YES;
		if (self.trip.originalEventsList == nil || self.trip.originalEventsList.count == 0)
		{
			self.messageLabel.text = @"Lets get started by adding a starting event";
		}
		else
		{
			self.messageLabel.text = @"Add more events to your trip";
		}
	}
	
}

- (IBAction)addEventButtonTapped:(id)sender {
	[self.delegate tripStoryFooterViewAddEventTapped];
}

@end
