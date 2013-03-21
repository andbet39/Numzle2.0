//
//  AppDelegate.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import "GameCenterHelper.h"
#import "SoundManager.h"
#import "InAppHelper.h"

#import "GAI.h"

#import "FaceBookHelper.h"

@implementation AppDelegate

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (BOOL)application:(UIApplication *)application  openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    // To check for a deep link, first parse the incoming URL
    // to look for a target_url parameter
    NSString *query = [url fragment];
    if (!query) {
        query = [url query];
    }
    NSDictionary *params = [self parseURLParams:query];
    // Check if target URL exists
    NSString *targetURLString = [params valueForKey:@"target_url"];
    if (targetURLString) {
        NSURL *targetURL = [NSURL URLWithString:targetURLString];
        NSDictionary *targetParams = [self parseURLParams:[targetURL query]];
        NSString *deeplink = [targetParams valueForKey:@"deeplink"];
        
        // Check for the 'deeplink' parameter to check if this is one of
        // our incoming news feed link
        /*if (deeplink) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"News"
                                  message:[NSString stringWithFormat:@"Incoming: %@", deeplink]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
            [alert show];
            
    }*/
    }
    return [FBSession.activeSession handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GameCenterHelper sharedInstance] authenticateLocalUser];
    [[InAppHelper sharedInstance]registerHandleForProduct:@"com.atdevapps.numzle.premiumversion"];

    [[SoundManager sharedInstance]init];
    
    [Parse setApplicationId:@"zbB0d4p50uWMLPA3a9XhOdKRUNkUzcm435NpfC5p"
                  clientKey:@"VNIl5N5oZDcBoWH9sGvdXHGXvtFQkWMBsPwgaFeu"];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;

    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-39413113-1"];
    
    
    [tracker sendView:@"Launched"];
    
    
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
    [FBSession.activeSession handleDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        [FBSession.activeSession close];
}

@end
