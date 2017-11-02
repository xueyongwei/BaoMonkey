//
//  GameCenter.m
//  BaoMonkey
//
//  Created by iPPLE on 20/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "GameCenter.h"
#import "UserData.h"
#import "Define.h"
#import "GameData.h"

@implementation GameCenter

+ (instancetype) defaultGameCenter {
    static GameCenter *gameCenter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        gameCenter = [[GameCenter alloc] init];        
    });
    return (gameCenter);
}

# pragma mark - GameCenter authentification

+(void)authenticateLocalPlayer {
    [[GameCenter defaultGameCenter] authenticateLocalPlayer];
}

-(void)authenticateLocalPlayer{
    _localPlayer = [GKLocalPlayer localPlayer];
    
    __weak typeof(self) weakSelf = self;
    _localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if ([GKLocalPlayer localPlayer].authenticated) {
            weakSelf.gameCenterEnabled = YES;
            
            // Get the default leaderboard identifier.
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *defaultLeaderboardIdentifier, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                else{
                    weakSelf.leaderboardIdentifier = defaultLeaderboardIdentifier;
                }
            }];
        }
        
        else {
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_GAME_CENTER_LOGIN object:nil];
            weakSelf.gameCenterEnabled = NO;
        }
    };
}

# pragma mark - GameCenter Login

+(void)showGameCenterLoginWithViewController:(UIViewController*)viewController {
    [[GameCenter defaultGameCenter] showGameCenterLoginWithViewController:viewController];
}

-(void)showGameCenterLoginWithViewController:(UIViewController*)viewController {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
        [viewController presentViewController:gameCenterController animated:YES completion:nil];
    }
}

# pragma mark - GameCenter LeaderBoard

+(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard withViewController:(UIViewController*)viewController{
    [[GameCenter defaultGameCenter] showLeaderboardAndAchievements:shouldShowLeaderboard withViewController:viewController];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard withViewController:(UIViewController*)viewController{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    [viewController presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

+(NSString*)getLeaderboardIdentifier {
    return [[GameCenter defaultGameCenter] leaderboardIdentifier];
}

-(NSString*)getLeaderboardIdentifier {
    return _leaderboardIdentifier;
}

# pragma mark - GameCenter score

+ (void) reportScore {
    GKScore *scoreReport = [[GKScore alloc] initWithLeaderboardIdentifier:@"baoMonkeyLeaderboard"];
    scoreReport.value = [GameData getScore];
    scoreReport.context = 0;
    
    [GKScore reportScores:@[scoreReport] withCompletionHandler:nil];
}

+ (void) getBestScorePlayer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger bestLocalScore = [userDefaults integerForKey:NSUSERDEFAULT_BEST_LOCAL_SCORE];
    [userDefaults setBool:YES forKey:NSUSERDEFAULT_PLAYED_ONCE];
    
    if ([GameData getScore] > bestLocalScore) {
        [userDefaults setInteger:[GameData getScore] forKey:NSUSERDEFAULT_BEST_LOCAL_SCORE];
        [userDefaults synchronize];
    }
    
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.identifier = [[GameCenter defaultGameCenter] leaderboardIdentifier];
    
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (scores) {
            if ([GameData getScore] > (int)leaderboardRequest.localPlayerScore.value) {
                [self reportScore];
            }
            if ((NSInteger)leaderboardRequest.localPlayerScore.value > bestLocalScore) {
                [userDefaults setInteger:(NSInteger)leaderboardRequest.localPlayerScore.value forKey:NSUSERDEFAULT_BEST_LOCAL_SCORE];
            }
            [userDefaults synchronize];
            return ;
        }
        else
            [self reportScore];
        return ;
    }];
}

+ (void) initUserDataProgress {
    if (![[GameCenter defaultGameCenter] gameCenterEnabled])
        return ;
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error debug for download achievement : %@", error);
            return ;
        }
        NSInteger indexPlums = 1;
        NSInteger indexEnemie = 1;
        
        for (GKAchievement *currentAchievement in achievements) {
            NSArray *tabParseIdentifer = [currentAchievement.identifier componentsSeparatedByString:@"0"];
            
            if (currentAchievement.percentComplete != 100) {
                if (indexPlums < [ACHIEVEMENT_PLUMS count] &&
                    [((NSString *)[tabParseIdentifer objectAtIndex:[tabParseIdentifer count] - 1]) isEqualToString:@"plums"]) {
                    [[UserData defaultUser] setPrune_score:(int)([[ACHIEVEMENT_PLUMS objectAtIndex:indexPlums] integerValue] * currentAchievement.percentComplete / 100)];
                }
                else if (indexEnemie < [ACHIEVEMENT_ENEMIES count] &&
                         [((NSString *)[tabParseIdentifer objectAtIndex:[tabParseIdentifer count] - 1]) isEqualToString:@"Enemies"]) {
                    [[UserData defaultUser] setEnemy_score:(int)([[ACHIEVEMENT_ENEMIES objectAtIndex:indexEnemie] integerValue] * currentAchievement.percentComplete / 100)];
                }
            }
            
            if ([((NSString *)[tabParseIdentifer objectAtIndex:[tabParseIdentifer count] - 1]) isEqualToString:@"plums"]) {
                indexPlums += 2;
            }
            else if ([((NSString *)[tabParseIdentifer objectAtIndex:[tabParseIdentifer count] - 1]) isEqualToString:@"Enemies"]) {
                indexEnemie += 2;
            }
        }
        [UserData saveUserData];
    }];
    
}

@end
