//
//  DTSTripStoryEventGeneralCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"

@interface DTSTripStoryEventGeneralCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *eventLineView;
@property (nonatomic, weak) IBOutlet UILabel *startTimelabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;


- (void)updateWithEvent:(DTSEvent *)event;
@end
