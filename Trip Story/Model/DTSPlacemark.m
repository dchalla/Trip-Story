//
//  DTSPlacemark.m
//  Trip Story
//
//  Created by Dinesh Challa on 2/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSPlacemark.h"
#import <Parse/PFObject+Subclass.h>

@implementation DTSPlacemark
@dynamic longitude;
@dynamic latitude;
@dynamic addressDictionary;
@synthesize mapItem = _mapItem;
@synthesize mkplacemark = _mkplacemark;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSPlacemark";
}

- (MKMapItem *)mapItem {
	if (!_mapItem) {
		if (self.longitude != 0 && self.latitude != 0)
		{
			if (self.mkplacemark)
			{
				MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:self.mkplacemark];
				_mapItem = mapItem;
			}
		}
	}
	
	return _mapItem;
}

- (MKPlacemark *)mkplacemark
{
	if(!_mkplacemark) {
		if (self.longitude != 0 && self.latitude != 0)
		{
			MKPlacemark *mkplacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude) addressDictionary:self.addressDictionary];
			if (mkplacemark)
			{
				_mkplacemark =  mkplacemark;
			}
		}
	}
	
	return _mkplacemark;
}

- (void)updateWithMkMapItem:(MKMapItem *)mapItem {
	_mapItem = nil;
	_mkplacemark = nil;
	if (mapItem && mapItem.placemark)
	{
		self.longitude = mapItem.placemark.location.coordinate.longitude;
		self.latitude = mapItem.placemark.location.coordinate.latitude;
		self.addressDictionary = mapItem.placemark.addressDictionary;
	}
}


@end
