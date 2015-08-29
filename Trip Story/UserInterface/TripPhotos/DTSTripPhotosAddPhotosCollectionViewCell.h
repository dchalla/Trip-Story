//
//  DTSTripPhotosAddPhotosCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSTripPhotosAddPhotosCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

+ (CGFloat)cellHeight;

@end
