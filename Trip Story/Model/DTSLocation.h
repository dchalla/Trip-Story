//
//  DTSLocation.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapItem.h>
#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import "DTSPlacemark.h"

@interface DTSLocation : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) NSNumber *locationZipcode;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *locationCountry;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) MKMapItem *mapItem;
@property (nonatomic, strong) DTSPlacemark *dtsPlacemark;
@property (nonatomic, readonly) NSString *displayLocationCityState;
@property (nonatomic, readonly) NSString *displayFullAddress;

+ (NSString *)parseClassName;

@end
