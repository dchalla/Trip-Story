//
//  DTSEventsViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "TGLStackedViewController.h"
#import "DTSTrip.h"
#import "DTSViewLayoutProtocol.h"
#import "DTSTripDetailsProtocol.h"
#import "DTSTripEventsCollectionViewCell.h"
#import "DTSTripDetailsContainerDelegate.h"
#import "DTSAnalyticsProtocol.h"


@interface DTSTripEventsViewController : TGLStackedViewController <DTSViewLayoutProtocol, DTSTripDetailsProtocol,DTSTripEventsCollectionViewCellDelegate, DTSAnalyticsProtocol>

@property (nonatomic, weak) id <DTSTripDetailsContainerDelegate> containerDelegate;

- (void)openEvent:(DTSEvent *)inEvent;
- (void)refreshView;

@end
