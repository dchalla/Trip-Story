//
//  DTSUserAuthHelper.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUserAuthHelper.h"



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


- (void)presentLoginModalIfNotLoggedIn
{
	if (![PFUser currentUser]) { // No user logged in
		// Create the log in view controller
		PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
		logInViewController.fields = PFLogInFieldsDefault | PFLogInFieldsFacebook;
		[logInViewController setDelegate:self]; // Set ourselves as the delegate
		
		// Create the sign up view controller
		PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
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
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
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
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController
	didFailToSignUpWithError:(PFUI_NULLABLE NSError *)error
{
	
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
