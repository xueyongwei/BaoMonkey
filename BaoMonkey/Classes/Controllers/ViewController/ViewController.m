//
//  ViewController.m
//  iosGame
//
//  Created by iPPLE on 05/05/2014.
//  Copyright (c) 2014 iPPLE. All rights reserved.
//

#import "ViewController.h"
#import "Define.h"
#import "PreloadData.h"
#import "UserData.h"
#import "Achievement.h"
#import "GameCenter.h"
#import "GameController.h"
#import "MyScene.h"
#import "iAdController.h"
#import "RewardVideoManager.h"
@interface ViewController ()
@property (nonatomic) MyScene *scene;
@property (nonatomic) SKView *skView;

@end

@implementation ViewController

- (void) initGame {
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"] == FALSE) {
//        [self launchTutorial];
//        //return ;
//    } else {
        _scene = [MyScene sceneWithSize:_skView.bounds.size];
        _scene.scaleMode = SKSceneScaleModeAspectFill;
        [_skView presentScene:_scene transition:[SKTransition
                                                 pushWithDirection:SKTransitionDirectionLeft duration:0.5]];
//    }
}

- (void) relaunchGame {
    _scene = nil;
    _scene = [MyScene sceneWithSize:_skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [_skView presentScene:_scene transition:[SKTransition
                                             pushWithDirection:SKTransitionDirectionRight duration:0.5]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self loadAssets];
    [UserData initUserData];
    [GameData pauseGame];
    
    _skView = (SKView *)self.view;
    _skView.showsFPS = NO;
    _skView.showsNodeCount = NO;
    [GameController initAccelerometer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initGame)
                                                 name:NOTIFICATION_START_GAME
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(relaunchGame)
                                                 name:NOTIFICATION_RETRY_GAME
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToHome)
                                                 name:NOTIFICATION_GO_TO_HOME
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToSettings)
                                                 name:NOTIFICATION_GO_TO_SETTINGS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(share)
                                                 name:@"notification_share"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareScore)
                                                 name:@"notification_share_score"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGameCenter)
                                                 name:NOTIFICATION_SHOW_GAME_CENTER
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(launchGameCenterLogin)
                                                 name:NOTIFICATION_SHOW_GAME_CENTER_LOGIN
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAD)
                                                 name:NOTIFICATION_SHOW_AD
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRewardVideo)
                                                 name:NOTIFICATION_SHOW_RewardVideo
                                               object:nil];
    

    srand((int)time(NULL));
    mainMenu = [[MainMenu alloc] initWithSize:_skView.frame.size];
    settingsMenu = [[Settings alloc] initWithSize:_skView.frame.size];
    [self goToHome];
    
    self.tmpArray = [NSMutableArray arrayWithObjects:@"这些都是改变内存的无效内容",@"增加了属性", nil];
    [self tmpFun];
}

-(void)tmpFun{
    NSArray *arr = @[@"调用了个无用的方法",@"并且创建了内存",@"这个可能并没什么用"];
    NSLog(@"%@",arr);
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void) loadAssets {
    if ([UserData getSoundEffectsUserVolume]) {
        [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"splash.mp3" atVolume:[UserData getSoundEffectsUserVolume] waitForCompletion:NO] key:DATA_SPLASH_SOUND];
        [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"coconut.mp3" atVolume:[UserData getSoundEffectsUserVolume] waitForCompletion:NO] key:DATA_COCONUT_SOUND];
    } else {
        [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"splash.mp3" atVolume:0.5 waitForCompletion:NO] key:DATA_SPLASH_SOUND];
        [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"coconut.mp3" atVolume:0.5 waitForCompletion:NO] key:DATA_COCONUT_SOUND];
    }
    
    [PreloadData loadDataWithKey:[SKTexture textureWithImage:[UIImage imageNamed:@"banana"]] key:DATA_BANANA_TEXTURE];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"coconut"] key:DATA_COCONUT_TEXTURE];
    [PreloadData loadDataWithKey:[SKTexture textureWithImage:[UIImage imageNamed:@"plum"]] key:DATA_PRUNE_TEXTURE];
    
    [PreloadData loadDataWithKey:[SKTexture textureWithImage:[UIImage imageNamed:@"monkey-waiting"]] key:DATA_MONKEY_WAITING];
    [PreloadData loadDataWithKey:[SKTexture textureWithImage:[UIImage imageNamed:@"monkey-waiting-coconut"]] key:DATA_MONKEY_WAITING_COCONUT];
    
    [PreloadData loadDataWithKey:[SKTexture textureWithImage:[UIImage imageNamed:@"platform"]] key:DATA_PLATEFORM];
    
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"button-play"] key:DATA_BUTTON_PLAY];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"button-pause"] key:DATA_BUTTON_PAUSE];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"button-replay"] key:DATA_BUTTON_REPLAY];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"button-home"] key:DATA_BUTTON_HOME];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"button-settings"] key:DATA_BUTTON_SETTINGS];
    
    //load gorille
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-walking-1"] key:@"gorilla-walking-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-walking-2"] key:@"gorilla-walking-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-walking-dead-1"] key:@"gorilla-walking-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-walking-dead-2"] key:@"gorilla-walking-dead-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-climbing-1"] key:@"gorilla-climbing-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-climbing-2"] key:@"gorilla-climbing-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-climbing-dead-1"] key:@"gorilla-climbing-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"gorilla-climbing-dead-2"] key:@"gorilla-climbing-dead-2"];

    //load commando
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-1"] key:@"commando-walking-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-2"] key:@"commando-walking-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-3"] key:@"commando-walking-3"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-4"] key:@"commando-walking-4"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-5"] key:@"commando-walking-5"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-6"] key:@"commando-walking-6"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-climbing-1"] key:@"commando-climbing-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-climbing-2"] key:@"commando-climbing-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-dead-1"] key:@"commando-walking-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-walking-dead-2"] key:@"commando-walking-dead-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-climbing-dead-1"] key:@"commando-climbing-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"commando-climbing-dead-2"] key:@"commando-climbing-dead-2"];
    
    //load lamberJack
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-chopping-1"] key:@"lamber-jack-chopping-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-chopping-2"] key:@"lamber-jack-chopping-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-chopping-3"] key:@"lamber-jack-chopping-3"];

    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-dead-1"] key:@"lamber-jack-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-dead-2"] key:@"lamber-jack-dead-2"];

    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-1"] key:@"lamber-jack-walking-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-2"] key:@"lamber-jack-walking-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-3"] key:@"lamber-jack-walking-3"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-4"] key:@"lamber-jack-walking-4"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-5"] key:@"lamber-jack-walking-5"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"lamber-jack-walking-6"] key:@"lamber-jack-walking-6"];
    
    //load hunter
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-1"] key:@"hunter-walking-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-2"] key:@"hunter-walking-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-3"] key:@"hunter-walking-3"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-4"] key:@"hunter-walking-4"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-5"] key:@"hunter-walking-5"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-walking-6"] key:@"hunter-walking-6"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-dead-1"] key:@"hunter-dead-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"hunter-dead-2"] key:@"hunter-dead-2"];

    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"munition-explosive"] key:@"munition-explosive"];
    
    //load monkey
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"waiting"] key:@"waiting"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"waiting-coconut"] key:@"waiting-coconut"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-1"] key:@"monkey-walking-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-2"] key:@"monkey-walking-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-3"] key:@"monkey-walking-3"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-4"] key:@"monkey-walking-4"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-5"] key:@"monkey-walking-5"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-6"] key:@"monkey-walking-6"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-1"] key:@"monkey-walking-coconut-1"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-2"] key:@"monkey-walking-coconut-2"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-3"] key:@"monkey-walking-coconut-3"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-4"] key:@"monkey-walking-coconut-4"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-5"] key:@"monkey-walking-coconut-5"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-walking-coconut-6"] key:@"monkey-walking-coconut-6"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"monkey-launch"] key:@"monkey-launch"];

    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"singe_lance"] key:@"lance"];
    
    //load plums
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"small-splash"] key:@"big-splash-plums"];
    [PreloadData loadDataWithKey:[SKTexture textureWithImageNamed:@"big-splash"] key:@"small-splash-plums"];
}

-(void)goToHome {
    [_skView presentScene:mainMenu transition:[SKTransition flipVerticalWithDuration:0.5]];
}

-(void)goToSettings {
    [_skView presentScene:settingsMenu
               transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5]];
}

-(void)share{
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    NSString *string = NSLocalizedString(@"Who is the last winner of this war? The greedy people? The cute animals? You can decide the result! https://itunes.apple.com/app/id1303327260", nil);
//    @"Who is the last winner of this war? The greedy people? The cute animals? You can decide the result! https://itunes.apple.com/app/id1303327260";
    [activityItems addObject:string];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    [activityViewController.navigationController.navigationBar setHidden:YES];
    [activityViewController performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)shareScore{
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    NSString *string = NSLocalizedString(@"Who is the last winner of this war? The greedy people? The cute animals? You can decide the result! https://itunes.apple.com/app/id1303327260", nil);
//    NSString *string = [NSString stringWithFormat:@"I get %ld ! Can you do better ? https://itunes.apple.com/app/id1303327260", (long)[GameData getScore]];
    [activityItems addObject:string];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypePostToWeibo];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)showGameCenter {
    [GameCenter showLeaderboardAndAchievements:YES withViewController:self];
}

-(void)launchGameCenterLogin {
    [GameCenter showGameCenterLoginWithViewController:self];
}

-(void)showAD {
    
//    [iAdController showADBannerWithViewController:self];
}

-(void)showRewardVideo{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[RewardVideoManager defaultManager] showRewardVideoInViewController:self Finished:^(UnityAdsFinishState state) {
            
        } error:^(NSString *message) {
        }];
    });
    
}
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
