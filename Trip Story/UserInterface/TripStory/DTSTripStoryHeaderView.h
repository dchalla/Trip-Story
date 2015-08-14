//
//  DTSTripStoryHeaderView.h
//  Trip Story
//
//  Created by Dinesh Challa on 9/1/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"

@protocol DTSTripStoryHeaderViewDelegate <NSObject>

- (void)tripStoryHeaderViewEditButtonTapped;
- (void)shareButtonTapped:(id)sender;

@end

@interface DTSTripStoryHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tripTitle;
@property (weak, nonatomic) IBOutlet UIView *pieView;
@property (weak, nonatomic) IBOutlet UILabel *tripDurationLabel;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, assign) BOOL viewAppeared;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likeSmileyImageView;
@property (weak, nonatomic) IBOutlet UILabel *likedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLikeCommentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *byUserButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (nonatomic, weak) id<DTSTripStoryHeaderViewDelegate> delegate;

- (void)updateView;

@end
