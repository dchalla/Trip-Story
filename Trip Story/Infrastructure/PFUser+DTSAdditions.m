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
	NSString *displayName = [self objectForKey:DTSUser_Display_Name];
	if (displayName.length > 0)
	{
		return displayName;
	}
	else if (facebookName.length > 0)
	{
		return facebookName;
	}
	else
	{
		if (self.username.length > 0) {
			return self.username;
		}
		else {
			return @"";
		}
		
	}
	
}


@end
