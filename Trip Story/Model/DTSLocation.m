//
//  DTSLocation.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSLocation.h"


@implementation DTSLocation

- (NSString *)locationName
{
	if (!_locationName && _mapItem)
	{
		return self.mapItem.name;
	}
	else if(_locationName)
	{
		return _locationName;
	}
	return @"";
}

@end
