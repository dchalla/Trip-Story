//
//  DTSEventTextEntryTableViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/17/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEntryTableViewCellDelegate.h"


@interface DTSEventTextEntryTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *fieldValue;
@property (nonatomic, strong) NSString *placeHolderValue;
@property (nonatomic, strong) id identifier;
@property (weak, nonatomic) IBOutlet UIView *suggestionMarkerView;
@property (nonatomic, weak) id<DTSEntryTableViewCellDelegate> delegate;

@end
