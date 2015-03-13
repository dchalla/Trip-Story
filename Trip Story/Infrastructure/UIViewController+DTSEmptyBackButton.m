//
//  UIViewController+DTSEmptyBackButton.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/13/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "UIViewController+DTSEmptyBackButton.h"
#import <objc/runtime.h>

@implementation UIViewController (DTSEmptyBackButton)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		
		SEL originalSelector = @selector(viewDidLoad);
		SEL swizzledSelector = @selector(dts_viewDidLoad);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
		
		BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
		
		if (didAddMethod) {
			class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod);
		}
	});
}

#pragma mark - Method Swizzling

- (void)dts_viewDidLoad {
	[self dts_viewDidLoad];
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:backButtonItem];
}

@end