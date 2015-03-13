//
//  DTSActivity.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/12/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSActivity.h"
#import <PFObject+Subclass.h>

@implementation DTSActivity

@dynamic fromUser;
@dynamic topUser;
@dynamic type;
@dynamic content;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSActivity";
}

@end
