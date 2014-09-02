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

@implementation DTSEvent

+ (DTSEvent *)eventFromEvent:(DTSEvent *)event
{
	DTSEvent *newEvent = [[DTSEvent alloc] init];
	[newEvent copyFromEvent:event];
	return newEvent;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_startDateTime = [NSDate date];
		_endDateTime = [self.startDateTime dateByAddingHours:2];
	}
	return self;
}

- (void)setStartDateTime:(NSDate *)startDateTime
{
	_startDateTime = startDateTime;
	if ([self.startDateTime minutesBeforeDate:self.endDateTime]<=0)
	{
		_endDateTime = [self.startDateTime dateByAddingHours:2];
	}
}

- (void)setEndDateTime:(NSDate *)endDateTime
{
	_endDateTime = endDateTime;
	if ([self.startDateTime minutesBeforeDate:self.endDateTime]<=0)
	{
		_startDateTime = [self.endDateTime dateByAddingHours:-2];
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
			return DTSEventKindGeneral;
			
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
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivityStayHotel:
			return [UIColor colorWithHexString:@"EF4DB6"];
		case DTSEventTypeActivityDining:
			return [UIColor colorWithHexString:@"FFDB4C"];
		case DTSEventTypeActivitySightSeeing:
			return [UIColor colorWithHexString:@"87FC70"];
		case DTSEventTypeActivityHiking:
			return [UIColor colorWithHexString:@"52EDC7"];
		case DTSEventTypeActivityBiking:
			return [UIColor colorWithHexString:@"1AD6FD"];
		case DTSEventTypeActivityWaterSports:
			return [UIColor colorWithHexString:@"C644FC"];
		case DTSEventTypeTravelByRoad:
			return [UIColor colorWithHexString:@"FF9500"];
		case DTSEventTypeTravelByAir:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeTravelByWater:
			return [UIColor colorWithHexString:@"DBDDDE"];
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
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeTravelByAir:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeTravelByWater:
			return [UIColor colorWithHexString:@"898C90"];
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
	CGFloat hours = [self.eventHours floatValue];
	CGFloat height = hours * (200/8);
	height = MIN(200,MAX(60, height));
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


@end
