//
//  DTSWebViewController.h
//  Trip Story
//
//  Created by Dinesh Challa on 7/9/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTSWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString *htmlFileName;
@property (nonatomic) BOOL didPresentViewController;

@end
