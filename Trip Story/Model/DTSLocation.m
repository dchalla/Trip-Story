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


- (NSString *)displayFullAddress
{
	NSMutableString *address = [[NSMutableString alloc] initWithString:@""];
	
	[self appendInformation:self.mapItem.placemark.name toAddress:address];
	[self appendInformation:self.mapItem.placemark.thoroughfare toAddress:address];
	[self appendInformation:self.mapItem.placemark.locality toAddress:address];
	[self appendInformation:self.mapItem.placemark.administrativeArea toAddress:address];
	[self appendInformation:self.mapItem.placemark.country toAddress:address];
	[self appendInformation:self.mapItem.placemark.postalCode toAddress:address];
	return [address copy];
}

- (void)appendInformation:(NSString *)info toAddress:(NSMutableString *)address
{
	if (!address || info.length == 0)
	{
		return;
	}
	if (address.length > 0)
	{
		[address appendFormat:@", %@",info];
	}
	else
	{
		[address appendString:info];
	}
}
@end
