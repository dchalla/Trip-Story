//
//  DTSLogInViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 3/17/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSLogInViewController.h"
#import "UIColor+Utilities.h"
#import "UIView+Utilities.h"
#import "DTSLoginLogoView.h"
#import "PFTextField.h"

@interface DTSLogInViewController ()

@end

@implementation DTSLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor primaryColor];
	DTSLoginLogoView *logoView = [DTSLoginLogoView dts_viewFromNibWithName:@"DTSLoginLogoView" bundle:[NSBundle mainBundle]];
	[self.logInView setLogo:logoView];
	[self.logInView.usernameField setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
	[self.logInView.passwordField setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
	[self.logInView.usernameField setTextColor:[UIColor colorWithWhite:1 alpha:1]];
	[self.logInView.passwordField setTextColor:[UIColor colorWithWhite:1 alpha:1]];
	self.logInView.usernameField.separatorColor = [UIColor primaryColor];
	self.logInView.passwordField.separatorColor = [UIColor primaryColor];
	[self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
	[self.logInView.logInButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
	
}



@end
