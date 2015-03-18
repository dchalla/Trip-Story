//
//  DTSTrip.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/12/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSTrip.h"

#import "NSDate+Utilities.h"
#import "NSString+Utilities.h"
#import <PFObject+Subclass.h>

NSString *const kDTSTripUserKey		= @"user";

@interface DTSTrip() {
	NSMutableArray *_eventsList;
}

@end

@implementation DTSTrip

@dynamic tripDescription;
@dynamic tripName;
@dynamic tripRating;
@dynamic tripRatingListID;
@dynamic locationsList;
@dynamic originalEventsList;
@dynamic numberOfRatings;
@dynamic user;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"DTSTrip";
}

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}

- (NSMutableArray *)eventsList
{
	return _eventsList;
}

- (void)setEventsList:(NSMutableArray *)eventsList
{
	_eventsList = eventsList;
}

- (NSMutableArray *)originalEventsList
{
	if (![self objectForKey:@"originalEventsList"])
	{
		self.originalEventsList = [NSMutableArray array];
	}
	return [self objectForKey:@"originalEventsList"];
}

- (void)setOriginalEventsList:(NSMutableArray *)originalEventsList
{
	[self setObject:originalEventsList forKey:@"originalEventsList"];
}

- (void)createDummyEventsList
{
	int j = DTSEventTypeActivity;
	for (int i=0; i <= 10; i++)
	{
		DTSEvent *event = [DTSEvent object];
		event.eventName = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		event.eventDescription = @"Funtime, Lets go Kayaking. It was so much fun to enjoy our trip. Its Truly heaven.";
		event.eventID = [NSString stringWithFormat:@"%@%d",@"Dummy Event",i];
		if (i%2 == 0)
		{
			event.eventType = j++;
		}
		else
		{
			event.eventType = DTSEventTypeTravelByRoad;
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
	DTSEvent *newEvent = [DTSEvent object];
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
	DTSEvent *placeHolderEvent = [DTSEvent object];
	placeHolderEvent.isPlaceHolderEvent = YES;
	placeHolderEvent.eventName = @"Unknown";
	placeHolderEvent.eventID = @"placeHolder";
	placeHolderEvent.startDateTime = previousEvent.endDateTime;
	placeHolderEvent.endDateTime = nextEvent.startDateTime;
	
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
			return DTSEventTypeTravelByAir;
		}
		else if (speed > 20 && speed<=150)
		{
			return DTSEventTypeTravelByRoad;
		}
		else if (speed > 10 && speed<=20)
		{
			return DTSEventTypeTravelByRoad;
		}
		else
		{
			return DTSEventTypeTravelByRoad;
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


- (NSArray *)eventsDurationArray
{
	NSMutableArray *eventsArray = [NSMutableArray array];
	for (int i = 0; i < 10; i++)
	{
		[eventsArray addObject:[self eventTypeDurationInTrip:i]];
	}
	return [eventsArray copy];
}

- (NSNumber *)eventTypeDurationInTrip:(DTSEventType)eventType
{
	NSArray *events = [self allTripEventsOfEventType:eventType];
	CGFloat duration = 0;
	for (DTSEvent *event in events)
	{
		duration += event.eventHours.floatValue;
	}
	return @(duration);
}

- (NSString *)tripDurationString
{
	NSNumber *tripHours = [self tripDurationHours];
	return [NSString durationStringForHours:tripHours];
}

- (NSNumber *)tripDurationHours
{
	CGFloat totalduration = 0;
	for (DTSEvent *event in self.eventsList)
	{
		totalduration = event.eventHours.floatValue + totalduration;
	}
	return @(totalduration);
}


- (NSArray *)allTripEventsOfEventType:(DTSEventType)eventType
{
	NSMutableArray *eventsArray = [NSMutableArray array];
	for (DTSEvent *event in self.eventsList)
	{
		if (event.eventType == eventType)
		{
			[eventsArray addObject:event];
		}
	}
	return [eventsArray copy];
}


- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

- (NSArray *)eventsWithLocationList
{
	NSMutableArray *eventsWithLocationList = [NSMutableArray array];
	for (DTSEvent *event in self.eventsList)
	{
		if (event.location && event.location.mapItem)
		{
			[eventsWithLocationList addObject:event];
		}
	}
	return [eventsWithLocationList copy];
}

- (NSArray *)startAndEndTravelEventsArray
{
	NSMutableArray *startAndEndTravelEventsArray = [NSMutableArray array];
	NSArray *listOfTravelEvents = [self listOfTravelEvents];
	for (DTSEvent *event in listOfTravelEvents)
	{
		DTSEvent *eventWithLocation = event;
		if (!(event.location && event.location.mapItem))
		{
			DTSLocation *foundLocation = [self locationForTravelEvent:event];
			if (foundLocation)
			{
				DTSEvent *copiedEvent = [DTSEvent eventFromEvent:event];
				copiedEvent.location = foundLocation;
				eventWithLocation = copiedEvent;
			}
		}
		NSArray *startAndEndEventSet = [self startEndEventSetForEvent:eventWithLocation];
		if (startAndEndEventSet)
		{
			[startAndEndTravelEventsArray addObject:startAndEndEventSet];
		}
	}
	return [startAndEndTravelEventsArray copy];
}

- (NSArray *)listOfTravelEvents
{
	NSMutableArray *listOfTravelEvents = [NSMutableArray array];
	for (DTSEvent *event in self.eventsList)
	{
		if (event.isTravelEvent)
		{
			[listOfTravelEvents addObject:event];
		}
	}
	return [listOfTravelEvents copy];
}

- (NSArray *)startEndEventSetForEvent:(DTSEvent *)event
{
	if ([event.eventID isEqualToString:((DTSEvent *)self.eventsList.firstObject).eventID])
	{//if first event then pair is next event
		DTSEvent *eventPair = [self nextEventWithLocationForEvent:event];
		if (eventPair)
		{
			return @[event,eventPair];
		}
	}
	else
	{//if not first event then pair is previous event
		DTSEvent *eventPair = [self previousEventWithLocationForEvent:event];
		if (eventPair)
		{
			return @[eventPair,event];
		}
	}
	return nil;
}

- (DTSEvent *)nextEventWithLocationForEvent:(DTSEvent *)event
{
	BOOL foundGivenEvent = NO;
	for (DTSEvent *eventInList in self.eventsList)
	{
		if (foundGivenEvent && eventInList.location && eventInList.location.mapItem)
		{
			return eventInList;
		}
		if ([event.eventID isEqualToString:eventInList.eventID])
		{
			foundGivenEvent = YES;
		}
	}
	return nil;
}

- (DTSEvent *)previousEventWithLocationForEvent:(DTSEvent *)event
{
	BOOL foundGivenEvent = NO;
	for (DTSEvent *eventInList in [self.eventsList reverseObjectEnumerator])
	{
		if (foundGivenEvent && eventInList.location && eventInList.location.mapItem)
		{
			return eventInList;
		}
		if ([event.eventID isEqualToString:eventInList.eventID])
		{
			foundGivenEvent = YES;
		}
	}
	return nil;
}

- (DTSLocation *)locationForTravelEvent:(DTSEvent *)travelEvent
{
	if (travelEvent.isTravelEvent)
	{
		BOOL foundGivenEvent = NO;
		for (DTSEvent *eventInList in self.eventsList)
		{
			if (foundGivenEvent && eventInList.location && eventInList.location.mapItem)
			{
				if (eventInList.isTravelEvent)
				{
					return nil;
				}
				else
				{
					return eventInList.location;
				}
			}
			if ([travelEvent.eventID isEqualToString:eventInList.eventID])
			{
				foundGivenEvent = YES;
			}
		}
	}
	return nil;
}

- (NSDate *)startTimeOfTrip
{
	DTSEvent *firstEvent = self.eventsList.firstObject;
	if (firstEvent)
	{
		return firstEvent.startDateTime;
	}
	return nil;
}

- (NSDate *)endTimeOfTrip
{
	DTSEvent *lastEvent = self.eventsList.lastObject;
	if (lastEvent)
	{
		return lastEvent.endDateTime;
	}
	return nil;
}

- (NSDictionary *)tripEventTypeColorDict
{
	NSMutableDictionary *eventsTypeDict = [NSMutableDictionary dictionary];
	for (DTSEvent *event in self.originalEventsList)
	{
		[eventsTypeDict setObject:[DTSEvent topColorForEventType:event.eventType] forKey:@(event.eventType)];
	}
	return [eventsTypeDict copy];
}

- (NSString *)tripTagsString
{
	return [[self tripTagsArray] componentsJoinedByString:@", "];
}

- (NSArray *)tripTagsArray
{
	NSArray *tripCityStateArray = [self tripCityStateArray];
	NSArray *tripEventTypeStringsArray = [self tripEventTypeStringsArray];
	return [tripCityStateArray arrayByAddingObjectsFromArray:tripEventTypeStringsArray];
}

- (NSArray *)tripCityStateArray
{
	NSMutableArray *countryStateCityNameArray = [NSMutableArray array];
	
	NSMutableDictionary *stateDict = [NSMutableDictionary dictionary];
	NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
	NSMutableDictionary *countryDict = [NSMutableDictionary dictionary];
	NSMutableDictionary *nameDict = [NSMutableDictionary dictionary];
	
	NSArray *eventsWithLocation = [self eventsWithLocationList];
	
	for (DTSEvent *event in eventsWithLocation)
	{
		NSString *city = event.location.mapItem.placemark.locality;
		NSString *state = event.location.mapItem.placemark.administrativeArea;
		NSString *country = event.location.mapItem.placemark.country;
		NSString *name = event.location.dtsPlacemark.mkplacemark.name;
		if (name.length > 0 && !stateDict[name] && !cityDict[name] && !nameDict[name] && !countryDict[name])
		{
			nameDict[name] = name;
		}
		if (city.length > 0 && !stateDict[city] && !cityDict[city] && !nameDict[city] && !countryDict[city])
		{
			cityDict[city] = city;
		}
		if (state.length > 0 && !stateDict[state] && !cityDict[state] && !nameDict[state] && !countryDict[state])
		{
			stateDict[state] = state;
		}
		if (country.length > 0 && !stateDict[country] && !cityDict[country] && !nameDict[country] && !countryDict[country])
		{
			countryDict[country] = country;
		}
	}
	NSArray *dictArray = @[countryDict,stateDict,cityDict,nameDict];
	for (int i = 0; i < 4; i++)
	{
		NSMutableDictionary *dict = dictArray[i];
		for (NSString *mapItemString in dict)
		{
			[countryStateCityNameArray addObject:mapItemString];
		}
	}
	return [countryStateCityNameArray copy];
}

- (NSArray *)tripEventTypeStringsArray
{
	NSMutableArray *tripEventTypeStringsArray = [NSMutableArray array];
	NSMutableDictionary *eventsTypeDict = [NSMutableDictionary dictionary];
	for (DTSEvent *event in self.originalEventsList)
	{
		[eventsTypeDict setObject:[event eventTypeStringForEventType:event.eventType] forKey:@(event.eventType)];
	}
	[eventsTypeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *eventType, NSString *eventTypeString, BOOL *stop){
		[tripEventTypeStringsArray addObject:eventTypeString];
	}];
	
	return [tripEventTypeStringsArray copy];
}



@end
