//
//  DKCSpringboardViewController.h
//

#import <UIKit/UIKit.h>
#import <libSportsData/SPGameDetails.h>

@protocol DTSSpringboardViewControllerDelegate <NSObject>

- (void)itemSelected:(id)obj;

@end

@interface DTSSpringboardViewController : UIViewController  <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) SPGameDetails *gameDetails;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, weak) id<DTSSpringboardViewControllerDelegate> delegate;

@end

