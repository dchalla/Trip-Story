//
//  DTSEventsEntryDeleteView.h
//  Trip Story
//
//  Created by Dinesh Challa on 5/19/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTSEventsEntryDeleteViewProtocol <NSObject>

- (void)eventDeleteButtonTapped;

@end

@interface DTSEventsEntryDeleteView : UIView
@property (weak, nonatomic) IBOutlet UILabel *confirmDeleteLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *noDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) id<DTSEventsEntryDeleteViewProtocol> delegate;

@end
