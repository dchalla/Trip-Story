//
//  DTSTrip.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/12/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSEvent.h"

@interface DTSTrip : NSObject

@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *tripDescription;
@property (nonatomic, strong) NSNumber *tripRating;
@property (nonatomic, strong) NSNumber *numberOfRatings;
@property (nonatomic, strong) NSString *tripRatingListID;
@property (nonatomic, strong) NSMutableArray *eventsList;
@property (nonatomic, strong) NSMutableArray *locationsList;
@property (nonatomic, strong) NSMutableArray *originalEventsList;

- (void)createDummyEventsList;
- (void)addEvent:(DTSEvent *)event;
- (DTSEvent *)newEvent;
- (void)fillInPlaceholderEvents;
- (NSArray *)eventsDurationArray;
- (NSString *)tripDurationString;
- (NSNumber *)tripDurationHours;

@end
