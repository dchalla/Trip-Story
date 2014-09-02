//
//  DTSTripStoryHeaderView.h
//  Trip Story
//
//  Created by Dinesh Challa on 9/1/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"
@interface DTSTripStoryHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tripTitle;
@property (weak, nonatomic) IBOutlet UIView *pieView;
@property (weak, nonatomic) IBOutlet UILabel *tripDurationLabel;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, assign) BOOL viewAppeared;

@end
