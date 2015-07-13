//
//  DTSEventPickerEntryTableViewCell.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/19/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTSEntryTableViewCellDelegate.h"

@interface DTSEventPickerEntryTableViewCell : UITableViewCell <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSNumber *pickerValue;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSString *placeHolderValue;
@property (nonatomic, strong) id identifier;
@property (weak, nonatomic) IBOutlet UIView *suggestionMarkerView;
@property (nonatomic, weak) id<DTSEntryTableViewCellDelegate> delegate;
@end
