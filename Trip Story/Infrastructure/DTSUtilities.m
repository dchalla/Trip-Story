//
//  DTSUtilities.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUtilities.h"
#import "DTSCache.h"
#import "UIImage+ResizeAdditions.h"
#import "DTSConstants.h"

@implementation DTSUtilities

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
		return;
	}
	
	// Create follow activity
	PFObject *followActivity = [PFObject objectWithClassName:NSStringFromClass([DTSActivity class])];
	[followActivity setObject:[PFUser currentUser] forKey:kDTSActivityFromUserKey];
	[followActivity setObject:user forKey:kDTSActivityToUserKey];
	[followActivity setObject:kDTSActivityTypeFollow forKey:kDTSActivityTypeKey];
	
	// Set the proper ACL
	PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
	[followACL setPublicReadAccess:YES];
	followActivity.ACL = followACL;
	
	// Save the activity and set the block passed as the completion block
	[followActivity saveEventually:completionBlock];
	
	[[DTSCache sharedCache] setFollowStatus:YES user:user];
}

+ (void)unfollowUserEventually:(PFUser *)user {
	PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[query whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
	[query whereKey:kDTSActivityToUserKey equalTo:user];
	[query whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeFollow];
	[query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
		// While normally there should only be one follow activity returned, we can't guarantee that.
		
		if (!error) {
			for (PFObject *followActivity in followActivities) {
				[followActivity deleteEventually];
			}
		}
	}];
	[[DTSCache sharedCache] setFollowStatus:NO user:user];
}

#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
	NSLog(@"Processing profile picture of size: %@", @(newProfilePictureData.length));
	if (newProfilePictureData.length == 0) {
		return;
	}
	
	UIImage *image = [UIImage imageWithData:newProfilePictureData];
	
	UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
	UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
	
	NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
	NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
	
	if (mediumImageData.length > 0) {
		PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
		[fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				[[PFUser currentUser] setObject:fileMediumImage forKey:kDTSUserProfilePicMediumKey];
				[[PFUser currentUser] saveInBackground];
			}
		}];
	}
	
	if (smallRoundedImageData.length > 0) {
		PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
		[fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				[[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kDTSUserProfilePicSmallKey];
				[[PFUser currentUser] saveInBackground];
			}
		}];
	}
	NSLog(@"Processed profile picture");
}

+ (BOOL)userHasProfilePictures:(PFUser *)user {
	PFFile *profilePictureMedium = [user objectForKey:kDTSUserProfilePicMediumKey];
	PFFile *profilePictureSmall = [user objectForKey:kDTSUserProfilePicSmallKey];
	
	return (profilePictureMedium && profilePictureSmall);
}

@end
