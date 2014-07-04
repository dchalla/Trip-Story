//
//  DTSEvent.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEvent.h"
#import "UIColor+Utilities.h"

@implementation DTSEvent

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

@end
