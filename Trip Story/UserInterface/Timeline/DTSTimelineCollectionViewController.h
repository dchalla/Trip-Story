//
//  DTSTimelineCollectionViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/16/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "PFQueryCollectionViewController.h"
#import "DTSViewLayoutProtocol.h"
#import "DTSTrip.h"
#import "DTSTripDetailsViewController.h"
#import "DTSUserAuthHelper.h"
#import "UIColor+Utilities.h"
#import "DTSTimelineCollectionViewCell.h"
#import "DTSActivity.h"

static NSString * const reuseIdentifier = @"DTSTripCollectionViewCell";

@interface DTSTimelineCollectionViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol>

- (UICollectionViewCell *)dtsCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)dtsDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)dtsDefaultItemSize;

@end
