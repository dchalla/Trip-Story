//
//  PFUser+DTSAdditions.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFUser+DTSAdditions.h"
#import "DTSConstants.h"

@implementation PFUser (DTSAdditions)

- (NSString *)dts_displayName
{
	NSString *facebookName = [self objectForKey:DTSUser_Facebook_NAME];
	if (facebookName.length > 0)
	{
		return facebookName;
	}
	else
	{
		return self.username;
	}
	
}

@end
