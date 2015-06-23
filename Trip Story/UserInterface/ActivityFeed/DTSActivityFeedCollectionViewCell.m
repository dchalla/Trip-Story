//
//  DTSActivityFeedLikeCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSActivityFeedCollectionViewCell.h"
#import "PFUser+DTSAdditions.h"
#import "UIColor+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"
#import "DTSUtilities.h"

@implementation DTSActivityFeedCollectionViewCell

- (void)updateUIWithActivity:(DTSActivity *)activity
{
	self.activity = activity;
	NSMutableAttributedString *attributedString;
	
	if ([activity.type isEqualToString:kDTSActivityTypeLike])
	{
		NSString *contentString = [NSString stringWithFormat:@"%@ liked your trip %@",[activity.fromUser dts_displayName],activity.trip.tripName];
		attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [activity.fromUser dts_displayName].length)];
		if (activity.trip.tripName)
		{
			[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dtsGreenColor] range:NSMakeRange(attributedString.length-activity.trip.tripName.length, activity.trip.tripName.length)];
		}
		
		self.contentLabel.attributedText = [attributedString copy];

	}
	else if([activity.type isEqualToString:kDTSActivityTypeFollow])
	{
		NSString *contentString = [NSString stringWithFormat:@"%@ is following you",[activity.fromUser dts_displayName]];
		attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [activity.fromUser dts_displayName].length)];
		
		self.contentLabel.attributedText = [attributedString copy];

	}
	
	if (activity.createdAt) {
		CGFloat hours = [[NSDate date] hoursAfterDate:activity.createdAt];
		NSString *hoursString = [NSString durationStringForHours:@(hours) withNewLine:NO onlyOneElement:YES];
		self.hoursAgoLabel.text = [NSString stringWithFormat:@"%@ ago",hoursString];
	}
	
	
}

- (IBAction)userNameTapped:(id)sender {
	PFUser *user = dynamic_cast_oc(self.activity.fromUser, PFUser);
	[DTSUtilities openUserDetailsForUser:user];
}

@end
