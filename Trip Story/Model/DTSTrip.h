//
//  DTSTrip.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/12/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSEvent.h"
#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import "DTSConstants.h"

extern NSString *const kDTSTripUserKey;

@interface DTSTrip : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *tripDescription;
@property (nonatomic, strong) NSNumber *tripRating;
@property (nonatomic, strong) NSString *tripTagsForSearch;
@property (nonatomic, strong) NSNumber *numberOfRatings;
@property (nonatomic, strong) NSString *tripRatingListID;
@property (nonatomic, strong) NSMutableArray *eventsList;
@property (nonatomic, strong) NSMutableArray *locationsList;
@property (nonatomic, strong) NSMutableArray *originalEventsList;
@property (nonatomic, readonly) NSArray *eventsWithLocationList;
@property (nonatomic,assign) DTSPrivacy privacy;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSMutableArray *tripPhotosList;
@property (nonatomic, readonly) NSString *tripTagsString;
@property (nonatomic, readonly) NSDictionary *tripEventTypeColorDict;
@property (nonatomic, readonly) NSString *tripDurationString;

- (void)createDummyEventsList;
- (void)addEvent:(DTSEvent *)event;
- (DTSEvent *)newEvent;
- (void)fillInPlaceholderEvents;
- (NSArray *)eventsDurationArray:(BOOL)forPieView;
- (NSNumber *)tripDurationHours;
- (NSArray *)startAndEndTravelEventsArray;
- (NSArray *)listOfTravelEvents;
- (NSArray *)startEndEventSetForEvent:(DTSEvent *)event;
- (DTSEvent *)nextEventWithLocationForEvent:(DTSEvent *)event;
- (NSDate *)startTimeOfTrip;
- (NSDate *)endTimeOfTrip;
- (NSArray *)tripTagsArray;
- (NSArray *)tripCityStateArray;
- (NSArray *)tripEventTypeStringsArray;
- (NSArray *)tripMkMapItems;
- (NSString *)tripYearsString;

+ (NSString *)parseClassName;

@end
