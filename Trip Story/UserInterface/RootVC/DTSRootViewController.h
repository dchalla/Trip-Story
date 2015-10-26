//
//  DTSRootViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSViewLayoutProtocol.h"
#import "DKCRateFeedbackPrompt.h"

typedef enum {
	DTSRootViewControllerSegmenetTimeline= 0,
	DTSRootViewControllerSegmenetSearch,
	DTSRootViewControllerSegmenetCreateTrip,
	DTSRootViewControllerSegmenetUser,
	DTSRootViewControllerSegmenetActivity
}DTSRootViewControllerSegmenet;

@interface DTSRootViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,DKCRateFeedbackPromptProtocol>


- (void)openSegment:(DTSRootViewControllerSegmenet)segement;

@end
