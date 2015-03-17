//
//  DTSViewControllerView.h
//  

#import <UIKit/UIKit.h>

@class DTSSpringboardItemView;
@class DTSSpringboardScrollView;

@interface DTSSpringboardView : UIView

@property (readonly) DTSSpringboardScrollView* springboard;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIImage *backgroundImage;
- (void)setupViewWithItems:(NSArray *)items;
@end
