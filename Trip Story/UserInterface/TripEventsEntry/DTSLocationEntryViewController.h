//
//  DTSLocationEntryViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/22/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSModalDismissProtocol.h"
#import "DTSEntryTableViewCellDelegate.h"
#import "DTSTrip.h"
#import "DTSAnalyticsProtocol.h"
#import <Google/Analytics.h>


@interface DTSLocationEntryViewController : UIViewController <UISearchBarDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UITableViewDelegate, UITableViewDataSource, DTSAnalyticsProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *blurredBackgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *topNavigationBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) id<DTSModalDismissProtocol> dismissDelegate;
@property (nonatomic, assign) BOOL presenting;
@property (weak, nonatomic) IBOutlet UIView *searchModalView;
@property (weak, nonatomic) IBOutlet UILabel *searchingLabel;
@property (weak, nonatomic) id<DTSEntryTableViewCellDelegate> entryDelegate;
@property (nonatomic, strong) DTSTrip *trip;

@end
