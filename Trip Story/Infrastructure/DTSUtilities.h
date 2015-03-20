//
//  DTSUtilities.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFUser.h>
#import <Parse/Parse.h>
#import "DTSActivity.h"

@interface DTSUtilities : NSObject
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData;
+ (BOOL)userHasProfilePictures:(PFUser *)user;
+ (void)openUserDetailsForUser:(PFUser *)user;
+ (void)openUserFriendsListForUser:(PFUser *)user forFollowers:(BOOL)forFollowers;
@end
