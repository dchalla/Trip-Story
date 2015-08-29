//
//  DTSPhotoViewModel.h
//  Trip Story
//
//  Created by Dinesh Challa on 8/28/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhoto.h>
#import "DTSTripPhoto.h"

@interface DTSPhotoViewModel : NSObject<NYTPhoto>

- (id)initWithTripPhoto:(DTSTripPhoto *)tripPhoto andImage:(UIImage *)image;

@property (nonatomic, strong) DTSTripPhoto *tripPhoto;

@end
