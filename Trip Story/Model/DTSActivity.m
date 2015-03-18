//
//  DTSActivity.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/12/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSActivity.h"
#import <PFObject+Subclass.h>

NSString *const kDTSActivityTypeLike       = @"like";
NSString *const kDTSActivityTypeFollow     = @"follow";
NSString *const kDTSActivityTypeComment    = @"comment";
NSString *const kDTSActivityTypeJoined     = @"joined";

NSString *const kDTSActivityTypeKey		= @"type";
NSString *const kDTSActivityFromUserKey = @"fromUser";
NSString *const kDTSActivityToUserKey   = @"toUser";
NSString *const kDTSActivityContentKey  = @"content";
NSString *const kDTSActivityTripKey		= @"trip";

@implementation DTSActivity

@dynamic fromUser;
@dynamic toUser;
@dynamic type;
@dynamic content;
@dynamic trip;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSActivity";
}

@end
