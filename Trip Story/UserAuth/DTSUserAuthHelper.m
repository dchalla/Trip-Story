//
//  DTSUserAuthHelper.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserAuthHelper.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DTSConstants.h"
#import "DTSCache.h"
#import "DTSUtilities.h"
#import "DTSSignUpViewController.h"
#import "PFUser+DTSAdditions.h"

@interface DTSUserAuthHelper()
{
	int _facebookResponseCount;
	int _expectedFacebookResponseCount;
}
@end

@implementation DTSUserAuthHelper

static DTSUserAuthHelper *sharedInstance = nil;

+ (id)sharedManager
{
	if(!sharedInstance)
	{
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			sharedInstance = [[DTSUserAuthHelper alloc] init];
		});
	}
	return sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_facebookResponseCount = 0;
		_expectedFacebookResponseCount = 0;
	}
	return self;
}


- (void)presentLoginModalIfNotLoggedIn
{
	if (![PFUser currentUser]) { // No user logged in
		// Create the log in view controller
		DTSLogInViewController *logInViewController = [[DTSLogInViewController alloc] init];
		logInViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
		[logInViewController setDelegate:self]; // Set ourselves as the delegate
		logInViewController.facebookPermissions = @[@"public_profile", @"user_friends", @"email", @"user_photos"];
		// Create the sign up view controller
		DTSSignUpViewController *signUpViewController = [[DTSSignUpViewController alloc] init];
		[signUpViewController setDelegate:self]; // Set ourselves as the delegate
		
		// Assign our sign up controller to be displayed from the login controller
		[logInViewController setSignUpController:signUpViewController];
		
		// Present the log in view controller
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:logInViewController animated:YES completion:NULL];
	}
	
}

#pragma mark PFLoginViewController Delegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController
shouldBeginLogInWithUsername:(NSString *)username
				   password:(NSString *)password
{
	return YES;
}

///--------------------------------------
/// @name Responding to Actions
///--------------------------------------


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
	[[PFUser currentUser] setObject:[[PFUser currentUser] dts_displayName] forKey:DTSUser_Display_Name];
	[[PFUser currentUser] setObject:[[[PFUser currentUser] dts_displayName] lowercaseString] forKey:DTSUser_Search_Name];
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
	[self updateFacebookDetailsForTheUser];
	[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserAuthenticated object:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController
	didFailToLogInWithError:(PFUI_NULLABLE NSError *)error
{
	
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PFSignupViewController delegate
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
	return YES;
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
	[[PFUser currentUser] setObject:[[PFUser currentUser] dts_displayName] forKey:DTSUser_Display_Name];
	[[PFUser currentUser] setObject:[[[PFUser currentUser] dts_displayName] lowercaseString] forKey:DTSUser_Search_Name];
	[self saveUserDetails];
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController
	didFailToSignUpWithError:(PFUI_NULLABLE NSError *)error
{
	
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Facebook related stuff
- (void)updateFacebookDetailsForTheUser
{
	if (![PFUser currentUser])
	{
		return;
	}
	BOOL isLinkedToFacebook = [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
	if (isLinkedToFacebook)
	{
		_expectedFacebookResponseCount = 0;
		_expectedFacebookResponseCount++;
		[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			
			if (!error) {
				
				NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
				
				// Store the Facebook Id
				
				[[PFUser currentUser] setObject:me.objectID forKey:DTSUser_Facebook_ID];
				[[PFUser currentUser] setObject:me.name forKey:DTSUser_Facebook_NAME];
				[[PFUser currentUser] setObject:me.name forKey:DTSUser_Display_Name];
				[[PFUser currentUser] setObject:[me.name lowercaseString] forKey:DTSUser_Search_Name];
				
				[self processFacebookData];
			}
		}];
		
		_expectedFacebookResponseCount++;
		[FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			if (!error)  {
				NSArray *data = [result objectForKey:@"data"];
				NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
				for (NSDictionary *friendData in data) {
					if (friendData[@"id"]) {
						[facebookIds addObject:friendData[@"id"]];
					}
				}
				// cache friend data
				[[DTSCache sharedCache] setFacebookFriends:facebookIds];
				[[PFUser currentUser] setObject:[facebookIds copy] forKey:kDTSUserFacebookFriendsKey];
				
				/*if ([[PFUser currentUser] objectForKey:kDTSUserAlreadyAutoFollowedFacebookFriendsKey]) {
					//[(AppDelegate *)[[UIApplication sharedApplication] delegate] autoFollowUsers];
				}*/
				[self processFacebookData];
			}

		}];
		
		_expectedFacebookResponseCount++;
		[FBRequestConnection startWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(500).height(500)"} HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			if (!error) {
				// result is a dictionary with the user's Facebook data
				NSDictionary *userData = (NSDictionary *)result;
				
				NSString *pictureURL = userData[@"picture"][@"data"][@"url"];
				if (pictureURL.length > 0)
				{
					[[PFUser currentUser] setObject:pictureURL forKey:DTSUser_Facebook_Profile_URL];
					[self fetchProfilePictureWithURL:pictureURL];
				}
				[self processFacebookData];
			}
		}];
	}
	else {
		if ([PFUser currentUser] && ![[PFUser currentUser] objectForKey:DTSUser_Search_Name]) {
			[[PFUser currentUser] setObject:[[[PFUser currentUser] dts_displayName] lowercaseString] forKey:DTSUser_Search_Name];
			[self saveUserDetails];
		}
		
	}

}

- (void)fetchProfilePictureWithURL:(NSString *)URL
{
	NSURLSession *session = [NSURLSession sharedSession];
	[[session dataTaskWithURL:[NSURL URLWithString:URL]
			completionHandler:^(NSData *data,
								NSURLResponse *response,
								NSError *error) {
				if (data.length > 0)
				{
					[DTSUtilities processFacebookProfilePictureData:data];
				}
			}] resume];
}

- (void)processFacebookData
{
	@synchronized (self) {
		_facebookResponseCount++;
		if (_facebookResponseCount != _expectedFacebookResponseCount) {
			return;
		}
	}
	_facebookResponseCount = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:kDTSUserDataRefreshed object:nil];
	[self saveUserDetails];
}

- (void)saveUserDetails {
	[[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		
		if (!error) {
			
			NSLog(@"Saved successfully");
			
		} else {
			
			NSLog(@"Error in saving");
			
		}
		
	}];
}


@end
