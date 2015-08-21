//
//  DTSTripPhotoMapSectionHeaderView.m
//  Trip Story
//
//  Created by Dinesh Challa on 8/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSTripPhotoMapSectionHeaderView.h"
#import "DTSCache.h"

@implementation DTSTripPhotoMapSectionHeaderView

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateWithLocationList:(NSArray *)locationList trip:(DTSTrip *)trip {
	self.locationList = locationList;
	self.trip = trip;
	[self updateMapScreenshot];
}

- (void)updateMapScreenshot {
	NSArray *locationList = self.locationList;
	if (locationList.count > 0)
	{
		MKMapRect r = MKMapRectNull;
		for (NSUInteger i=0; i < locationList.count; ++i) {
			MKMapPoint p = MKMapPointForCoordinate(dynamic_cast_oc(locationList[i], DTSLocation).mapItem.placemark.coordinate);
			r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
		}
		MKCoordinateRegion viewRegion = MKCoordinateRegionForMapRect(r);
		viewRegion.span.latitudeDelta *=3;
		
		NSString *cacheKey = [NSString stringWithFormat:@"%f:%f:%f:%f",viewRegion.center.latitude, viewRegion.center.longitude,viewRegion.span.latitudeDelta, viewRegion.span.longitudeDelta];
		self.cacheKey = cacheKey;
		UIImage *image = [[DTSCache sharedCache] cachedImageForKey:cacheKey];
		if (image != nil)
		{
			self.imageView.image = image;
		}
		else
		{
			MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
			
			options.region = viewRegion;
			options.size = CGSizeMake(self.frame.size.width, 200);
			options.scale = [[UIScreen mainScreen] scale];
			BlockWeakSelf wSelf = self;
			MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
			[snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
				if (error) {
					NSLog(@"[Error] %@", error);
					return;
				}
				
				
				MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
				
				UIImage *image = snapshot.image;
				 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
					 UIImage *compositeImage = nil;
					 
					 UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
					 {
						 [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
						 
						 CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
						 for (DTSLocation *location in locationList) {
							 CGPoint point = [snapshot pointForCoordinate:location.mapItem.placemark.coordinate];
							 if (CGRectContainsPoint(rect, point)) {
								 point.x = point.x + pin.centerOffset.x -
								 (pin.bounds.size.width / 2.0f);
								 point.y = point.y + pin.centerOffset.y -
								 (pin.bounds.size.height / 2.0f);
								 [pin.image drawAtPoint:point];
							 }
						 }
						 compositeImage = UIGraphicsGetImageFromCurrentImageContext();
					 }
					 UIGraphicsEndImageContext();
					 [[DTSCache sharedCache] cacheImage:compositeImage forKey:cacheKey];
					 dispatch_async(dispatch_get_main_queue(), ^{
						 BlockStrongSelf strongSelf = wSelf;
						 if (strongSelf) {
							 if ([cacheKey isEqualToString:strongSelf.cacheKey]) {
								 strongSelf.imageView.alpha = 0;
								 strongSelf.imageView.image = compositeImage;
								 [UIView animateWithDuration:0.2 animations:^{
									 strongSelf.imageView.alpha = 1;
								 }];
								 
							 }
						 }
					 });
				 });
			}];
			
		}
		
	}
}

- (void)prepareForReuse {
	self.imageView.image = nil;
}


@end
