//
//  DTSTimelineCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/14/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"

@interface DTSTimelineCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *leftCircleView;
@property (weak, nonatomic) IBOutlet UIView *rightCircleView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIView *springView;
@property (weak, nonatomic) IBOutlet UIView *eventsColorView;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripTagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *byUserLabel;

@property (weak, nonatomic) IBOutlet UIView *colorView1;
@property (weak, nonatomic) IBOutlet UIView *colorView2;
@property (weak, nonatomic) IBOutlet UIView *colorView3;
@property (weak, nonatomic) IBOutlet UIView *colorView4;
@property (weak, nonatomic) IBOutlet UIView *colorView5;
@property (weak, nonatomic) IBOutlet UIView *colorView6;
@property (weak, nonatomic) IBOutlet UIView *colorView7;
@property (weak, nonatomic) IBOutlet UIView *colorView8;
@property (weak, nonatomic) IBOutlet UIView *colorView9;
@property (weak, nonatomic) IBOutlet UIView *colorView10;
@property (weak, nonatomic) IBOutlet UIView *colorView11;

@property (weak, nonatomic) IBOutlet UIImageView *colorImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView5;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView6;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView7;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView8;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView9;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView10;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView11;

@property (nonatomic, strong) NSArray *colorViewsArray;
@property (nonatomic, strong) NSArray *colorImageViewsArray;


@property (nonatomic,strong) DTSTrip *trip;
- (void)updateViewWithTrip:(DTSTrip *)trip;

@end
