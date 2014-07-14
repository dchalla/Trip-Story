//
//  DTSTrip.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/12/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTrip.h"
#import "DTSEvent.h"
#import "NSDate+Utilities.h"

@implementation DTSTrip


- (void)createDummyEventsList
{
	self.originalEventsList = [NSMutableArray array];
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

- (void)fillInPlaceholderEvents
{
	[self sortEventsBasedOnTime:self.originalEventsList];
	int i = 0;
	for (DTSEvent *event in self.originalEventsList)
	{
		if (i != 0 && i < self.originalEventsList.count -1)
		{
			
			DTSEvent *previousEvent =self.originalEventsList[i-1];
			CGFloat hoursDifference = [previousEvent.endDateTime hoursBeforeDate:event.startDateTime];
			if (hoursDifference > 1)
			{
				DTSEvent *placeHolderEvent = [self placeHolderEventWithStartDateTime:previousEvent.endDateTime endDateTime:event.startDateTime];
				[self.eventsList addObject:placeHolderEvent];
			}
			[self.eventsList addObject:event];
		}
		else if (i==0)
		{
			self.eventsList = [NSMutableArray array];
			[self.eventsList addObject:event];
		}
		i++;
	}
	[self sortEventsBasedOnTime:self.eventsList];
}

- (DTSEvent *)placeHolderEventWithStartDateTime:(NSDate *)startDateTime endDateTime:(NSDate *)endDateTime
{
	DTSEvent *placeHolderEvent = [[DTSEvent alloc] init];
	placeHolderEvent.isPlaceHolderEvent = YES;
	placeHolderEvent.eventName = @"Unknown";
	placeHolderEvent.eventID = @"placeHolder";
	placeHolderEvent.eventType = DTSEventTypePlaceholder;
	placeHolderEvent.startDateTime = startDateTime;
	placeHolderEvent.endDateTime = endDateTime;
	return placeHolderEvent;
}

- (void)sortEventsBasedOnTime:(NSMutableArray *)eventList
{
	NSArray *sortedArray;
	sortedArray = [eventList sortedArrayUsingComparator:^NSComparisonResult(DTSEvent *a, DTSEvent *b) {
		NSDate *first = a.startDateTime;
		NSDate *second = b.startDateTime;
		return [first compare:second];
	}];
	eventList = [sortedArray mutableCopy];
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

@end
