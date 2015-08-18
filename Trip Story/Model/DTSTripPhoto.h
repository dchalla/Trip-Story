//
//  DTSTripPhoto.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import "DTSLocation.h"

@interface DTSTripPhoto : PFObject <PFSubclassing>

@property (nonatomic, strong) DTSLocation *location;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSDate *imageCreationDate;
@property (nonatomic, strong) NSNumber *pixelWidth;
@property (nonatomic, strong) NSNumber *pixelHeight;
@property (nonatomic, strong) NSString *assetID;

+ (NSString *)parseClassName;

@end
