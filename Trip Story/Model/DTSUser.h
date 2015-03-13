//
//  DTSUser.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/12/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>

@interface DTSUser : PFUser<PFSubclassing>

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) PFFile *profilePictureSmall;
@property (nonatomic, strong) PFFile *profilePictureMedium;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSArray *facebookFriends;
@property (nonatomic, strong) NSString *channel;

+ (NSString *)parseClassName;
@end
