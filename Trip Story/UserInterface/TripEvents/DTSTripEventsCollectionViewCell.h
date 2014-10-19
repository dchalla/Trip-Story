//
//  DTSTripEventsCollectionViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 10/18/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEvent.h"
#import "DTSCollectionCardCellDelegate.h"
#import "DTSCollectionCardsViewControllerProtocol.h"
@interface DTSTripEventsCollectionViewCell : UICollectionViewCell < DTSCollectionCardsViewControllerProtocol>

@property (nonatomic, weak) id <DTSCollectionCardCellDelegate> delegate;

- (void)updateViewWithEvent:(DTSEvent *)event;

@end
