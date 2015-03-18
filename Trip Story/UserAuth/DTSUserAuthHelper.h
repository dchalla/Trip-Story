//
//  DTSUserAuthHelper.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DTSLogInViewController.h"

@interface DTSUserAuthHelper : NSObject<PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

+ (id)sharedManager;
- (void)presentLoginModalIfNotLoggedIn;
- (void)updateFacebookDetailsForTheUser;

@end
