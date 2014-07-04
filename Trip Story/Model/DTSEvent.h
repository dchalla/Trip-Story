//
//  DTSEvent.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DTSEventTypeTravelFlight = 1,
	DTSEventTypeTravelCar,
	DTSEventTypeRestaurant,
	DTSEventTypeActivity,
	DTSEventTypeActivityHiking,
	DTSEventTypeActivitySwimming,
	DTSEventTypeActivityAdventure,
	DTSEventTypeActivityRunning,
	DTSEventTypeActivityBiking,
	DTSEventTypeActivityWalking,
	DTSEventTypeActivityDancing,
	DTSEventTypeSleep,
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
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) DTSEventType eventType;
@property (nonatomic, readonly) DTSEventKind eventKind;
@property (nonatomic) BOOL isAutoCreatedEvent;
@property (nonatomic, readonly) UIColor *eventTopColor;
@property (nonatomic, readonly) UIColor *eventBottomColor;

@end
