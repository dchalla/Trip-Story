//
//  DTSFollowFriendsCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSFollowFriendsCollectionViewCell.h"
#import "UIColor+Utilities.h"
#import "PFUser+DTSAdditions.h"
#import "DTSUtilities.h"

@implementation DTSFollowFriendsCollectionViewCell

- (void)awakeFromNib {
	// Initialization code
	self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
	self.userImage.clipsToBounds = YES;
	self.followButton.layer.cornerRadius = 4;
	self.followButton.layer.borderWidth = 2;
	self.followButton.layer.borderColor = [UIColor dtsBlueColor].CGColor;
}

- (void)prepareForReuse
{
	self.userImage = nil;
	self.followButton.backgroundColor = [UIColor clearColor];
	[self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
	self.followButton.selected = NO;
	self.userNameLabel.text = @"";
}


- (void)updateUIWithUser:(PFUser *)user
{
	self.user = user;
	self.userNameLabel.text = [user dts_displayName];
	bool followingUser = [[DTSCache sharedCache] followStatusForUser:user];
	[self updateFollowButton:followingUser];
	
	if ([DTSUtilities userHasProfilePictures:self.user]) {
		self.userImage.file = [self.user objectForKey:kDTSUserProfilePicSmallKey];
		[self.userImage loadInBackground];
	}
	
}
- (IBAction)followButtonTapped:(id)sender {
	if (self.followButton.selected)
	{
		[DTSUtilities unfollowUserEventually:self.user];
		[self updateFollowButton:NO];
	}
	else
	{
		[DTSUtilities followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
			[self updateFollowButton:YES];
		}];
	}
}

- (void)updateFollowButton:(BOOL)following
{
	if (following)
	{
		self.followButton.backgroundColor = [UIColor dtsBlueColor];
		[self.followButton setTitle:@"Following" forState:UIControlStateNormal];
		self.followButton.selected = YES;
		[self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	}
	else
	{
		self.followButton.backgroundColor = [UIColor clearColor];
		[self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
		self.followButton.selected = NO;
		[self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
}

@end
