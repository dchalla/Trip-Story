//
//  DTSCreateTripViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/26/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSCreateEditTripView.h"

@interface DTSCreateTripViewController : UIViewController<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,DTSCreateEditTripViewProtocol>

@property (nonatomic) BOOL isCreateTripMode;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, assign) BOOL presenting;
@end