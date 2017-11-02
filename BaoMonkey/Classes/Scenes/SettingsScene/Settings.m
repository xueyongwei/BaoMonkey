//
//  Settings.m
//  BaoMonkey
//
//  Created by iPPLE on 27/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "Settings.h"
#import "Define.h"
#import "BaoPosition.h"
#import "BaoSize.h"
#import "SpriteKitCursor.h"
#import "GameData.h"
#import "UserData.h"
#import "Music.h"
#import "PreloadData.h"
#import <IAPShare.h>
#import "RewardVideoManager.h"

@interface Settings ()
@property (nonatomic, strong) SpriteKitCursor *cursorVolumeSound;
@property (nonatomic, strong) SpriteKitCursor *cursorVolumeMusic;
@property (nonatomic, strong) SpriteKitCursor *cursorAccelerometer;
@property (nonatomic, strong) id currentCursorClicked;
@property (nonatomic, strong) SKScene *parentScene;
@property (nonatomic, assign) CGPoint prevLocationCursor;
@end

@implementation Settings

- (void) customCursor {
    [_cursorAccelerometer setCursorTexture:[UIImage imageNamed:@"cursor-settings"]];
    [_cursorVolumeMusic setCursorTexture:[UIImage imageNamed:@"cursor-settings"]];
    [_cursorVolumeSound setCursorTexture:[UIImage imageNamed:@"cursor-settings"]];
    
    [_cursorAccelerometer setBackgroundTexture:[UIImage imageNamed:@"progress-settings"]];
    [_cursorVolumeSound setBackgroundTexture:[UIImage imageNamed:@"progress-settings"]];
    [_cursorVolumeMusic setBackgroundTexture:[UIImage imageNamed:@"progress-settings"]];
}

- (void) initCursor {
    
    _cursorVolumeSound = [[SpriteKitCursor alloc] initWithSize:[BaoSize cursorSettings]
                                                      position:[BaoPosition cursorSoundEffectsSettings]];
    
    _cursorVolumeMusic = [[SpriteKitCursor alloc] initWithSize:[BaoSize cursorSettings]
                                                      position:[BaoPosition cursorMusicSettings]];
    
    _cursorAccelerometer = [[SpriteKitCursor alloc] initWithSize:[BaoSize cursorSettings]
                                                        position:[BaoPosition cursorAccelerometerSettings]];
    
    [_cursorVolumeMusic setCurrentValue:[UserData getMusicUserVolume] * 100];
    [_cursorVolumeSound setCurrentValue:[UserData getSoundEffectsUserVolume] * 100];
    [_cursorAccelerometer setCurrentValue:[UserData getAccelerometerUserSpeed]];
    [self customCursor];
}

- (void) initButton {
    SKSpriteNode *backButton = [[SKSpriteNode alloc] initWithImageNamed:@"back-button-settings"];
    backButton.position =  CGPointMake(SCREEN_WIDTH*0.12, SCREEN_HEIGHT *0.91);
    backButton.size = [BaoSize settingBackBtnSize];
    backButton.name = @"back";
    [self addChild:backButton];
    
    SKSpriteNode *restoreButton = [[SKSpriteNode alloc] initWithImageNamed:@"button-game-restore"];
    restoreButton.position =  CGPointMake(SCREEN_WIDTH*0.34, SCREEN_HEIGHT *0.195);
    restoreButton.size = [BaoSize settingADBtnSize];
    restoreButton.name = @"restore";
    [self addChild:restoreButton];
    
    SKSpriteNode *removeAdButton = [[SKSpriteNode alloc] initWithImageNamed:@"button-game-removeAD"];
    removeAdButton.position =  CGPointMake(SCREEN_WIDTH*0.66, SCREEN_HEIGHT *0.195);
    removeAdButton.size = [BaoSize settingADBtnSize];
    removeAdButton.name = @"removeAd";
    [self addChild:removeAdButton];
    
    [self analyScene];
}

- (instancetype) initWithSize:(CGSize)size withParentScene:(SKScene *)parentScene {
    self = [super initWithSize:size];
    
    if (self != nil) {
        
        SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"background-settings"];
        background.position = [BaoPosition middleScreen];
        background.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addChild:background];
        
        [self initCursor];
        
        [_cursorAccelerometer addChild:self];
        [_cursorVolumeMusic addChild:self];
        [_cursorVolumeSound addChild:self];
        
        _parentScene = parentScene;
        [self initButton];
    }
    return (self);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"back"]) {
        [(SKSpriteNode*)node setTexture:[SKTexture textureWithImageNamed:@"back-button-settings-selected"]];
    
    }else if ([node.name isEqualToString:@"restore"]){
        [self restoreIAP];
    }else if ([node.name isEqualToString:@"removeAd"]){
        [self initIAP];
    }
    
    NSArray *array = [touches allObjects];
    
    for (UITouch *touch in array) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node.name isEqualToString:@"cursor"]) {
            if ([_cursorAccelerometer checkCursorClickWithNode:node] == YES)
                _currentCursorClicked = _cursorAccelerometer;
            else if ([_cursorVolumeMusic checkCursorClickWithNode:node] == YES)
                _currentCursorClicked = _cursorVolumeMusic;
            else if ([_cursorVolumeSound checkCursorClickWithNode:node] == YES)
                _currentCursorClicked = _cursorVolumeSound;
            return;
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    _prevLocationCursor = ((SpriteKitCursor *)_currentCursorClicked).cursor.position;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:@"back"];
    [node setTexture:[SKTexture textureWithImageNamed:@"back-button-settings"]];

    if ([_currentCursorClicked isEqual:_cursorAccelerometer])
        [_cursorAccelerometer updatePositionCursorWithLocation:location];
    else if ([_currentCursorClicked isEqual:_cursorVolumeMusic])
        [_cursorVolumeMusic updatePositionCursorWithLocation:location];
    else if ([_currentCursorClicked isEqual:_cursorVolumeSound])
        [_cursorVolumeSound updatePositionCursorWithLocation:location];
        
    if (location.x - _prevLocationCursor.x > 0) {
        [((SpriteKitCursor *)_currentCursorClicked).cursor runAction:[SKAction rotateByAngle:-0.1f duration:0.1f]];
    } else if (location.x - _prevLocationCursor.x < 0) {
        [((SpriteKitCursor *)_currentCursorClicked).cursor runAction:[SKAction rotateByAngle:0.1f duration:0.1f]];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"back"]) {
        [(SKSpriteNode*)node setTexture:[SKTexture textureWithImageNamed:@"back-button-settings"]];
        [UserData setAccelerometerUserSpeed:_cursorAccelerometer.currentValue];
        [self updateMusicUserVolume];
        [self updateSoundEffectsUserVolume];
        [self.view presentScene:_parentScene transition:[SKTransition pushWithDirection:SKTransitionDirectionDown duration:1.0f]];
    }
    if (_currentCursorClicked != nil) {
        [UserData setAccelerometerUserSpeed:_cursorAccelerometer.currentValue];
        [self updateMusicUserVolume];
        [self updateSoundEffectsUserVolume];
    }
    _currentCursorClicked = nil;
}

- (void) updateMusicUserVolume {
        [Music updateBackgroundMusicVolume:_cursorVolumeMusic.currentValue / 100.0];
        [UserData setMusicUserVolume:_cursorVolumeMusic.currentValue / 100.0];
}

- (void) updateSoundEffectsUserVolume {
    [PreloadData removeDataWithKey:DATA_SPLASH_SOUND];
    [PreloadData removeDataWithKey:DATA_COCONUT_SOUND];
    [UserData setSoundEffectsUserVolume:_cursorVolumeSound.currentValue / 100.0];
    [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"splash.mp3"
                                                        atVolume:_cursorVolumeSound.currentValue / 100.0
                                               waitForCompletion:NO] key:DATA_SPLASH_SOUND];
    [PreloadData loadDataWithKey:[PreloadData playSoundFileNamed:@"coconut.mp3"
                                                        atVolume:_cursorVolumeSound.currentValue / 100.0
                                               waitForCompletion:NO] key:DATA_COCONUT_SOUND];
}

- (void) updateAccelerometerUserSpeed {
    [UserData setAccelerometerUserSpeed:_cursorAccelerometer.currentValue + 1.0];
}

- (void) popBubble:(NSTimeInterval)currentTime {
    static NSTimeInterval timer = 0;
    //NSArray *tabImage = @[@"water-bubble-1", @"water-bubble-2", @"water-bubble-3"];
    
    if (timer == 0) {
        timer = rand() % 2 + 1 + currentTime;
    }
    
    if (currentTime >= timer) {
        SKSpriteNode *bubble = [SKSpriteNode spriteNodeWithImageNamed:@"water-bubble-2"];
        
        bubble.position = [BaoPosition bubblePositionSettings];
        bubble.zPosition = 100;
        
        [self addChild:bubble];
        
        if (bubble.position.x <= SCREEN_WIDTH / 2) {
            [bubble runAction:[SKAction moveToY:SCREEN_HEIGHT*0.8 duration:2.0]];
            [bubble runAction:[SKAction fadeOutWithDuration:2.0]];
        }
        else {
            [bubble runAction:[SKAction moveToY:SCREEN_HEIGHT*0.8 duration:1.5]];
            [bubble runAction:[SKAction fadeOutWithDuration:2.0]];
        }
        timer = 1.75f + currentTime;
    }
}

- (void) update:(NSTimeInterval)currentTime {
    [self popBubble:currentTime];
}


#pragma mark -- IAP

-(void)restoreIAP{
    CoreSVPLoading(@"Restore..", NO);
    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
        if (error) {
            CoreSVPCenterMsg(error.localizedDescription);
        }else{
            CoreSVPCenterMsg(@"sucess!");
        }
        
        for (SKPaymentTransaction *transaction in payment.transactions)
        {
            NSString *purchased = transaction.payment.productIdentifier;
            if([purchased isEqualToString:@"com.myproductType.product"])
            {
                //enable the prodcut here
                [[RewardVideoManager defaultManager] removeAD];
            }
        }
    }];
}
-(void)initIAP{
    
    __weak typeof(self)wkSelf = self;
    CoreSVPLoading(@"wait..", NO);
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if (response.products.count>0) {
             [response.products enumerateObjectsUsingBlock:^(SKProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([obj.productIdentifier isEqualToString:@"201"]) {
                     [wkSelf buyProduct:obj];
                     *stop = YES;
                 }
                 if (obj== response.products.lastObject && *stop != YES) {
                     [CoreSVP dismiss];
                     CoreSVPCenterMsg(@"无产品信息！");
                 }
             }];
         }else{
             [CoreSVP dismiss];
             CoreSVPCenterMsg(@"无产品信息！");
         }
     }];
}
-(void)buyProduct:(SKProduct*)product{
    __weak typeof(self) wkSelf = self;
    [[IAPShare sharedHelper].iap buyProduct:product
                               onCompletion:^(SKPaymentTransaction* trans){
                                   
                                   if(trans.error)
                                   {
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Failed purchase", nil));
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                       [CoreSVP dismiss];
                                       
                                       [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Successful purchase！", nil));
                                       [wkSelf iapSucessedWithProduct:product];
                                   }
                                   else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                       [CoreSVP dismiss];
                                       CoreSVPCenterMsg(NSLocalizedString(@"Failed purchase", nil));
                                   }
                               }];//end of buy product
    
}
-(void)iapSucessedWithProduct:(SKProduct *)product{
    //    [gameCenterNode setTexture:[SKTexture textureWithImageNamed:@"button-game-center"]];
    [[RewardVideoManager defaultManager] removeAD];
}
@end
