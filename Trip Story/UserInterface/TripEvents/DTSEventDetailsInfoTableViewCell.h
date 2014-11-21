//
//  DTSEventDetailsInfoTableViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 11/20/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"

@interface DTSEventDetailsInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topCircleView;
@property (weak, nonatomic) IBOutlet UIView *bottomCircleView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *middleCircleView;
@property (weak, nonatomic) IBOutlet UIView *informationBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (nonatomic,strong) DTSEvent *event;
- (void)updateViewWithEvent:(DTSEvent *)event;

@end
