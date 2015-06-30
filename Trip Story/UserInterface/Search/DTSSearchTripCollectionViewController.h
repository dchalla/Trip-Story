//
//  DTSSearchTripCollectionViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 6/2/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTimelineCollectionViewController.h"
#import "DTSSearchRootViewControllerProtocol.h"
#import "DTSAnalyticsProtocol.h"

@interface DTSSearchTripCollectionViewController : DTSTimelineCollectionViewController<DTSSearchRootViewControllerProtocol, DTSAnalyticsProtocol>

@end
