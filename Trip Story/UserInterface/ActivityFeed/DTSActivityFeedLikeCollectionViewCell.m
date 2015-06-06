//
//  DTSActivityFeedLikeCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSActivityFeedLikeCollectionViewCell.h"
#import "PFUser+DTSAdditions.h"
#import "UIColor+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"
#import "DTSUtilities.h"

@implementation DTSActivityFeedLikeCollectionViewCell

- (void)updateUIWithActivity:(DTSActivity *)activity
{
	self.activity = activity;
	NSString *contentString = [NSString stringWithFormat:@"%@ liked your trip %@",[activity.fromUser dts_displayName],activity.trip.tripName];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
	[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [activity.fromUser dts_displayName].length)];
	if (activity.trip.tripName)
	{
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dtsGreenColor] range:NSMakeRange(attributedString.length-activity.trip.tripName.length, activity.trip.tripName.length)];
	}
	
	if (activity.createdAt) {
		CGFloat hours = [[NSDate date] hoursAfterDate:activity.createdAt];
		NSString *hoursString = [NSString durationStringForHours:@(hours) withNewLine:NO onlyOneElement:YES];
		self.hoursAgoLabel.text = [NSString stringWithFormat:@"%@ ago",hoursString];
	}
	
	self.contentLabel.attributedText = [attributedString copy];
}

- (IBAction)userNameTapped:(id)sender {
	PFUser *user = dynamic_cast_oc(self.activity.fromUser, PFUser);
	[DTSUtilities openUserDetailsForUser:user];
}

@end
