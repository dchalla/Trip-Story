//
//  DTSPhotoDetailsViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/28/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSPhotoDetailsViewController.h"
#import "NYTPhotosOverlayView.h"
#import <NYTPhotoViewer/NYTPhotoTransitionController.h>

@interface DTSPhotoDetailsViewController ()
@property (nonatomic, strong) UIButton *deletButton;
@end

@implementation DTSPhotoDetailsViewController

- (instancetype)initWithPhotos:(NSArray *)photos deleteButtonEnabled:(BOOL)deleteButtonEnabled {
	self = [super initWithPhotos:photos];
	if (self) {
		self.deleteButtonEnabled = deleteButtonEnabled;
	}
	return self;
}

- (void)setDeleteButtonEnabled:(BOOL)deleteButtonEnabled {
	_deleteButtonEnabled = deleteButtonEnabled;
	self.deletButton.hidden = !self.deleteButtonEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.deletButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 65,self.view.frame.size.height - 50, 80, 50)];
	[self.deletButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
	self.deletButton.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 30);
	[self.overlayView addSubview:self.deletButton];
	[self.deletButton addTarget:self action:@selector(deletButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	self.deletButton.hidden = !self.deleteButtonEnabled;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[self.overlayView bringSubviewToFront:self.deletButton];
}


- (void)deletButtonTapped {
	DTSPhotoViewModel *photoViewModel = dynamic_cast_oc(self.currentlyDisplayedPhoto, DTSPhotoViewModel);
	[self.deleteDelegate photosDetailsViewController:self deleteButtonTappedForTripPhoto:photoViewModel.tripPhoto];
	self.transitionController.forcesNonInteractiveDismissal = YES;
	[self dismissAnimated:YES];
}

@end
