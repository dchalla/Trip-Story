//
//  DTSConstants.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DTSPrivacyPublic = 0,
	DTSPrivacyOnlyYou
}DTSPrivacy;

#define BlockWeakObject(o) __typeof(o) __weak
#define BlockWeakSelf BlockWeakObject(self)
#define BlockStrongSelf __typeof(self)

#pragma mark - User Class

#define DTSUser_Facebook_ID @"DTSUser_Facebook_ID"
#define DTSUser_Facebook_NAME @"DTSUser_Facebook_NAME"
#define DTSUser_Facebook_Profile_URL @"DTSUser_Facebook_Profile_URL"
#define DTSUser_Display_Name @"DTSUser_DISPLAY_NAME"
#define DTSUser_Search_Name @"DTSUser_SEARCH_NAME"

extern NSString *const kDTSUserFacebookFriendsKey;
extern NSString *const kDTSUserAlreadyAutoFollowedFacebookFriendsKey;
extern NSString *const kDTSUserEmailKey;
extern NSString *const kDTSUserAutoFollowKey;
extern NSString *const kDTSUserProfilePicSmallKey;
extern NSString *const kDTSUserProfilePicMediumKey;

#pragma mark - NSUserDefaults
extern NSString *const kDTSUserDefaultsCacheFacebookFriendsKey;


#pragma mark - Cached Trip Attributes
// keys
extern NSString *const kDTSTripAttributesIsLikedByCurrentUserKey;
extern NSString *const kDTSTripAttributesLikeCountKey;
extern NSString *const kDTSTripAttributesLikersKey;
extern NSString *const kDTSTripAttributesCommentCountKey;
extern NSString *const kDTSTripAttributesCommentersKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kDTSUserAttributesTripCountKey;
extern NSString *const kDTSUserAttributesIsFollowedByCurrentUserKey;

#pragma mark - misc
extern NSString *const kDTSRefreshTrips;
extern NSString *const kDTSUserAuthenticated;
extern NSString *const kDTSUserDataRefreshed;

@interface DTSConstants : NSObject

@end
