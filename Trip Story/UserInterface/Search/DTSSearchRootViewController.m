//
//  DTSSearchRootViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 6/2/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSearchRootViewController.h"
#import "DTSSearchTripCollectionViewController.h"
#import "PFUser+DTSAdditions.h"
#import "MBProgressHUD.h"
#import "DTSRequiresLoginView.h"
#import "UIView+Utilities.h"
#import "DTSSearchRootViewControllerProtocol.h"
#import "DTSSearchPeopleCollectionViewController.h"

@interface DTSSearchRootViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) DTSSearchTripCollectionViewController *searchTripsVC;
@property (nonatomic, strong) DTSSearchPeopleCollectionViewController *searchPeopleVC;
@property (nonatomic, strong) UIView *searchModalView;

@end

@implementation DTSSearchRootViewController

- (PFUser *)user
{
	if (_user)
	{
		return _user;
	}
	else
	{
		return [PFUser currentUser];
	}
}

- (UIView *)searchModalView
{
	if (!_searchModalView)
	{
		_searchModalView = [[UIView alloc] initWithFrame:self.view.bounds];
		_searchModalView.backgroundColor = [UIColor primaryColor];
		_searchModalView.alpha = 0;
		[self.view addSubview:_searchModalView];
		[self.view bringSubviewToFront:_searchModalView];
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchModalTapped:)];
		[_searchModalView addGestureRecognizer:tapGesture];
	}
	return _searchModalView;
}


- (DTSSearchTripCollectionViewController *)searchTripsVC
{
	if (!_searchTripsVC)
	{
		_searchTripsVC = [[DTSSearchTripCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [DTSTrip parseClassName]];
	}
	return _searchTripsVC;
}

- (DTSSearchPeopleCollectionViewController *)searchPeopleVC
{
	if (!_searchPeopleVC)
	{
		_searchPeopleVC = [[DTSSearchPeopleCollectionViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init] className: [PFUser parseClassName]];
	}
	return _searchPeopleVC;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupSearchBar];
}

#pragma mark - segment setup

- (NSArray *)segmentNamesList
{
	return @[@"Trips", @"People"];
}

- (NSArray *)pagedViewControllersList
{
	return @[self.searchTripsVC,self.searchPeopleVC];
}

- (void)pageViewControllerCurrentVCChanged
{
	if ([[self currentPageVC] conformsToProtocol:@protocol(DTSSearchRootViewControllerProtocol)])
	{
		[[self currentPageVC] searchWithString:[self.searchBar.text lowercaseString]];
	}
}

#pragma mark - search bar
- (void)setupSearchBar
{
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, self.navigationController.navigationBar.frame.size.width - 20, self.navigationController.navigationBar.frame.size.height)];
	self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
	self.searchBar.barStyle = UIBarStyleBlackTranslucent;
	self.searchBar.delegate = self;
	self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	[self.navigationController.navigationBar addSubview:self.searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
	
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	if ([[self currentPageVC] conformsToProtocol:@protocol(DTSSearchRootViewControllerProtocol)])
	{
		[[self currentPageVC] searchWithString:[self.searchBar.text lowercaseString]];
	}
	[self hideSearchModal];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self showSearchModal];
}

- (void)showSearchModal
{
	[UIView animateWithDuration:0.2 animations:^{
		self.searchModalView.alpha = 0.3;
	}];
}

- (void)hideSearchModal
{
	[UIView animateWithDuration:0.2 animations:^{
		self.searchModalView.alpha = 0;
	}];
}

- (IBAction)searchModalTapped:(id)sender {
	
	[self.searchBar resignFirstResponder];
}

@end
