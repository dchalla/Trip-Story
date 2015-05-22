//
//  DTSEvent.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEvent.h"
#import "UIColor+Utilities.h"
#import "NSDate+Utilities.h"
#import <PFObject+Subclass.h>

@implementation DTSEvent

@dynamic eventID;
@dynamic eventName;
@dynamic eventDescription;
@dynamic location;
@dynamic eventType;
@dynamic isPlaceHolderEvent;
@dynamic startDateTime;
@dynamic endDateTime;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSEvent";
}

+ (DTSEvent *)newEvent
{
	DTSEvent *event = [DTSEvent object];
	
	static NSDateFormatter *dateFormatter;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSS"];
	});
	
	event.eventID = [NSString stringWithFormat:@"%@%d",[dateFormatter stringFromDate:[NSDate date]], rand() % 1000000 + 1];
	event.startDateTime = [NSDate date];
	return event;
}

+ (DTSEvent *)eventFromEvent:(DTSEvent *)event
{
	DTSEvent *newEvent = [DTSEvent newEvent];
	[newEvent copyFromEvent:event];
	return newEvent;
}

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (NSDate *)startDateTime
{
	return [self objectForKey:@"startDateTime"];
}

- (void)setStartDateTime:(NSDate *)startDateTime
{
	if (startDateTime)
	{
		[self setObject:startDateTime forKey:@"startDateTime"];
		
		if (!self.endDateTime ||[self.startDateTime minutesBeforeDate:self.endDateTime]<=0)
		{
			self.endDateTime = [self.startDateTime dateByAddingHours:2];
		}
	}
}

- (NSDate *)endDateTime
{
	return [self objectForKey:@"endDateTime"];
}

- (void)setEndDateTime:(NSDate *)endDateTime
{
	if (endDateTime)
	{
		[self setObject:endDateTime forKey:@"endDateTime"];
		
		if (!self.startDateTime || [self.startDateTime minutesBeforeDate:self.endDateTime]<=0)
		{
			self.startDateTime = [self.endDateTime dateByAddingHours:-2];
		}
	}
	
}

- (DTSEventKind)eventKind
{
	switch (self.eventType)
	{
		case DTSEventTypeActivity:
		case DTSEventTypeActivityStayHotel:
		case DTSEventTypeActivityDining:
		case DTSEventTypeActivitySightSeeing:
		case DTSEventTypeActivityHiking:
		case DTSEventTypeActivityBiking:
		case DTSEventTypeActivityWaterSports:
			return DTSEventKindActivity;
		case DTSEventTypeTravelByAir:
		case DTSEventTypeTravelByRoad:
		case DTSEventTypeTravelByWater:
			return DTSEventKindTravel;
			
		default:
			return DTSEventKindUnknown;
	}
}

- (UIColor *)eventTopColor
{
	return [[self class] topColorForEventType:self.eventType];
}

+ (UIColor *)topColorForEventType:(DTSEventType)eventType
{
	switch (eventType)
	{
		case DTSEventTypeActivity:
			return [UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:0/255.0 alpha:1];// [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivityStayHotel:
			return [UIColor colorWithRed:235.0/255.0 green:58.0/255.0 blue:53.0/255.0 alpha:1];//[UIColor colorWithHexString:@"EF4DB6"];
		case DTSEventTypeActivityDining:
			return [UIColor colorWithRed:179.0/255.0 green:67.0/255.0 blue:204.0/255.0 alpha:1];//[UIColor colorWithHexString:@"FF9500"];
		case DTSEventTypeActivitySightSeeing:
			return [UIColor colorWithRed:255.0/255.0 green:61.0/255.0 blue:119.0/255.0 alpha:1];//[UIColor colorWithHexString:@"87FC70"];
		case DTSEventTypeActivityHiking:
			return [UIColor colorWithRed:5.0/255.0 green:132.0/255.0 blue:222.0/255.0 alpha:1];//[UIColor colorWithHexString:@"52EDC7"];
		case DTSEventTypeActivityBiking:
			return [UIColor colorWithRed:8.0/255.0 green:56.0/255.0 blue:240.0/255.0 alpha:1];//[UIColor colorWithHexString:@"1AD6FD"];
		case DTSEventTypeActivityWaterSports:
			return [UIColor colorWithRed:54.0/255.0 green:168.0/255.0 blue:0/255.0 alpha:1];//[UIColor colorWithHexString:@"C644FC"];
		case DTSEventTypeTravelByRoad:
		case DTSEventTypeTravelByAir:
		case DTSEventTypeTravelByWater:
			return [UIColor colorWithRed:49.0/255.0 green:24.0/255.0 blue:170.0/255.0 alpha:1];//[UIColor colorWithHexString:@"1D62F0"];
		case DTSEventTypePlaceholder:
			return [UIColor colorWithHexString:@"DBDDDE"];
			
		default:
			return [UIColor colorWithHexString:@"DBDDDE"];
	}
}

- (UIColor *)eventBottomColor
{
	return [[self class] bottomColorForEventType:self.eventType];
}

+ (UIColor *)bottomColorForEventType:(DTSEventType)eventType
{
	return [[self class] topColorForEventType:eventType];
	switch (eventType)
	{
		case DTSEventTypeActivity:
			return [UIColor colorWithHexString:@"FF2A68"];
		case DTSEventTypeActivityStayHotel:
			return [UIColor colorWithHexString:@"C643FC"];
		case DTSEventTypeActivityDining:
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivitySightSeeing:
			return [UIColor colorWithHexString:@"0BD318"];
		case DTSEventTypeActivityHiking:
			return [UIColor colorWithHexString:@"5AC8FB"];
		case DTSEventTypeActivityBiking:
			return [UIColor colorWithHexString:@"1D62F0"];
		case DTSEventTypeActivityWaterSports:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeTravelByRoad:
		case DTSEventTypeTravelByAir:
		case DTSEventTypeTravelByWater:
			return [UIColor colorWithHexString:@"1AD6FD"];
		case DTSEventTypePlaceholder:
			return [UIColor colorWithHexString:@"898C90"];
			
		default:
			return [UIColor colorWithHexString:@"898C90"];
	}
}

- (NSNumber *)eventHours
{
	return @(fabsf([self.startDateTime hoursBeforeDate:self.endDateTime]));
}

- (NSString *)eventTypeStringForEventType:(DTSEventType)type
{
	switch (type)
	{
		case DTSEventTypeActivity:
			return @"Other";
		case DTSEventTypeActivityStayHotel:
			return @"Stay/Lodging";
		case DTSEventTypeActivityDining:
			return @"Dining";
		case DTSEventTypeActivitySightSeeing:
			return @"Sightseeing";
		case DTSEventTypeActivityHiking:
			return @"Hiking";
		case DTSEventTypeActivityBiking:
			return @"Biking";
		case DTSEventTypeActivityWaterSports:
			return @"Water Sports";
		case DTSEventTypeTravelByRoad:
			return @"Travel By Road";
		case DTSEventTypeTravelByAir:
			return @"Travel By Air";
		case DTSEventTypeTravelByWater:
			return @"Travel By Water";
			
		default:
			return @"Other";
	}
}

- (NSArray *)eventTypeStringsArray
{
	NSMutableArray *eventsArray = [NSMutableArray array];
	for (int i = 0; i < 10; i++)
	{
		[eventsArray addObject:[self eventTypeStringForEventType:i]];
	}
	return [eventsArray copy];
}

- (CGFloat)tripStoryCellHeight
{
	if (self.isPlaceHolderEvent && self.eventKind != DTSEventKindTravel)
	{
		return 40;
	}
	CGFloat hours = [self.eventHours floatValue];
	CGFloat height = hours * (220/8);
	height = MIN(220,MAX(100, height));
	return height;
}

- (BOOL)isTravelEvent
{
	switch (self.eventType)
	{
		case DTSEventTypeTravelByAir:
		case DTSEventTypeTravelByRoad:
		case DTSEventTypeTravelByWater:
			return YES;
			
		default:
			return NO;
	}
}

- (void)copyFromEvent:(DTSEvent *)event
{
	self.eventID = event.eventID;
	self.eventName = event.eventName;
	self.eventDescription = event.eventDescription;
	self.startDateTime = event.startDateTime;
	self.endDateTime = event.endDateTime;
	self.location = event.location;
	self.eventType = event.eventType;
	self.isPlaceHolderEvent = event.isPlaceHolderEvent;
}

#pragma mark - MKAnnotation methods
- (NSString *)title {
	return self.eventName;
}

- (NSString *)subtitle {
	return self.location.mapItem.placemark.name;
}

- (CLLocationCoordinate2D)coordinate {
	return self.location.mapItem.placemark.location.coordinate;
}


@end
