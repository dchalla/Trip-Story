//
//  DKCAppDelegate.m
//  Trip Story
//
//  Created by Dinesh Challa on 7/2/14.
//  Copyright (c) 2014 DKC. All rights reserved.
//

#import "DTSAppDelegate.h"
#import "DTSRootViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DTSUserAuthHelper.h"
#import <Google/Analytics.h>
#import <CrittercismSDK/Crittercism.h>

@implementation DTSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[Crittercism enableWithAppID:@"55ce7ca4985ec40d0002c591"];
	
	//enable this for production //FIXBEFOREPRODUCTION
	//[Parse setApplicationId:@"ciwtl1abDpXzKAvRXaBFaJdrR1nvOd3SWJnu5trn" clientKey:@"znMgPXhb8Fwi3Z0Cpfm41t89aIP8ZBvycsrhgfIE"];
	
	//testing
	[Parse setApplicationId:@"vD1gL4YcvheVfDOdl7gk4ZPIUQ8rPkOZuHUUT6h5" clientKey:@"Nb8PDaKSm9UcKxyvFNbk2hTII6Q5SOUhCFIxZ0Fy"];
	//testing end
	
	[PFFacebookUtils initializeFacebook];
	
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	
	// Configure tracker from GoogleService-Info.plist.
	NSError *configureError;
	[[GGLContext sharedInstance] configureWithError:&configureError];
	NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
	
	// Optional: configure GAI options.
	GAI *gai = [GAI sharedInstance];
	gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
#ifdef DEBUG
	gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
#endif
	
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController *vc = [[DTSRootViewController alloc] init];
	UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
	nvc.navigationBarHidden = YES;
	self.window.rootViewController = nvc;
	[self.window makeKeyAndVisible];
	
	[self setupUIAppearance];
	
	[[DTSUserAuthHelper sharedManager] updateFacebookDetailsForTheUser];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation
{
	return [FBAppCall handleOpenURL:url
				  sourceApplication:sourceApplication
						withSession:[PFFacebookUtils session]];
}

- (void)setupUIAppearance
{
	[[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:6/255.0 green:8.0/255.0 blue:11.0/255.0 alpha:1]];
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
	[[UINavigationBar appearance] setTranslucent:YES];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
