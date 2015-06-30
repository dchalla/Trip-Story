//
//  DTSFollowFriendsViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFQueryCollectionViewController.h"
#import "DTSViewLayoutProtocol.h"
#import "DTSAnalyticsProtocol.h"

typedef enum {
	DTSFindFriendsFollowingNone = 0,    // User isn't following anybody in Friends list
	DTSFindFriendsFollowingAll,         // User is following all Friends
	DTSFindFriendsFollowingSome         // User is following some of their Friends
} DTSFindFriendsFollowStatus;

@interface DTSFollowFriendsViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol, DTSAnalyticsProtocol>
@property (nonatomic, assign) DTSFindFriendsFollowStatus followStatus;
@end
