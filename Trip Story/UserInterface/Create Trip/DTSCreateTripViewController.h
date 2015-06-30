//
//  DTSCreateTripViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/26/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSCreateEditTripView.h"
#import "DTSAnalyticsProtocol.h"

@protocol DTSCreateTripViewControllerProtocol <NSObject>

- (void)deletedTrip;

@end

@interface DTSCreateTripViewController : UIViewController<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,DTSCreateEditTripViewProtocol, DTSAnalyticsProtocol>

@property (nonatomic) BOOL isCreateTripMode;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, assign) BOOL presenting;

@property (nonatomic, weak) id<DTSCreateTripViewControllerProtocol> delegate;
@end
