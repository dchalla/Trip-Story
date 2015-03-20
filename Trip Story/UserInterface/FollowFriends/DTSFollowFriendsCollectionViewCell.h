//
//  DTSFollowFriendsCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "DTSCache.h"

@interface DTSFollowFriendsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic) BOOL showFollowButton;

@property (nonatomic, strong) PFUser *user;

- (void)updateUIWithUser:(PFUser *)user;

@end
