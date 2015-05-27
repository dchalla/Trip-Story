//
//  DTSSignUpViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 5/27/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSSignUpViewController.h"
#import "UIColor+Utilities.h"
#import "UIView+Utilities.h"
#import "DTSLoginLogoView.h"
#import "PFTextField.h"

@interface DTSSignUpViewController ()

@end

@implementation DTSSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor primaryColor];
	DTSLoginLogoView *logoView = [DTSLoginLogoView dts_viewFromNibWithName:@"DTSLoginLogoView" bundle:[NSBundle mainBundle]];
	[self.signUpView setLogo:logoView];
	[self.signUpView.usernameField setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
	[self.signUpView.passwordField setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
	[self.signUpView.emailField setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.05]];
	self.signUpView.usernameField.separatorColor = [UIColor primaryColor];
	self.signUpView.passwordField.separatorColor = [UIColor primaryColor];
	self.signUpView.emailField.separatorColor = [UIColor primaryColor];
	
	[self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
	[self.signUpView.signUpButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
	
	

}


@end
