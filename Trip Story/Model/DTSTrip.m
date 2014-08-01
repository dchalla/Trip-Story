//
//  DTSTrip.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/12/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTrip.h"

#import "NSDate+Utilities.h"

@implementation DTSTrip

- (NSMutableArray *)originalEventsList
{
	if (!_originalEventsList)
	{
		_originalEventsList = [NSMutableArray array];
	}
	return _originalEventsList;
}

- (void)createDummyEventsList
{
	int j = DTSEventTypeActivity;
	for (int i=0; i <= 10; i++)
	{
		DTSEvent *event = [[DTSEvent alloc] init];
		event.eventName = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		event.eventDescription = @"Fun time, go Kayaking";
		event.eventID = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		if (i%2 == 0)
		{
			event.eventType = j++;
		}
		else
		{
			event.eventType = DTSEventTypeTravelCar;
		}
		
		event.startDateTime = [[NSDate date] dateByAddingHours:i*10];
		event.endDateTime = [event.startDateTime dateByAddingHours:[ self getRandomNumberBetween:1 maxNumber:10]];
		[self.originalEventsList addObject:event];
	}
	[self fillInPlaceholderEvents];
}

- (void)addEvent:(DTSEvent *)event
{
	[self.originalEventsList addObject:event];
	[self fillInPlaceholderEvents];
}

- (DTSEvent *)newEvent
{
	DTSEvent *event = [self.originalEventsList lastObject];
	DTSEvent *newEvent = [[DTSEvent alloc] init];
	if (event)
	{
		newEvent.startDateTime = event.endDateTime;
	}
	return newEvent;
}

- (void)fillInPlaceholderEvents
{
	[self sortOriginalList];
	int i = 0;
	self.eventsList = [NSMutableArray array];
	for (DTSEvent *event in self.originalEventsList)
	{
		if (i != 0 && i < self.originalEventsList.count)
		{
			
			DTSEvent *previousEvent =self.originalEventsList[i-1];
			CGFloat hoursDifference = [previousEvent.endDateTime hoursBeforeDate:event.startDateTime];
			if (hoursDifference > 0.5)
			{
				DTSEvent *placeHolderEvent = [self placeHolderEventWithPreviousEvent:previousEvent nextEvent:event];
				[self.eventsList addObject:placeHolderEvent];
			}
		}
		[self.eventsList addObject:event];
		i++;
	}
	[self sortEventsList];
}

- (DTSEvent *)placeHolderEventWithPreviousEvent:(DTSEvent *)previousEvent nextEvent:(DTSEvent *)nextEvent
{
	DTSEvent *placeHolderEvent = [[DTSEvent alloc] init];
	placeHolderEvent.isPlaceHolderEvent = YES;
	placeHolderEvent.eventName = @"Unknown";
	placeHolderEvent.eventID = @"placeHolder";
	placeHolderEvent.startDateTime = previousEvent.startDateTime;
	placeHolderEvent.endDateTime = previousEvent.endDateTime;
	
	placeHolderEvent.eventType = [self eventTypeForPlaceHolderEventBetweenPreviousEvent:previousEvent nextEvent:nextEvent];
	
	return placeHolderEvent;
}

- (DTSEventType)eventTypeForPlaceHolderEventBetweenPreviousEvent:(DTSEvent *)prevEvent nextEvent:(DTSEvent *)nextEvent
{
	if (prevEvent.location.mapItem && nextEvent.location.mapItem)
	{
		CLLocationDistance distance = [prevEvent.location.mapItem.placemark.location distanceFromLocation:nextEvent.location.mapItem.placemark.location];
		double disanceMiles =  distance * 0.00062137;
		double hours = [prevEvent.endDateTime hoursBeforeDate:nextEvent.startDateTime];
		double speed = disanceMiles/hours;
		if (speed > 150)
		{
			return DTSEventTypeTravelFlight;
		}
		else if (speed > 20 && speed<=150)
		{
			return DTSEventTypeTravelCar;
		}
		else if (speed > 10 && speed<=20)
		{
			return DTSEventTypeTravelRoad;
		}
		else
		{
			return DTSEventTypeActivityWalking;
		}
			
	}
	else
	{
		return DTSEventTypePlaceholder;
	}
}

- (NSMutableArray *)sortedEventsBasedOnTime:(NSMutableArray *)eventList
{
	NSArray *sortedArray;
	sortedArray = [eventList sortedArrayUsingComparator:^NSComparisonResult(DTSEvent *a, DTSEvent *b) {
		NSDate *first = a.startDateTime;
		NSDate *second = b.startDateTime;
		return [first compare:second];
	}];
	return [sortedArray mutableCopy];
}

- (void)sortOriginalList
{
	self.originalEventsList = [self sortedEventsBasedOnTime:self.originalEventsList];
}

- (void)sortEventsList
{
	self.eventsList = [self sortedEventsBasedOnTime:self.eventsList];
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

@end
