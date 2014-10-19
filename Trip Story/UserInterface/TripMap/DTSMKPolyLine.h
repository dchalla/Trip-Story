//
//  DTSMKPolyLine.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DTSEvent.h"

@interface DTSMKPolyLine : MKPolyline

@property (nonatomic) DTSEventType eventType;

@end
