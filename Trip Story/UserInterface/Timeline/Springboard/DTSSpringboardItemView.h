//
//  DTSSpringboardItemView.h
//


#import <UIKit/UIKit.h>
#import "DTSSpringboardItemModel.h"

@interface DTSSpringboardItemView : UIView

@property (readonly) UIImageView* icon;
@property (readonly) UILabel* label;
@property (nonatomic) CGFloat scale;

@property (nonatomic, strong) DTSSpringboardItemModel *modelData;

- (void)setScale:(CGFloat)scale animated:(BOOL)animated;
- (void)setTitle:(NSString*)title;

@end
