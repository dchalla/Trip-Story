//
//  DTSTripPhoto.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripPhoto.h"

@implementation DTSTripPhoto
@dynamic location;
@dynamic image;
@dynamic imageCreationDate;
@dynamic pixelWidth;
@dynamic pixelHeight;
@dynamic assetID;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSTripPhoto";
}

@end
