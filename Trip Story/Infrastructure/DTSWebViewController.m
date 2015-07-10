//
//  DTSWebViewController.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/9/15.
//  Copyright (c) 2015 DKC. All rights reserved.
//

#import "DTSWebViewController.h"

@interface DTSWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DTSWebViewController

- (void)setHtmlFileName:(NSString *)htmlFileName
{
	_htmlFileName = htmlFileName;
	[self loadWebViewFromHtmlFileName:htmlFileName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadWebViewFromHtmlFileName:self.htmlFileName];
	
	if (self.didPresentViewController) {
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
		self.navigationItem.rightBarButtonItem = doneButton;
	}
	
}

- (void)loadWebViewFromHtmlFileName:(NSString *)htmlFileName {
	if (self.webView && htmlFileName.length > 0) {
		NSString *htmlFile = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"];
		NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
		[self.webView loadHTMLString:htmlString baseURL:nil];
	}
}

- (void)doneButtonTapped
{
	if (self.didPresentViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}


@end
