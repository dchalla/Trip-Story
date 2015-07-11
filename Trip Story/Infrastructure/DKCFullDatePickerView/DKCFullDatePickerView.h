//
//  DKCFullDatePickerView.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/10/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKCFullDatePickerViewProtocol <NSObject>

- (void)dkcFullDatePickerValueChanged:(NSDate *)date;

@end

@interface DKCFullDatePickerView : UIView

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) id<DKCFullDatePickerViewProtocol> delegate;

@end
