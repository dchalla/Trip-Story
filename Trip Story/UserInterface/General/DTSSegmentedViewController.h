//
//  DTSSegmentedViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 3/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSViewLayoutProtocol.h"
#import "HMSegmentedControl.h"

@interface DTSSegmentedViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,DTSViewLayoutProtocol>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) NSArray *pagedViewControllers;

//Override this to return set of viewControllers
- (NSArray *)pagedViewControllersList;
//override this to return segment names for view controllers
- (NSArray *)segmentNamesList;

- (id)currentPageVC;
- (void)pageViewControllerCurrentVCChanged;

@end
