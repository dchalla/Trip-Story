//
//  DTSTripEventDetailsViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 11/19/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"

@interface DTSTripEventDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;

- (void)updateViewWithEvent:(DTSEvent *)event;
@end
