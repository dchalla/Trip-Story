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
#import "DTSUserRootViewController.h"
#import "DTSUserFriendsViewController.h"

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
	[followActivity saveEventually:^(BOOL succeeded, NSError *error) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserDataRefreshed object:nil];
		if (completionBlock) {
			completionBlock(succeeded,error);
		}
	}];
	
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
				[followActivity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserDataRefreshed object:nil];
				
					}];
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
				[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserDataRefreshed object:nil];
			}
		}];
	}
	
	if (smallRoundedImageData.length > 0) {
		PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
		[fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (!error) {
				[[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kDTSUserProfilePicSmallKey];
				[[PFUser currentUser] saveInBackground];
				[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserDataRefreshed object:nil];
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

+ (void)openUserDetailsForUser:(PFUser *)user
{
	DTSUserRootViewController *userRootVC = [[DTSUserRootViewController alloc] init];
	userRootVC.user = user;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:userRootVC animated:YES];
	
}

+ (void)openUserFriendsListForUser:(PFUser *)user forFollowers:(BOOL)forFollowers
{
	DTSUserFriendsViewController *userFriendsVC =[[DTSUserFriendsViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSActivity parseClassName]];
	userFriendsVC.forFollowers = forFollowers;
	userFriendsVC.user = user;
	[((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) pushViewController:userFriendsVC animated:YES];
}


+ (void)likeTripInBackground:(DTSTrip *)trip block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	PFQuery *queryExistingLikes = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryExistingLikes whereKey:kDTSActivityTripKey equalTo:trip];
	[queryExistingLikes whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	[queryExistingLikes whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
	[queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
	[queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
		if (!error) {
			for (PFObject *activity in activities) {
				[activity delete];
			}
		}
		
		// proceed to creating new like
		DTSActivity *likeActivity = [DTSActivity object];
		likeActivity.type = kDTSActivityTypeLike;
		likeActivity.fromUser = [PFUser currentUser];
		likeActivity.toUser = trip.user;
		likeActivity.trip = trip;
		
		PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
		[likeACL setPublicReadAccess:YES];
		[likeACL setWriteAccess:YES forUser:trip.user];
		[likeACL setWriteAccess:YES forUser:[PFUser currentUser]];
		likeActivity.ACL = likeACL;
		
		[likeActivity saveEventually:^(BOOL succeeded, NSError *error) {
			if (completionBlock) {
				completionBlock(succeeded,error);
			}
			
			// refresh cache
			PFQuery *query = [DTSUtilities queryForActivitiesOnTrip:trip cachePolicy:kPFCachePolicyNetworkOnly];
			[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
				if (!error) {
					
					NSMutableArray *likers = [NSMutableArray array];
					NSMutableArray *commenters = [NSMutableArray array];
					
					BOOL isLikedByCurrentUser = NO;
					
					for (DTSActivity *activity in objects) {
						if ([activity.type isEqualToString:kDTSActivityTypeLike] && activity.fromUser)
						{
							[likers addObject:activity.fromUser];
						}
						else if ([activity.type isEqualToString:kDTSActivityTypeComment] && activity.fromUser)
						{
							[commenters addObject:activity.fromUser];
						}
						
						if ([[activity.fromUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
							if ([activity.type isEqualToString:kDTSActivityTypeLike]) {
								isLikedByCurrentUser = YES;
							}
						}
					}
					
					[[DTSCache sharedCache] setAttributesForTrip:trip likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
				}
			}];
			
		}];
	}];
	
}

+ (void)unlikeTripInBackground:(DTSTrip *)trip block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
	PFQuery *queryExistingLikes = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryExistingLikes whereKey:kDTSActivityTripKey equalTo:trip];
	[queryExistingLikes whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	[queryExistingLikes whereKey:kDTSActivityFromUserKey equalTo:[PFUser currentUser]];
	[queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
	[queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
		if (!error) {
			for (PFObject *activity in activities) {
				[activity delete];
			}
			
			if (completionBlock) {
				completionBlock(YES,nil);
			}
			
			// refresh cache
			PFQuery *query = [DTSUtilities queryForActivitiesOnTrip:trip cachePolicy:kPFCachePolicyNetworkOnly];
			[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
				if (!error) {
					
					NSMutableArray *likers = [NSMutableArray array];
					NSMutableArray *commenters = [NSMutableArray array];
					
					BOOL isLikedByCurrentUser = NO;
					
					for (DTSActivity *activity in objects) {
						if ([activity.type isEqualToString:kDTSActivityTypeLike]) {
							[likers addObject:activity.fromUser];
						} else if ([activity.type isEqualToString:kDTSActivityTypeComment]) {
							[commenters addObject:activity.fromUser];
						}
						
						if ([[activity.fromUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
							if ([activity.type isEqualToString:kDTSActivityTypeLike]) {
								isLikedByCurrentUser = YES;
							}
						}
					}
					
					[[DTSCache sharedCache] setAttributesForTrip:trip likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
				}
			}];
			
		} else {
			if (completionBlock) {
				completionBlock(NO,error);
			}
		}
	}];
}

#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnTrip:(DTSTrip *)trip cachePolicy:(PFCachePolicy)cachePolicy {
	PFQuery *queryLikes = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryLikes whereKey:kDTSActivityTripKey equalTo:trip];
	[queryLikes whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeLike];
	
	PFQuery *queryComments = [PFQuery queryWithClassName:NSStringFromClass([DTSActivity class])];
	[queryComments whereKey:kDTSActivityTripKey equalTo:trip];
	[queryComments whereKey:kDTSActivityTypeKey equalTo:kDTSActivityTypeComment];
	
	PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
	[query setCachePolicy:cachePolicy];
	[query includeKey:kDTSActivityFromUserKey];
	[query includeKey:kDTSActivityTripKey];
	
	return query;
}

#pragma mark Toast
+ (void)showToastWithMessage:(NSString *)message backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)color tapHandler:(voidBlock)tapHandler dimissOnSwipeUp:(BOOL)dismissOnSwipeUp {
	
	NSMutableDictionary *options = [@{kCRToastNotificationTypeKey               : @(CRToastTypeNavigationBar),
									  kCRToastNotificationPresentationTypeKey   :  @(CRToastPresentationTypePush),
									  kCRToastUnderStatusBarKey                 : @(NO),
									  kCRToastTextKey                           : message,
									  kCRToastTimeIntervalKey                   : @(CGFLOAT_MAX),
									  kCRToastTextAlignmentKey                  : @(NSTextAlignmentCenter),
									  kCRToastAnimationInTypeKey                : @(CRToastAnimationTypeSpring),
									  kCRToastAnimationOutTypeKey               : @(CRToastAnimationTypeSpring),
									  kCRToastAnimationInDirectionKey           : @(CRToastAnimationDirectionTop),
									  kCRToastAnimationOutDirectionKey          : @(CRToastAnimationDirectionTop)} mutableCopy];
	
	
	
	
	options[kCRToastInteractionRespondersKey] = @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap|CRToastInteractionTypeSwipeUp
																								  automaticallyDismiss:YES
																												 block:^(CRToastInteractionType interactionType){
																													 if (interactionType & CRToastInteractionTypeTap) {
																														 if (tapHandler) {
																															 tapHandler();
																														 }
																													 }
																													 if (interactionType & CRToastInteractionTypeSwipeUp && dismissOnSwipeUp) {
																														 [CRToastManager dismissNotification:YES];
																														 
																													 }
																												 }]];
	
	[CRToastManager showNotificationWithOptions:options
								completionBlock:^(void) {
									
								}];
	
}

+ (void)dismissToast
{
	[CRToastManager dismissNotification:YES];
}


+ (void)recordOnboardingShownToUser
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OnboardingDidShowToUser"];
}

+ (BOOL)isOnboardingShownToUser
{
	BOOL didShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"OnboardingDidShowToUser"];
	return didShow;
}


@end
