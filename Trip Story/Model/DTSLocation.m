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

- (NSString *)displayLocationCityState
{
	if (self.mapItem.placemark.locality.length > 0 && self.mapItem.placemark.administrativeArea.length > 0 && self.locationName)
	{
		return [NSString stringWithFormat:@"%@, %@, %@",self.locationName,self.mapItem.placemark.locality,self.mapItem.placemark.administrativeArea];
	}
	return self.locationName;
}

@end
