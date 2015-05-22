//
//  DTSTripStoryFooterView.h
//  Trip Story
//
//  Created by Dinesh Challa on 5/20/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"

@protocol DTSTripStoryFooterViewDelegate <NSObject>

- (void)tripStoryFooterViewAddEventTapped;

@end

@interface DTSTripStoryFooterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, weak) id<DTSTripStoryFooterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *tripStoryLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *tripStoryLogoLabel;
@property (nonatomic) BOOL isSharing;

- (void)updateView;

@end
