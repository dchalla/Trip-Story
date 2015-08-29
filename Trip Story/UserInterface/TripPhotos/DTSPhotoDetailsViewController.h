//
//  DTSPhotoDetailsViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/28/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "DTSPhotoViewModel.h"


@protocol DTSPhotoDetailsViewControllerDelegate <NSObject>

- (void)photosDetailsViewController:(id)viewController deleteButtonTappedForTripPhoto:(DTSTripPhoto *)tripPhoto;

@end

@interface DTSPhotoDetailsViewController : NYTPhotosViewController

@property (nonatomic) BOOL deleteButtonEnabled;
@property (nonatomic,weak) id<DTSPhotoDetailsViewControllerDelegate> deleteDelegate;

- (instancetype)initWithPhotos:(NSArray *)photos deleteButtonEnabled:(BOOL)deleteButtonEnabled;

/* copy this into super view everytime you update
 @property (nonatomic) NYTPhotoTransitionController *transitionController;
 - (void)dismissAnimated:(BOOL)animated;
 */

@end
