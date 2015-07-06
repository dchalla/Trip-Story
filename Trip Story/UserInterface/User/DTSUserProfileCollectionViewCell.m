//
//  DTSUserProfileCollectionViewCell.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/19/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserProfileCollectionViewCell.h"
#import "DTSUtilities.h"
#import "DTSConstants.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Utilities.h"
#import "PFUser+DTSAdditions.h"
#import "DTSActivity.h"
#import "DTSTrip.h"
#import "DTSCache.h"

@interface DTSUserProfileCollectionViewCell()

@property (nonatomic) BOOL updatedContent;

@end

@implementation DTSUserProfileCollectionViewCell

- (void)awakeFromNib
{
	self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
	self.profileImageView.clipsToBounds = YES;
	self.followButton.layer.cornerRadius = 4;
	self.followButton.layer.borderWidth = 2;
	self.followButton.layer.borderColor = [UIColor dtsBlueColor].CGColor;
	self.followButton.backgroundColor = [UIColor dtsBlueColor];
	self.followersLabel.text = @"";
	self.followingLabel.text = @"";
	self.tripsLabel.text = @"";
	
}

- (void)updateUIWithUser:(PFUser *)user
{
	self.user = user;
	self.userNameLabel.text = [self.user dts_displayName];
	if (self.user && self.profileImageView.image == nil)
	{
		[self updateUserProfileImage];
	}
	if (self.user && !self.updatedContent)
	{
		[self updateFollowerCount];
		[self updateFollowingCount];
		[self updateTripsCount];
		[self updateFollowButtonStatus];
		self.updatedContent = YES;
	}
	if ([self.user.username isEqualToString:[PFUser currentUser].username] || [PFUser currentUser] == nil)
	{
		self.followButton.hidden = YES;
	}
	else
	{
		self.followButton.hidden = NO;
	}
	
}

- (void)updateUserProfileImage
{
	if ([DTSUtilities userHasProfilePictures:self.user])
	{
		self.profileImageView.file = [self.user objectForKey:kDTSUserProfilePicMediumKey];
		BlockWeakSelf wSelf = self;
		[self.profileImageView loadInBackground:^(UIImage *image, NSError *error) {
			BlockStrongSelf strongSelf = wSelf;
			if (!strongSelf)
			{
				return;
			}
			if (!error) {
				strongSelf.backgroundImageView.image = [image applyDarkEffect];
			}
		}];
		
	}
}

- (void)updateFollowerCount
{
	if (!self.user)
	{
		return;
	}
	PFQuery *queryFollowerCount = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryFollowerCount whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[queryFollowerCount whereKey:kDTSActivityToUserKey equalTo:self.user];
	[queryFollowerCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
	BlockWeakSelf wSelf = self;
	[queryFollowerCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
		BlockStrongSelf strongSelf = wSelf;
		if (!strongSelf)
		{
			return;
		}
		if (!error) {
			[strongSelf.followersLabel setText:[NSString stringWithFormat:@"%d\nFollower%@", number, number==1?@"":@"s"]];
		}
	}];
}

- (void)updateFollowingCount
{
	if (!self.user)
	{
		return;
	}
	PFQuery *queryFollowingCount = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryFollowingCount whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[queryFollowingCount whereKey:kDTSActivityFromUserKey equalTo:self.user];
	[queryFollowingCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
	BlockWeakSelf wSelf = self;
	[queryFollowingCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
		BlockStrongSelf strongSelf = wSelf;
		if (!strongSelf)
		{
			return;
		}
		if (!error) {
			[strongSelf.followingLabel setText:[NSString stringWithFormat:@"%d\nFollowing", number]];
		}
	}];
}

- (void)updateTripsCount
{
	if (!self.user)
	{
		return;
	}
	PFQuery *queryTripsCount = [PFQuery queryWithClassName:NSStringFromClass([DTSTrip class])];
	[queryTripsCount whereKey:kDTSTripUserKey equalTo:self.user];
	[queryTripsCount setCachePolicy:kPFCachePolicyCacheThenNetwork];
	BlockWeakSelf wSelf = self;
	[queryTripsCount countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
		BlockStrongSelf strongSelf = wSelf;
		if (!strongSelf)
		{
			return;
		}
		if (!error) {
			[strongSelf.tripsLabel setText:[NSString stringWithFormat:@"%d\nTrip%@", number, number==1?@"":@"s"]];
			[[DTSCache sharedCache] setTripCount:[NSNumber numberWithInt:number] user:self.user];
		}
	}];
}

- (void)updateFollowButtonStatus
{
	if (!self.user || ![PFUser currentUser])
	{
		return;
	}
	PFQuery *queryIsFollowing = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryIsFollowing whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[queryIsFollowing whereKey:kDTSActivityToUserKey equalTo:self.user];
	[queryIsFollowing whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
	[queryIsFollowing setCachePolicy:kPFCachePolicyCacheThenNetwork];
	BlockWeakSelf wSelf = self;
	[queryIsFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
		BlockStrongSelf strongSelf = wSelf;
		if (!strongSelf)
		{
			return ;
		}
		if (error && [error code] != kPFErrorCacheMiss) {
			NSLog(@"Couldn't determine follow relationship: %@", error);
		} else {
			if (number == 0) {
				[self updateFollowButton:NO];
			} else {
				[self updateFollowButton:YES];
			}
		}
	}];
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
- (IBAction)followingFriendsListButtonTapped:(id)sender {
	[DTSUtilities openUserFriendsListForUser:self.user forFollowers:NO];
	
}
- (IBAction)followersListButtonTapped:(id)sender {
	[DTSUtilities openUserFriendsListForUser:self.user forFollowers:YES];
}

@end
