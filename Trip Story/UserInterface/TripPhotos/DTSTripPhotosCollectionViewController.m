//
//  DTSTripPhotosCollectionViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripPhotosCollectionViewController.h"
#import "DTSTripPhotosAddPhotosCollectionViewCell.h"
#import "DTSTripPhotosImageCollectionViewCell.h"
#import "theTripStory-Swift.h"
#import "UIColor+Utilities.h"
#import <Photos/Photos.h>
#import <Photos/PHImageManager.h>
#import "DTSConstants.h"
#import "DTSTripPhoto.h"
#import "DTSLocation.h"
#import <CoreLocation/CoreLocation.h>

#define photoWidth 450

@interface DTSTripPhotosCollectionViewController ()

@property (nonatomic, strong) NSArray *collectionViewDataArray;
@property (nonatomic, strong) NSMutableDictionary *assetsDict;
@property (nonatomic, strong) NSArray *tripPhotos;

@end

@implementation DTSTripPhotosCollectionViewController
@synthesize topLayoutGuideLength = _topLayoutGuideLength;
@synthesize bottomLayoutGuideLength = _bottomLayoutGuideLength;
@synthesize trip = _trip;

- (void)setTopLayoutGuideLength:(CGFloat)topLayoutGuideLength
{
	_topLayoutGuideLength = topLayoutGuideLength;
	[self setupTableViewInsets];
}

- (void)setBottomLayoutGuideLength:(CGFloat)bottomLayoutGuideLength
{
	_bottomLayoutGuideLength = bottomLayoutGuideLength;
	[self setupTableViewInsets];
}

- (void)setupTableViewInsets
{
	self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuideLength, 0, self.bottomLayoutGuideLength, 0);
}

- (NSMutableDictionary *)assetsDict {
	if (!_assetsDict) {
		_assetsDict = [NSMutableDictionary dictionary];
	}
	return _assetsDict;
}

- (NSArray *)collectionViewDataArray {
	if (!_collectionViewDataArray) {
		_collectionViewDataArray = [[NSArray alloc] init];
	}
	return _collectionViewDataArray;
}

- (void)setTrip:(DTSTrip *)trip {
	_trip = trip;
	[self updateDatasourceForCollectionView:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.collectionView registerClass:[DTSTripPhotosAddPhotosCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosAddPhotosCollectionViewCell class])];
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DTSTripPhotosAddPhotosCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosAddPhotosCollectionViewCell class])];
	
	[self.collectionView registerClass:[DTSTripPhotosImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosImageCollectionViewCell class])];
	[self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DTSTripPhotosImageCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosImageCollectionViewCell class])];
	[self updateDatasourceForCollectionView:nil];
	self.view.backgroundColor = [UIColor secondaryColor];
	
}

- (NSArray *)lastSectionArray {
	NSArray *lastSectionArray =[[NSArray alloc] initWithObjects:@"Add Photos", nil];
	return lastSectionArray;
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
	if (self.collectionViewDataArray.count <= indexPath.section) {
		return nil;
	}
	NSArray *sectionArray = dynamic_cast_oc(self.collectionViewDataArray[indexPath.section], NSArray);
	
	if (sectionArray.count <= indexPath.row) {
		return nil;
	}
	
	id rowObject = sectionArray[indexPath.row];
	
	return rowObject;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.collectionViewDataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (self.collectionViewDataArray.count <= section) {
		//something wrong with datasource
		return 0;
	}
	NSArray *sectionArray = dynamic_cast_oc(self.collectionViewDataArray[section], NSArray);
    return sectionArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	id rowObject = [self objectForIndexPath:indexPath];
	
	if (rowObject == nil) {
		return CGSizeZero;
	}
	
	DTSTripPhoto *tripPhoto = dynamic_cast_oc(rowObject, DTSTripPhoto);
	if (tripPhoto) {
		return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.width*tripPhoto.pixelHeight.integerValue/tripPhoto.pixelWidth.integerValue);
	}
	
	else if (indexPath.section == self.collectionViewDataArray.count -1) {
		CGFloat cellHeight = [DTSTripPhotosAddPhotosCollectionViewCell cellHeight];
		return CGSizeMake(self.collectionView.frame.size.width, cellHeight);
	}
	
	return CGSizeZero;
	
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	id rowObject = [self objectForIndexPath:indexPath];
	
	if (rowObject == nil) {
		//something wrong with datasource
		UICollectionViewCell *dummyCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosImageCollectionViewCell class]) forIndexPath:indexPath];
		return dummyCell;
	}
	
	DTSTripPhoto *tripPhoto = dynamic_cast_oc(rowObject, DTSTripPhoto);
	if (tripPhoto) {
		DTSTripPhotosImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosImageCollectionViewCell class]) forIndexPath:indexPath];
		cell.backgroundColor = [UIColor primaryColor];
		cell.imageId = indexPath;
		
		BOOL usingPHAsset = NO;
		if (tripPhoto.assetID) {
			PHAsset *asset = self.assetsDict[tripPhoto.assetID];
			if (asset) {
				usingPHAsset = YES;
				[[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:[self photoSizeFromAsset:asset] contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
					if (result) {
						if (((NSIndexPath *)cell.imageId).section == indexPath.section && ((NSIndexPath *)cell.imageId).row == indexPath.row) {
							cell.imageView.image = result;
						}
					}
				}];
			}
		}
		
		if (!usingPHAsset) {
			cell.imageView.file = tripPhoto.image;
			[cell.imageView loadInBackground:^(UIImage *image, NSError *error) {
				if (((NSIndexPath *)cell.imageId).section == indexPath.section && ((NSIndexPath *)cell.imageId).row == indexPath.row && !error) {
					cell.imageView.image = image;
				}
			}];
		}
		
		return cell;
	}
	
	if (indexPath.section == self.collectionViewDataArray.count -1) {
		UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DTSTripPhotosAddPhotosCollectionViewCell class]) forIndexPath:indexPath];
		cell.backgroundColor = [UIColor primaryColor];
		return cell;
	}

    

    return nil;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	id rowObject = [self objectForIndexPath:indexPath];
	
	NSString *rowString = dynamic_cast_oc(rowObject, NSString);
	
	if ([rowString isEqualToString:@"Add Photos"]) {
		[self showPhotosPicker];
	}
	
}

#pragma mark - Photos Picker 


- (void)showPhotosPicker {
	BSImagePickerViewController *imagePicker = [BSImagePickerViewController new];
	BlockWeakSelf wSelf = self;
	// Present image picker. Any of the blocks can be nil
	[self bs_presentImagePickerController:imagePicker
								 animated:YES
								   select:^(PHAsset * __nonnull asset) {
									   // User selected an asset.
									   // Do something with it, start upload perhaps?
								   } deselect:^(PHAsset * __nonnull asset) {
									   // User deselected an assets.
									   // Do something, cancel upload?
								   } cancel:^(NSArray * __nonnull assets) {
									   // User cancelled. And this where the assets currently selected.
								   } finish:^(NSArray * __nonnull assets) {
									   // User finished with these assets
									   dispatch_async(dispatch_get_main_queue(), ^{
										   BlockStrongSelf strongSelf = wSelf;
										   if (strongSelf) {
											   [strongSelf updateDatasourceForCollectionView:assets];
										   }
									   });
								   } completion:nil];
}

#pragma mark - dataSource

- (void)updateDatasourceForCollectionView:(NSArray *)assets {
	NSMutableArray *collectionViewDataSource = [[NSMutableArray alloc] init];
	NSMutableArray *photoSectionArray = [NSMutableArray array];
	for (PHAsset *asset in assets) {
		DTSTripPhoto *tripPhoto = [self tripPhotoFromAsset:asset];
		[self.trip.tripPhotosList addObject:tripPhoto];
	}
	for (DTSTripPhoto *tripPhoto in self.trip.tripPhotosList) {
		[photoSectionArray addObject:tripPhoto];
	}
	[collectionViewDataSource addObject:photoSectionArray];
	
	if (self.trip && self.trip.user) {
		if ([self.trip.user.username isEqualToString:[PFUser currentUser].username]) {
			[collectionViewDataSource addObject:[self lastSectionArray]];
		}
	}
	
	self.collectionViewDataArray = [collectionViewDataSource copy];
	[self.collectionView reloadData];
}

- (DTSTripPhoto *)tripPhotoFromAsset:(PHAsset *)asset {
	DTSTripPhoto *tripPhoto = [DTSTripPhoto object];
	CGSize photoSize = [self photoSizeFromAsset:asset];
	tripPhoto.pixelHeight = @(photoSize.height);
	tripPhoto.pixelWidth = @(photoSize.width);
	if (asset.creationDate) {
		tripPhoto.imageCreationDate = asset.creationDate;
	}
	tripPhoto.assetID = asset.localIdentifier;
	self.assetsDict[asset.localIdentifier] = asset;
	
	//location
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(asset.location.coordinate.latitude, asset.location.coordinate.longitude);
	MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
	MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
	tripPhoto.location = [DTSLocation object];
	tripPhoto.location.mapItem = mapItem;
	
	CLLocation *location = asset.location;
	if (location) {
		CLGeocoder *geocoder = [[CLGeocoder alloc] init];
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
			MKPlacemark *placemark = [placemarks firstObject];
			MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
			if (!tripPhoto.location) {
				tripPhoto.location = [DTSLocation object];
			}
			tripPhoto.location.mapItem = mapItem;
		} ];
	}
	
	
	//image
	BlockWeakSelf wSelf = self;
	[[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:[self photoSizeFromAsset:asset] contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
		if (result) {
			NSData *imageData = UIImageJPEGRepresentation(result, 0.5);
			if (imageData.length > 0) {
				tripPhoto.image = [PFFile fileWithData:imageData];
				[tripPhoto.image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					if (succeeded) {
						BlockStrongSelf strongSelf = wSelf;
						if (strongSelf) {
							[strongSelf.trip saveInBackground];
						}
					}
				}];
			}

		}
	}];
	
	return tripPhoto;
}

- (CGSize)photoSizeFromAsset:(PHAsset *)asset {
	return CGSizeMake(photoWidth, photoWidth*asset.pixelHeight/asset.pixelWidth);
}
@end
