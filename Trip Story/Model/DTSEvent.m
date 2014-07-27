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
		case DTSEventTypeActivityAdventure:
		case DTSEventTypeActivityBiking:
		case DTSEventTypeActivityDancing:
		case DTSEventTypeActivityHiking:
		case DTSEventTypeActivityRunning:
		case DTSEventTypeActivitySwimming:
		case DTSEventTypeActivityWalking:
			return DTSEventKindActivity;
		case DTSEventTypeRestaurant:
		case DTSEventTypeSleep:
		case DTSEventTypeTravelCar:
		case DTSEventTypeTravelFlight:
			return DTSEventKindGeneral;
			
		default:
			return DTSEventKindUnknown;
	}
}

- (UIColor *)eventTopColor
{
	switch (self.eventType)
	{
		case DTSEventTypeActivity:
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivityAdventure:
			return [UIColor colorWithHexString:@"FF9500"];
		case DTSEventTypeActivityBiking:
			return [UIColor colorWithHexString:@"FFDB4C"];
		case DTSEventTypeActivityDancing:
			return [UIColor colorWithHexString:@"87FC70"];
		case DTSEventTypeActivityHiking:
			return [UIColor colorWithHexString:@"52EDC7"];
		case DTSEventTypeActivityRunning:
			return [UIColor colorWithHexString:@"1AD6FD"];
		case DTSEventTypeActivitySwimming:
			return [UIColor colorWithHexString:@"C644FC"];
		case DTSEventTypeActivityWalking:
			return [UIColor colorWithHexString:@"EF4DB6"];
		case DTSEventTypeRestaurant:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeSleep:
			return [UIColor colorWithHexString:@"DBDDDE"];
		case DTSEventTypeTravelCar:
			return [UIColor colorWithHexString:@"DBDDDE"];
		case DTSEventTypeTravelFlight:
			return [UIColor colorWithHexString:@"DBDDDE"];
			
		default:
			return [UIColor colorWithHexString:@"DBDDDE"];
	}
}

- (UIColor *)eventBottomColor
{
	switch (self.eventType)
	{
		case DTSEventTypeActivity:
			return [UIColor colorWithHexString:@"FF2A68"];
		case DTSEventTypeActivityAdventure:
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivityBiking:
			return [UIColor colorWithHexString:@"FF5E3A"];
		case DTSEventTypeActivityDancing:
			return [UIColor colorWithHexString:@"0BD318"];
		case DTSEventTypeActivityHiking:
			return [UIColor colorWithHexString:@"5AC8FB"];
		case DTSEventTypeActivityRunning:
			return [UIColor colorWithHexString:@"1D62F0"];
		case DTSEventTypeActivitySwimming:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeActivityWalking:
			return [UIColor colorWithHexString:@"C643FC"];
		case DTSEventTypeRestaurant:
			return [UIColor colorWithHexString:@"5856D6"];
		case DTSEventTypeSleep:
			return [UIColor colorWithHexString:@"898C90"];
		case DTSEventTypeTravelCar:
			return [UIColor colorWithHexString:@"898C90"];
		case DTSEventTypeTravelFlight:
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
			return @"Other Activity";
		case DTSEventTypeActivityAdventure:
			return @"Adventure";
		case DTSEventTypeActivityBiking:
			return @"Biking";
		case DTSEventTypeActivityDancing:
			return @"Dancing";
		case DTSEventTypeActivityHiking:
			return @"Hiking";
		case DTSEventTypeActivityRunning:
			return @"Running";
		case DTSEventTypeActivitySwimming:
			return @"Swimming";
		case DTSEventTypeActivityWalking:
			return @"Walking";
		case DTSEventTypeRestaurant:
			return @"Restaurant";
		case DTSEventTypeSleep:
			return @"Sleeping";
		case DTSEventTypeTravelCar:
			return @"Travel by Car";
		case DTSEventTypeTravelFlight:
			return @"Travel by Flight";
		case DTSEventTypeTravelRoad:
			return @"Travel by Road";
		case DTSEventTypeTravelWater:
			return @"Travel by Water";
			
		default:
			return @"Other";
	}
}

- (NSArray *)eventTypeStringsArray
{
	NSMutableArray *eventsArray = [NSMutableArray array];
	for (int i = 0; i < 14; i++)
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

- (void)copyFromEvent:(DTSEvent *)event
{
	self.eventID = event.eventID;
	self.eventName = event.eventName;
	self.eventDescription = event.eventDescription;
	self.startDateTime = event.startDateTime;
	self.endDateTime = event.endDateTime;
	self.location = [event.location copy];
	self.eventType = event.eventType;
	self.isPlaceHolderEvent = event.isPlaceHolderEvent;
}


@end
