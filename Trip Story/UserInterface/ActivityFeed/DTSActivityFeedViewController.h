//
//  DTSActivityFeedViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 6/4/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFQueryCollectionViewController.h"
#import "DTSViewLayoutProtocol.h"
#import <Parse/Parse.h>
#import "DTSAnalyticsProtocol.h"

@interface DTSActivityFeedViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol,DTSAnalyticsProtocol>

@end
