//
//  DTSEventsEntryTableViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSEventsEntryTableViewController.h"
#import "UIViewController+Utilities.h"
#import "DTSEventTextEntryTableViewCell.h"

#define kDTSEventTextEntryTableViewCell @"DTSEventTextEntryTableViewCell"


@interface DTSEventsEntryTableViewController ()

@end

@implementation DTSEventsEntryTableViewController

- (void)setBlurredBackgroundImage:(UIImage *)blurredBackgroundImage
{
	_blurredBackgroundImage = blurredBackgroundImage;
	[self updateBackgroundImage];
}

- (void)updateBackgroundImage
{
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.blurredBackgroundImage];
	backgroundImageView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
	[self.tableView setBackgroundView:backgroundImageView];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	self.title = @"Add Event";
	
	UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
	[self.navigationItem setRightBarButtonItem:doneBarButton];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.tableView registerClass:[DTSEventTextEntryTableViewCell class] forCellReuseIdentifier:kDTSEventTextEntryTableViewCell];
	[self.tableView registerNib:[UINib nibWithNibName:kDTSEventTextEntryTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kDTSEventTextEntryTableViewCell];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)doneButtonTapped
{
	[self.dismissDelegate dismissViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateBackgroundImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTSEventTextEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTSEventTextEntryTableViewCell forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}



#pragma mark UIViewControllerAnimatedTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	self.presenting = YES;
	return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.presenting = NO;
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return [self dts_transitionDuration:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	[self dts_animateTransition:transitionContext presenting:self.presenting];
}


@end
