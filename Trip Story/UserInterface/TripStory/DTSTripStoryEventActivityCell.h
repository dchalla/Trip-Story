//
//  DTSTripStoryEventActivityCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"

@interface DTSTripStoryEventActivityCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *bubbleView;
@property (nonatomic, weak) IBOutlet UILabel *startTimelabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventNameLabel;

- (void)updateWithEvent:(DTSEvent *)event;


@end
