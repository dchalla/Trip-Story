//
//  DTSUser.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/12/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSUser.h"
#import <PFObject+Subclass.h>

@implementation DTSUser

@dynamic displayName;
@dynamic profilePictureMedium;
@dynamic profilePictureSmall;
@dynamic facebookId;
@dynamic facebookFriends;
@dynamic channel;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSUser";
}

@end
