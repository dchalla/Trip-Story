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
#import "DTSTripEventDetailsViewController.h"

@protocol DTSTripEventsCollectionViewCellDelegate <NSObject>

- (void)editButtonTapped:(DTSEvent *)event;

@end

@interface DTSTripEventsCollectionViewCell : UICollectionViewCell < DTSCollectionCardsViewControllerProtocol,DTSTripEventDetailsViewControllerDelegate>

@property (nonatomic, weak) id <DTSCollectionCardCellDelegate> delegate;
@property (nonatomic, weak) id<DTSTripEventsCollectionViewCellDelegate> eventsCollectionViewCellDelegate;

- (void)updateViewWithEvent:(DTSEvent *)event;

@end
