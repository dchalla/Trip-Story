//
//  DTSTripDetailsContainerDelegate.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/27/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTSTripDetailsContainerDelegate <NSObject>

- (void)showNewEventEntry;
- (void)showEditEventEntryAtIndex:(NSInteger)index;
- (void)showEditTripView;


@end
