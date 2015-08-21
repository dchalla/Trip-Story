//
//  DTSTripPhotoMapSectionHeaderView.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/18/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSTrip.h"

@interface DTSTripPhotoMapSectionHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) DTSTrip *trip;
@property (nonatomic, strong) NSArray *locationList;
@property (nonatomic, strong) NSString *cacheKey;

- (void)updateWithLocationList:(NSArray *)locationList trip:(DTSTrip *)trip;

@end
