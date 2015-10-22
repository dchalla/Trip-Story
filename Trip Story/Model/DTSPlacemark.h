//
//  DTSPlacemark.h
//  Trip Story
//
//  Created by Dinesh Challa on 2/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import <MapKit/MKMapItem.h>

@interface DTSPlacemark : PFObject<PFSubclassing>

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

@property (nonatomic, strong) NSDictionary *addressDictionary;
@property (nonatomic, readonly) MKMapItem *mapItem;
@property (nonatomic, readonly) MKPlacemark *mkplacemark;

+(NSString *)parseClassName;
- (void)updateWithMkMapItem:(MKMapItem *)mapItem;

@end
