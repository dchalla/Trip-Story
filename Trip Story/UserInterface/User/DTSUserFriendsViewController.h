//
//  DTSUserFriendsViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/19/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFQueryCollectionViewController.h"
#import "DTSViewLayoutProtocol.h"
#import <Parse/Parse.h>

@interface DTSUserFriendsViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic) BOOL forFollowers;
- (NSString *)navigationTitle;
@end
