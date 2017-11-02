//
//  MyScene.m
//  iosGame
//
//  Created by iPPLE on 05/05/2014.
//  Copyright (c) 2014 iPPLE. All rights reserved.
//

#import "MyScene.h"
#import "MyScene+GeneratorWave.h"
#import "MyScene+Climber.h"
#import "BaoButton.h"
#import "MyScene+LoadBoss.h"
#import "GameCenter.h"
#import "Settings.h"
#import "Banana.h"
#import "MyScene+Tutorial.h"
#import "BaoFontSize.h"
#import "RewardVideoManager.h"
#import <YYKit.h>
#import "AlertNode.h"
#import "Music.h"
@interface MyScene()
@property (nonatomic,strong)AlertNode *alertNode;
@property (nonatomic,assign)NSInteger reliveTimes;
@end
@implementation MyScene
{
    
}
+ (SKSpriteNode *)spriteNodeWithImageNamed:(NSString *)name {
    if (IPAD) {
        name = [NSString stringWithFormat:@"ipad-%@", name];
    } else {
        name = [NSString stringWithFormat:@"iphone-%@", name];
    }
    return [SKSpriteNode spriteNodeWithImageNamed:name];
}
-(void)didMoveToView:(SKView *)view
{
    
}
-(SKLabelNode *)pauseNode {
    SKLabelNode *node = [SKLabelNode labelNodeWithFontNamed:@"Ravie"];
    node.text = [NSString stringWithFormat:@"Pause"];
    node.fontSize = 25;
    node.position = CGPointMake([UIScreen mainScreen].bounds.size.width - 50,
                                [UIScreen mainScreen].bounds.size.height - 30);
    node.name = PAUSE_BUTTON_NODE_NAME;
    node.zPosition = 55;
    return node;
}

-(void)createButtons {
    [self addChild:[BaoButton pause]];
}

-(void)updateTrunkTexture{
    NSInteger trunkLife = [GameData getTrunkLife];
    static NSInteger step = 0;
    
    if ((trunkLife > 90 && trunkLife <= 100) && step != 0) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-0"]];
        step = 0;
    } else if ((trunkLife > 80 && trunkLife <= 90) && step != 1) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-1"]];
        step = 1;
    } else if ((trunkLife > 70 && trunkLife <= 80) && step != 2) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-2"]];
        step = 2;
    } else if ((trunkLife > 60 && trunkLife <= 70) && step != 3) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-3"]];
        step = 3;
    } else if ((trunkLife > 50 && trunkLife <= 60) && step != 4){
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-4"]];
        step = 4;
    } else if ((trunkLife > 40 && trunkLife <= 50) && step != 5) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-5"]];
        step = 5;
    } else if ((trunkLife > 30 && trunkLife <= 40) && step != 6) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-6"]];
        step = 6;
    } else if ((trunkLife > 20 && trunkLife <= 30) && step != 7) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-7"]];
        step = 7;
    } else if ((trunkLife > 10 && trunkLife <= 20) && step != 8) {
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-8"]];
        step = 8;
    } else if ((trunkLife > 0 && trunkLife <= 10) && step != 9){
        [trunk setTexture:[SKTexture textureWithImageNamed:@"trunk-step-9"]];
        step = 9;
    }
}

-(SKSpriteNode *)backgroundNode {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"background-center"];
    node.position = CGPointMake((SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2));
    node.name = TRUNK_NODE_NAME;
    node.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    return node;
}

-(SKSpriteNode *)trunkNode{
    trunk = [SKSpriteNode spriteNodeWithImageNamed:@"trunk-step-0"];
    CGFloat h1w = trunk.size.height/trunk.size.width;
    CGFloat w = SCREEN_WIDTH *0.376;
    trunk.size = CGSizeMake(w, w*h1w);
    trunk.name = TRUNK_NODE_NAME;
    trunk.position = [BaoPosition trunk];
    return trunk;
}

-(SKSpriteNode *)frontLeafNode {
    frontLeaf = [SKSpriteNode spriteNodeWithImageNamed:@"front-leafs"];
    
    CGFloat h1w = frontLeaf.size.height/frontLeaf.size.width;
    frontLeaf.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*h1w);
    frontLeaf.name = FRONT_LEAF_NODE_NAME;
    frontLeaf.position = [BaoPosition frontLeafs:frontLeaf.size];
    frontLeaf.zPosition = 50;
    return frontLeaf;
}

-(SKSpriteNode *)backLeafNode {
    backLeaf = [SKSpriteNode spriteNodeWithImageNamed:@"back-leafs"];
    CGFloat h1w = backLeaf.size.height/backLeaf.size.width;
    backLeaf.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*h1w);
    backLeaf.name = BACK_LEAF_NODE_NAME;
    backLeaf.position = [BaoPosition backLeafs:backLeaf.size];
    return backLeaf;
}

-(void)scoreNode {
    score = [SKLabelNode labelNodeWithFontNamed:@"Ravie"];
    score.text = [NSString stringWithFormat:@"%ld", (long)[[GameData singleton] getScore]];
    score.fontSize = [BaoFontSize scoreFontSize];
    score.position = [BaoPosition score];
    score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    score.name = SCORE_NODE_NAME;
    score.zPosition = 55;
}

-(SKLabelNode*)countDownNode {
    SKLabelNode *countDownNode = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    countDownNode.text = @"3";
    countDownNode.fontSize = 120;
    countDownNode.position = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT / 2) - (countDownNode.fontSize / 2));
    countDownNode.name = COUNTDOWN_NODE_NAME;
    return countDownNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if (([GameData isGameOver] && [node.name isEqualToString:RETRY_NODE_NAME]) ||
        [node.name isEqualToString:RETRY_NODE_NAME]) {
        [GameData resetGameData];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RETRY_GAME object:nil];
        return ;
    }
    
    if ([node.name isEqualToString:PAUSE_BUTTON_NODE_NAME]) {
        if (![GameData isPause]) {
            [self pauseGameWithScene:TRUE];
        }
    } else if ([node.name isEqualToString:RESUME_NODE_NAME]){
        if ([GameData isPause]) {
            [self resumeGame];
        }
    }else if (location.y <= [UIScreen mainScreen].bounds.size.height - 30) {
        if (![GameData isPause]) {
            if (monkey == nil)
                NSLog(@"monkey is nil");
            [monkey launchWeapon];
        }
    }

    if ([node.name isEqualToString:@"TUTORIAL_STEP"]) {
        [node removeFromParent];
        [self resumeGame];
        [self removeTimer];
    }
    
//    SKNode *child = [self childNodeWithName:@"TUTORIAL_STEP"];
//    if (child != nil) {
//        if ([node.name isEqualToString:@"TUTORIAL_STEP"]) {
//            [child removeFromParent];
//            [self resumeGame];
//            [self removeTimer];
//        }
//
//    }
    
    if ([node.name isEqualToString:HOME_NODE_NAME]){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GO_TO_HOME object:nil];
    }
    
    if ([node.name isEqualToString:SETTINGS_NODE_NAME]){
        [self.view presentScene:[[Settings alloc] initWithSize:self.size withParentScene:self]
                     transition:[SKTransition fadeWithDuration:1.0]];
    }
    
    __weak typeof(self) wkSelf = self;
    if([node.name isEqualToString:@"ALERT_OK"]){
        [self.alertNode animateDismissComplete:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wkSelf monkeyBeShutToDie];
            });
        }];
    }else if ([node.name isEqualToString:@"ALERT_NO"]){
        [self.alertNode animateDismissComplete:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wkSelf monkeyBeShutToDie];
            });
        }];
    }else if ([node.name isEqualToString:@"ALERT_YES"]){
        [Music pauseBackgroundMusic];
        [[RewardVideoManager defaultManager] showUnitsAD:self.view.viewController finished:^(UnityAdsFinishState state) {
            [Music playBackgroundMusic];
            if (state == kUnityAdsFinishStateCompleted){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wkSelf.alertNode animateDismissComplete:^{
                        [wkSelf resumeGame];
                        wkSelf.reliveTimes+=1;
                    }];
                });
            }else{
                
                CoreSVPCenterMsg(@"fail!");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wkSelf monkeyBeShutToDie];
                });
            }
        }];
    }
}

- (void) initMonkey {
    monkey = [[Monkey alloc] initWithPosition:[BaoPosition monkey]];
    
    [self addChild:monkey.sprite];
    [self addChild:monkey.collisionMask];
}

- (void) pauseGame {
    [self pauseGameWithScene:YES];
}

- (void) initScene {
    [self initTimerTutorial];
    
    [UserData defaultUser].boss = NO;
    
    self.backgroundColor = [SKColor colorWithRed:52/255.0f green:152/255.0f blue:219/255.0f alpha:1];

    [self addChild:[self backgroundNode]];
    
    [self addChild:[self backLeafNode]];

    [self addChild:[self trunkNode]];
    
    _sizeBlock = (self.frame.size.width - (self.frame.size.width / 10)) / 10;
    _treeBranch = [[TreeBranch alloc] init];
//    _treeBranch.node.position = CGPointMake(_treeBranch.node.position.x, trunk.position.y+trunk.size.height/2);
    self.physicsBody = [SKPhysicsBody
                        bodyWithEdgeLoopFromRect:CGRectMake(_treeBranch.node.frame.origin.x,
                                                            _treeBranch.node.frame.origin.y -
                                                            (_treeBranch.node.frame.size.height / 2) +
                                                            (_treeBranch.node.frame.size.height / 2),
                                                            _treeBranch.node.frame.size.width,
                                                            _treeBranch.node.frame.size.height / 2)];
    
    [self addChild:_treeBranch.node];
    
    [self initMonkey];
    
    // Init enemies controller
    enemiesController = [[EnemiesController alloc] initWithScene:self];
    
    [self addChild:[self frontLeafNode]];
    
    [self scoreNode];
    [self addChild:score];
    
    [self createButtons];
    
    [[GameData singleton] initPause];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGame)
                                                 name:NOTIFICATION_PAUSE_GAME object:nil];
    
    
    pauseTime = 0;
    lastTime = 0;
    oncePause = 0;
    oncePlay = -1;
    
    menuTransition = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _updateCurrentTime = FALSE;
        lastCurrentTime = 0;
        [[GameData singleton] initGameData];
        [self initScene];
        [GameData pauseGame];
        [self gameCountDown];
    }
    return self;
}

- (void) gameCountDown {
    static BOOL resumeGame = NO;
    
    if (resumeGame){
        resumeGame = NO;
        [GameData resumeGame];

        // Reactive speed & physics
        self.speed = 1.0;

        for (Item *item in _wave) {
            [item resumeTimer];
            if (item.isTaken == NO)
                item.node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:item.node.frame.size.width / 2];
        }

        [self enumerateChildNodesWithName:WEAPON_NODE_NAME usingBlock:^(SKNode *node, BOOL *stop) {
            node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:node.frame.size.width / 2];
        }];
    }
    else {
        resumeGame = YES;
        [self performSelector:@selector(gameCountDown) withObject:nil afterDelay:1.0];
    }
}

-(void)displayGameOverMenu {
    self.reliveTimes=0;
    GameOverScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size andScene:self];
    [self.view presentScene:gameOverScene transition:menuTransition];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_RewardVideo object:nil];
}

- (void) gameOverCountDown {
    static BOOL gameOver = NO;
    
    if (gameOver) {
        gameOver = NO;
        [GameData pauseGame];
        [self displayGameOverMenu];
    }
    else {
        [GameData gameOver];
        gameOver = YES;
        [self performSelector:@selector(gameOverCountDown) withObject:nil afterDelay:2.0];
    }
}

- (void) pauseGameWithScene:(BOOL)show {
    self.speed = 0;
    for (Item *item in _wave) {
        [item pauseTimer];
        item.node.physicsBody = nil;
    }
    
    [self enumerateChildNodesWithName:WEAPON_NODE_NAME usingBlock:^(SKNode *node, BOOL *stop) {
        node.physicsBody = nil;
    }];

    [GameData pauseGame];

    // Present pause scene
    if (show) {
        [_timerLoop freezeTimer];
        PauseScene *pauseScene = [[PauseScene alloc] initWithSize:self.size andScene:self];
        [self.view presentScene:pauseScene transition:menuTransition];
    }    
}

- (void) resumeGame {
    //[self removePauseView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESUME_GAME object:nil];
    [self gameCountDown];
}

- (void) deadTree {

    if ([GameData isGameOver] == YES)
        return ;
    
    SKSpriteNode *crack = [SKSpriteNode spriteNodeWithImageNamed:NSLocalizedString(@"crack-tree", nil)];
    
    crack.zPosition = 50;
    crack.size = CGSizeMake(crack.size.width / 2, crack.size.height / 2);
    crack.position = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,
                                 FLOOR_HEIGHT + (IPAD_NOT_RETINA ? [UIImage imageNamed:@"lamber-jack-chopping-1"].size.height / 2:
                                                 [UIImage imageNamed:@"lamber-jack-chopping-1"].size.height));
    
    [self addChild:crack];
    [crack runAction:[SKAction resizeToWidth:crack.size.width * 2 height:crack.size.height * 2 duration:0.5] completion:^{
        self.physicsBody = nil;
        monkey.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:monkey.sprite.size];
        monkey.sprite.physicsBody.affectedByGravity = YES;
    }];
}

- (void) moveperso {
    if ([GameData isGameOver] == true || [GameData isPause] == true) {
        return ;
    }
    
    static CMMotionManager *motion;
    
    if (motion == nil) {
        motion = [[CMMotionManager alloc] init];
        [motion startAccelerometerUpdates];
    }
    
    monkey.sprite.position = CGPointMake(monkey.sprite.position.x + motion.accelerometerData.acceleration.x * 20,
                                         monkey.sprite.position.y);
    
    float maxX = SCREEN_WIDTH + (monkey.sprite.size.width / 2);
    float minX = -(monkey.sprite.size.width / 2);
    
    if (monkey.sprite.position.x > maxX) {
        monkey.sprite.position = CGPointMake(minX, monkey.sprite.position.y);
    } else if (monkey.sprite.position.x < minX) {
        monkey.sprite.position = CGPointMake(maxX, monkey.sprite.position.y);
    }
    
    [monkey updateMonkeyPosition:motion.accelerometerData.acceleration.x];
}

-(void)update:(CFTimeInterval)currentTime {
    if (_timerLoop == nil) {
        _timerLoop = [[RRLoopTimerUpdate alloc] init:currentTime];
    }
    
    
    currentTime += _timerLoop.rangeTimer;
    
    
    //currentTime -= pauseTime;
    //lastCurrentTime = currentTime;
    [self moveperso];
    
    if ([[GameData singleton] isPause]) {
        
        dispatch_once(&oncePause, ^{
            oncePlay = 0;
            lastTime = currentTime;
        });
        return;
    }
        
    dispatch_once(&oncePlay, ^{
        oncePause = 0;
        pauseTime += currentTime - lastTime;
    });
    
    [self displayTutorial:currentTime];
    
    [monkey manageShield:currentTime andScene:self];
    
    [self addNewWeapon:currentTime];
    [self addNewWave:currentTime];
    //[self addBonus:currentTime];
    
    [GameController updateAccelerometerAcceleration];
    //[monkey updateMonkeyPosition:[GameController getAcceleration]];
    
    [enemiesController updateEnemies:currentTime];
    
    for (id item in _wave) {
        if (((Item *)item).isTaken == NO) {
            if (CGRectIntersectsRect(((Item *)item).node.frame, monkey.collisionMask.frame)) {
                [monkey catchItem:item :self];
                if ([((Item *)item) isKindOfClass:[Banana class]]) {
                    [Item deleteItemAfterTimer:(Item *)item];
                    [_wave removeObject:item];
                }
                break;
            }
        }
    }
    
    if ([UserData defaultUser].boss == NO) {
        [self enumerateChildNodesWithName:SHOOT_NODE_NAME usingBlock:^(SKNode *node, BOOL *stop) {
            if (CGRectIntersectsRect(node.frame, monkey.collisionMask.frame)) {
                if (!monkey.isShield) {
                    if(self.reliveTimes>0){
                        [ self monkeyBeShutToDie ];
                    }else{
                        [self pauseGameWithScene:NO];
                        self.speed = 1;
                        self.alertNode = [[AlertNode alloc] initWithType:SKAlertTypeInquiry message:@"You're shot.\nwatch an ad video to revive?"];
                        [self.alertNode showInNode:self];
                    }
                    
//                    __weak typeof(self) wkSelf = self;
//                    alertNode.cancleBlock = ^{
//                        [wkSelf monkeyBeShutToDie];
//                    };
//                    alertNode.finishBlock = ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_AD object:nil];
//                    };
                    
                } else {
                    [monkey.shield removeFromParent];
                    monkey.isShield = FALSE;
                }
                [node removeFromParent];
            }
        }];
    }

    [UserData updateScore:10];
    
    for (Item *item in _wave) {
        if (item.isOver == YES) {
            [_wave removeObject:item];
            break;
        }
    }
    
    [self enumerateChildNodesWithName:WEAPON_NODE_NAME usingBlock:^(SKNode *weaponNode, BOOL *stop) {
        for (Enemy *enemy in self->enemiesController.enemies) {
            
            if ([weaponNode intersectsNode:enemy.node]) {
                [UserData addEnemy];
                [self->enemiesController deleteEnemy:enemy];
                [weaponNode removeFromParent];
                for (Item *item in _wave) {
                    if (item.node == weaponNode) {
                        [_wave removeObject:item];
                        break;
                    }
                }
                break;
            }
        }
    }];
    
    [GameData regenerateTrunkLife];
    
    for (Enemy *enemy in self->enemiesController.enemies) {
        if (enemy.type == EnemyTypeLamberJack) {
            if (((LamberJack *)enemy).isChooping) {
                [[GameData singleton] substractLifeToTrunkLife:LUMBERJACK_DESTROY_POINT];
            }
        }
        else if (enemy.type == EnemyTypeHunter && ((Hunter *)enemy).isMoving == NO) {
            SKSpriteNode *tmp = [((Hunter *)enemy) shootMonkey:currentTime
                                                              :monkey.collisionMask.position];
            if (tmp != nil)
                [self addChild:tmp];
        }
    }
    
    [self actionClimber];
    
    if ([UserData defaultUser].boss == NO && [GameData getTrunkLife] < 0) {
        [self deadTree];
        [monkey deadMonkey];
        if (![GameData isGameOver])
            [self gameOverCountDown];
        // Call the GameOver view when the trunk is dead
    } else{
        [self updateTrunkTexture];
    }
    score.text = [NSString stringWithFormat:@"%ld", (long)[[GameData singleton] getScore]];
    
}

-(void)monkeyBeShutToDie{
    [monkey deadMonkey];
    if (![GameData isGameOver])
    [self gameOverCountDown];
    
}
-(void)alertToDie{
    
}
@end
