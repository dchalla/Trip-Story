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
	self.tableView.separatorColor = [UIColor blackColor];
	[self.segmentControl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	[self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	self.searchBar.delegate = self;
	self.searchBar.keyboardType = UIKeyboardAppearanceDark;
	[self updateBackgroundImage];
}

- (void)segmentControlValueChanged:(id)sender
{
	if (self.segmentControl.selectedSegmentIndex == 0)
	{
		self.searchBar.placeholder = @"Enter a place to search";
	}
	else
	{
		self.searchBar.placeholder = @"Enter an address to search";
	}
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
	MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
	request.naturalLanguageQuery = searchBar.text;
	MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
	[search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
		NSLog(@"Map Items: %@", response.mapItems);
		self.tableData = response.mapItems;
		[self.tableView reloadData];
	}];
	self.searchQuery = search;
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
	}
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
	NSString *country = mapItem.placemark.subAdministrativeArea.length > 0?mapItem.placemark.subAdministrativeArea:@"";
	NSString *detailedText = [NSString stringWithFormat:@"%@ %@ %@ %@",streetAddress,city,state,country];
	cell.detailTextLabel.text = detailedText;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}


@end
