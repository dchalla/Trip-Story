//
//  DTSConstants.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSConstants.h"

#pragma mark - NSUserDefaults
NSString *const kDTSUserDefaultsCacheFacebookFriendsKey = @"com.parse.TripStory.userDefaults.cache.facebookFriends";

#pragma mark - User Class
NSString *const kDTSUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kDTSUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";
NSString *const kDTSUserEmailKey                                = @"email";
NSString *const kDTSUserAutoFollowKey							= @"autoFollow";
NSString *const kDTSUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kDTSUserProfilePicMediumKey                     = @"profilePictureMedium";

#pragma mark - Cached Trip Attributes
// keys
NSString *const kDTSTripAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kDTSTripAttributesLikeCountKey            = @"likeCount";
NSString *const kDTSTripAttributesLikersKey               = @"likers";
NSString *const kDTSTripAttributesCommentCountKey         = @"commentCount";
NSString *const kDTSTripAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kDTSUserAttributesTripCountKey                 = @"photoCount";
NSString *const kDTSUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";

@implementation DTSConstants

@end
