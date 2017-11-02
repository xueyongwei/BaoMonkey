//
//  AppDelegate.m
//  BaoMonkey
//
//  Created by iPPLE on 06/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "AppDelegate.h"
#import "UserData.h"
#import "GameCenter.h"
#import "UserData.h"
#import "RewardVideoManager.h"
#import <Google/Analytics.h>
#import <IAPShare.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    [GameCenter authenticateLocalPlayer];

    NSString *playerId = [[GameCenter defaultGameCenter] localPlayer].playerID;
        
    [UserData launch];
    [GameData initGameData];
    [UserData initUserData];
    [[UserData defaultUser] setPlayerId:playerId];
    [Music initAndPlayBackgroundMusic];
    [[RewardVideoManager defaultManager] setUpManager];
    [self initIAP];
    return YES;
}
-(void)initIAP{
    NSSet* dataSet = [[NSSet alloc] initWithObjects:@"201",nil];
    
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"app内购买"
                                                          action:@"去除广告"
                                                           label:@""
                                                           value:nil] build]];
    
    [IAPShare sharedHelper].iap.production = NO;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [Music pauseBackgroundMusic];
    if ([GameData isPause] == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAUSE_GAME object:nil];
        [UserData saveUserData];
    }
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
    [Music playBackgroundMusic];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [UserData saveUserData];
}

@end
