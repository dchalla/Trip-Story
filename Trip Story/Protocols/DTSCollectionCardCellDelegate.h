//
//  DTSCollectionCardCellDelegate.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/19/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTSCollectionCardCellDelegate <NSObject>
- (void)cardCellDidPan:(UICollectionViewCell *)cell;
@end
