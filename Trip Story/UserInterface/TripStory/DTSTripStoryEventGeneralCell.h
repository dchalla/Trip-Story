//
//  DTSTripStoryEventGeneralCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/3/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"
#import "DTSTableViewCellParallaxProtocol.h"

@interface DTSTripStoryEventGeneralCell : UITableViewCell<DTSTableViewCellParallaxProtocol>

@property (nonatomic, strong) IBOutlet UIView *eventLineView;
@property (nonatomic, weak) IBOutlet UILabel *startTimelabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parallaxImageView;
@property (weak, nonatomic) IBOutlet UIView *parallaxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parallaxImageViewOriginYConstraint;


- (void)updateWithEvent:(DTSEvent *)event isFirstCell:(BOOL)isFirstCell;
@end
