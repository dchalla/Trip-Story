//
//  DTSTripPhotosImageCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface DTSTripPhotosImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (nonatomic, strong) id imageId;

@end
