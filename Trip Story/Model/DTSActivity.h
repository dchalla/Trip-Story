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

NSString *const kDTSActivityTypeLike       = @"like";
NSString *const kDTSActivityTypeFollow     = @"follow";
NSString *const kDTSActivityTypeComment    = @"comment";
NSString *const kDTSActivityTypeJoined     = @"joined";

@interface DTSActivity : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *topUser;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) DTSTrip *trip;

+ (NSString *)parseClassName;
@end
