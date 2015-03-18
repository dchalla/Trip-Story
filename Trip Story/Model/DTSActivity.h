//
//  DTSActivity.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/12/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import "DTSTrip.h"

extern NSString *const kDTSActivityTypeLike;
extern  NSString *const kDTSActivityTypeFollow;
extern NSString *const kDTSActivityTypeComment;
extern NSString *const kDTSActivityTypeJoined;

extern NSString *const kDTSActivityTypeKey;
extern NSString *const kDTSActivityFromUserKey;
extern NSString *const kDTSActivityToUserKey;
extern NSString *const kDTSActivityContentKey;
extern NSString *const kDTSActivityTripKey;

@interface DTSActivity : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *toUser;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) DTSTrip *trip;

+ (NSString *)parseClassName;
@end
