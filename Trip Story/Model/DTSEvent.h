//
//  DTSEvent.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSLocation.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>

typedef enum {
	DTSEventTypeActivity = 0,
	DTSEventTypeActivityStayHotel,
	DTSEventTypeActivityDining,
	DTSEventTypeActivitySightSeeing,
	DTSEventTypeActivityHiking,
	DTSEventTypeActivityBiking,
	DTSEventTypeActivityWaterSports,
	DTSEventTypeTravelByRoad,
	DTSEventTypeTravelByAir,
	DTSEventTypeTravelByWater,
	DTSEventTypePlaceholder,
}DTSEventType;

typedef enum {
	DTSEventKindActivity,
	DTSEventKindTravel,
	DTSEventKindUnknown
}DTSEventKind;

@interface DTSEvent : PFObject<MKAnnotation,PFSubclassing>

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
@property (nonatomic, readonly) BOOL isTravelEvent;

- (NSString *)eventTypeStringForEventType:(DTSEventType)type;
- (NSArray *)eventTypeStringsArray;
- (void)copyFromEvent:(DTSEvent *)event;
+ (DTSEvent *)eventFromEvent:(DTSEvent *)event;

+ (UIColor *)topColorForEventType:(DTSEventType)eventType;
+ (UIColor *)bottomColorForEventType:(DTSEventType)eventType;

+ (NSString *)parseClassName;
+ (DTSEvent *)newEvent;

@end
