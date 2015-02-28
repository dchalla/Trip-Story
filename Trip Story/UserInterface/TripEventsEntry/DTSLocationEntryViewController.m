//
//  DTSLocationEntryViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/22/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSLocationEntryViewController.h"
#import "UIViewController+Utilities.h"
#import <MapKit/MapKit.h>
#import "DTSLocation.h"

@interface DTSLocationEntryViewController ()

@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) MKLocalSearch *searchQuery;

@end

@implementation DTSLocationEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.transitioningDelegate = self;
    }
    return self;
}

- (void)setBlurredBackgroundImage:(UIImage *)blurredBackgroundImage
{
	_blurredBackgroundImage = blurredBackgroundImage;
	[self updateBackgroundImage];
}

- (void)updateBackgroundImage
{
	self.backgroundImageView.image = self.blurredBackgroundImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.contentInset = UIEdgeInsetsMake(self.searchBar.frame.origin.y + self.searchBar.frame.size.height, 0, 0, 0);
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	self.searchBar.delegate = self;
	self.searchBar.keyboardType = UIKeyboardAppearanceDark;
	[self updateBackgroundImage];
	[self hideSearchModal];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:YES];
	[self.searchQuery cancel];
}

- (void)cancelButtonTapped:(id)sender
{
	[self.dismissDelegate dismissViewController];
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
	[self.searchQuery cancel];
	[self showSearchModalWithMessage:YES];
	MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
	request.naturalLanguageQuery = searchBar.text;
	MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
	[search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
		NSLog(@"Map Items: %@", response.mapItems);
		self.tableData = response.mapItems;
		[self.tableView reloadData];
		[self hideSearchModal];
	}];
	self.searchQuery = search;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self showSearchModalWithMessage:NO];
}

- (void)showSearchModalWithMessage:(BOOL)showMessage
{
	if (showMessage)
	{
		self.searchingLabel.alpha = 1;
	}
	else
	{
		self.searchingLabel.alpha = 0;
	}
	[UIView animateWithDuration:0.2 animations:^{
		self.searchModalView.alpha = 1;
	}];
}

- (void)hideSearchModal
{
	[UIView animateWithDuration:0.2 animations:^{
		self.searchModalView.alpha = 0;
	}];
}

- (IBAction)searchModalTapped:(id)sender {
	[self hideSearchModal];
	[self.searchBar resignFirstResponder];
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

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.tableData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height -1, cell.frame.size.width, 1)];
		bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
		bottomLineView.backgroundColor = [UIColor blackColor];
		[cell addSubview:bottomLineView];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.backgroundColor = [UIColor clearColor];
	cell.contentView.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.textColor = [UIColor lightGrayColor];
	MKMapItem *mapItem = self.tableData[indexPath.row];
	cell.textLabel.text = mapItem.name;
	NSString *streetAddress = mapItem.placemark.thoroughfare.length > 0 ? mapItem.placemark.thoroughfare:@"";
	NSString *city = mapItem.placemark.locality.length > 0?mapItem.placemark.locality : @"";
	NSString *state = mapItem.placemark.administrativeArea.length > 0?mapItem.placemark.administrativeArea:@"";
	NSString *country = mapItem.placemark.country.length > 0?mapItem.placemark.country:@"";
	NSString *zipCode = mapItem.placemark.postalCode.length > 0?mapItem.placemark.postalCode:@"";
	NSString *detailedText = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",streetAddress,city,state,country,zipCode];
	cell.detailTextLabel.text = detailedText;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DTSLocation *location = [DTSLocation object];
	MKMapItem *mapItem= self.tableData[indexPath.row];
	location.mapItem = mapItem;
	[self.entryDelegate placeEntryCompletedWithValue:location];
	[self.dismissDelegate dismissViewController];
}


@end
