//
//  DTSTripDetailsMapViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/16/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"
#import <MapKit/MapKit.h>
#import "DTSViewLayoutProtocol.h"
#import "DTSTripDetailsProtocol.h"

@interface DTSTripDetailsMapViewController : UIViewController<MKMapViewDelegate, DTSViewLayoutProtocol, DTSTripDetailsProtocol>
@end
