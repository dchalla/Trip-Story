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
#import "DTSAnalyticsProtocol.h"
#import <Google/Analytics.h>

#define DTSTimelineCellHeight 250
#define DTSTimelineCellWithMapHeight 389
#define DTSTimelineCellIpadSpacer 5

static NSString * const reuseIdentifier = @"DTSTripCollectionViewCell";
static NSString * const reuseIdentifierWithMap = @"DTSTripCollectionViewCellWithMap";

@interface DTSTimelineCollectionViewController : PFQueryCollectionViewController<UICollectionViewDelegateFlowLayout,DTSViewLayoutProtocol, DTSAnalyticsProtocol>

@property (nonatomic, assign) BOOL requiresLogin;

- (UICollectionViewCell *)dtsCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)dtsDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)dtsDefaultItemSizeWithHeight:(CGFloat)height;
- (void)refreshView;
- (void)showNoResultsHUD;

@end
