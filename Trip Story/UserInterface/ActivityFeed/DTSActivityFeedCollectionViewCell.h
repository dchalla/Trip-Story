//
//  DTSActivityFeedLikeCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 6/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSActivity.h"

@interface DTSActivityFeedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) DTSActivity *activity;
@property (weak, nonatomic) IBOutlet UILabel *hoursAgoLabel;

- (void)updateUIWithActivity:(DTSActivity *)activity;

@end
