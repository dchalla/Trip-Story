//
//  DTSEvent.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSLocation.h"

typedef enum {
	DTSEventTypeActivity = 0,
	DTSEventTypeActivityHiking,
	DTSEventTypeActivitySwimming,
	DTSEventTypeActivityAdventure,
	DTSEventTypeActivityRunning,
	DTSEventTypeActivityBiking,
	DTSEventTypeActivityWalking,
	DTSEventTypeActivityDancing,
	DTSEventTypeTravelFlight,
	DTSEventTypeTravelCar,
	DTSEventTypeTravelWater,
	DTSEventTypeTravelRoad,
	DTSEventTypeRestaurant,
	DTSEventTypeSleep,
	DTSEventTypePlaceholder,
}DTSEventType;

typedef enum {
	DTSEventKindActivity,
	DTSEventKindGeneral,
	DTSEventKindUnknown
}DTSEventKind;

@interface DTSEvent : NSObject

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSDate *startDateTime;
@property (nonatomic, strong) NSDate *endDateTime;
@property (nonatomic, strong) DTSLocation *location;
@property (nonatomic) DTSEventType eventType;
@property (nonatomic, readonly) DTSEventKind eventKind;
@property (nonatomic) BOOL isPlaceHolderEvent;
@property (nonatomic, readonly) UIColor *eventTopColor;
@property (nonatomic, readonly) UIColor *eventBottomColor;
@property (nonatomic, readonly) NSNumber *eventHours;
@property (nonatomic, readonly) CGFloat tripStoryCellHeight;

- (NSString *)eventTypeStringForEventType:(DTSEventType)type;
- (NSArray *)eventTypeStringsArray;

@end
