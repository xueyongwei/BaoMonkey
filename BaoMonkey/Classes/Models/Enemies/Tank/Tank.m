//
//  Tank.m
//  BaoMonkey
//
//  Created by iPPLE on 21/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "Tank.h"
#import "BaoPosition.h"

#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f)

@interface Tank ()
@property (nonatomic, assign) CGPoint positionMediumStrat;
@property (nonatomic, assign) BOOL isShoot;
@property (nonatomic, assign) BOOL isMediumStrat;
@property (nonatomic, assign) BOOL isHardStrat;
@end

@implementation Tank

- (void) initSpriteTank {
    _tankSprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"chassis_tank"]]];
    _tankSprite.size = CGSizeMake(_tankSprite.size.width / 2, _tankSprite.size.height / 2);
    
    _tower = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"tower_tank"]]];
    _tower.size = CGSizeMake(_tower.size.width / 2, _tower.size.height / 2);
    
    _tower.zPosition = 45;

    _canon = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"canon_tank"]]];
    _canon.position = CGPointMake(_tankSprite.position.x, _tankSprite.position.y + _tankSprite.size.height / 2);
    _canon.zPosition = 20;
    _canon.size = CGSizeMake(_canon.size.width / 2, _canon.size.height / 2);
    
    _tankSprite.zPosition = 50;

    _wheel = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"wheel1_tank"]]];
    _wheel.zPosition = 50;
    _wheel.size = CGSizeMake(_wheel.size.width / 2, _wheel.size.height / 2);
    
    [_wheel runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImage:[UIImage imageNamed:@"wheel1_tank"]],
                                                                                    [SKTexture textureWithImage:[UIImage imageNamed:@"wheel2_tank"]],
                                                                                    [SKTexture textureWithImage:[UIImage imageNamed:@"wheel3_tank"]],
                                                                                    [SKTexture textureWithImage:[UIImage imageNamed:@"wheel4_tank"]]] timePerFrame:0.1]]];
}

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        [self initSpriteTank];
        
        _isHardStrat = _isMediumStrat = NO;
        
        _positionMediumStrat = CGPointMake(rand() % (int)([UIScreen mainScreen].bounds.size.width / 2) +
                                           ([UIScreen mainScreen].bounds.size.width / 2),
                                           [UIScreen mainScreen].bounds.size.height);
    }
    return (self);
}

- (void) move {
    if (_sens == RIGHT) {
        if (_tankSprite.position.x + 1 + (_tankSprite.size.width / 2) >=
            [UIScreen mainScreen].bounds.size.width) {
            _sens = LEFT;
            return ;
        }
        _tower.xScale = 1.0;
        _tankSprite.position = CGPointMake(_tankSprite.position.x + 1,
                                               _tankSprite.position.y);
    }
    else {
        if (_tankSprite.position.x - 1 - (_tankSprite.size.width / 2) <= 0) {
            _sens = RIGHT;
            return ;
        }
        _tower.xScale = -1.0;
        self.tankSprite.position = CGPointMake(_tankSprite.position.x - 1,
                                               _tankSprite.position.y);
    }
    _tower.position = CGPointMake(_tankSprite.position.x - 20, _tankSprite.position.y + _tankSprite.size.height / 2);
    _canon.position = CGPointMake(_tankSprite.position.x, _tankSprite.position.y + _tankSprite.size.height / 2);
    if (!IPAD)
        _wheel.position = CGPointMake(_tankSprite.position.x - 28, _wheel.size.height + 13);
    else
        _wheel.position = CGPointMake(_tankSprite.position.x - 50, _wheel.size.height - 3);
}

- (void) lowStrat:(CGPoint)positionMonkey :(SKScene *)scene {
    SKSpriteNode *nodeShoot = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"munition-explosive"]];
    if (!IPAD)
        nodeShoot.size = CGSizeMake(nodeShoot.size.width / 2, nodeShoot.size.height / 2);
    
    float angle = atan2f(positionMonkey.y, positionMonkey.x);
    nodeShoot.zRotation = angle;
    
    nodeShoot.position = _tankSprite.position;
    nodeShoot.name = NAME_SPRITE_SHOOT_TANK;
    
    SKAction *shoot = [SKAction moveTo:CGPointMake(rand() % 80 + (positionMonkey.x - 40),
                                                   [UIScreen mainScreen].bounds.size.height) duration:1.5];
    
    SKAction *wait = [SKAction waitForDuration:1.0 withRange:1.0];
    [scene addChild:nodeShoot];
    
    [nodeShoot runAction:wait completion:^{
        float angle = atan2f(positionMonkey.y, positionMonkey.x);
        _canon.zRotation = angle;
        [nodeShoot runAction:shoot];
    }];
}

- (void) shootFireBomb:(CGPoint)positionMonkey :(SKScene *)scene {
    SKSpriteNode *nodeShoot;
    
    nodeShoot = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"munition-fire"]];
    if (!IPAD)
        nodeShoot.size = CGSizeMake(nodeShoot.size.width / 3, nodeShoot.size.height / 3);
    
    float angle = atan2f(positionMonkey.y, positionMonkey.x);
    nodeShoot.zRotation = angle;
    
    nodeShoot.name = NAME_SPRITE_FIRE_TANK;
    [scene addChild:nodeShoot];
    
    nodeShoot.position = _tankSprite.position;
    SKAction *moveShoot = [SKAction moveTo:CGPointMake(rand() % (int)([UIScreen mainScreen].bounds.size.width),
                                                       positionMonkey.y) duration:2.0];
    
    [nodeShoot runAction:moveShoot completion:^{
        
        nodeShoot.color = [SKColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [nodeShoot removeFromParent];
        NSString *burstPath = [BaoPosition pathFireTank];
        
        SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        fire.position = CGPointMake(nodeShoot.position.x, [BaoPosition treeBranch].y);
        fire.name = NAME_SPRITE_FIRE_TANK;
        fire.zPosition = 1;
        [scene addChild:fire];

        SKSpriteNode *fireCollision = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(fire.frame.size.width, fire.frame.size.height)];
        fireCollision.position = fire.position;
        fireCollision.name = NAME_SPRITE_FIRE_TANK;
        fireCollision.zPosition = 300;
        [scene addChild:fireCollision];
        NSLog(@"display node");
        
        
        NSLog(@"%f / %f", fire.frame.size.width, fire.particlePositionRange.dx);
        
        SKSpriteNode *mask = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(fire.particlePositionRange.dx, 100)];
        mask.name = NAME_SPRITE_FIRE_TANK;
        mask.position = fire.position;
        [scene addChild:mask];
        
        _isShoot = YES;
    }];
}

- (void) mediumStrat:(CGPoint)positionMonkey :(SKScene *)scene {

    if (_isMediumStrat == NO) {
        _isMediumStrat = YES;
        _isShoot = NO;
        [self shootFireBomb:positionMonkey :scene];
    };
    if (_isShoot == 1) {
        [self lowStrat:positionMonkey :scene];
    }
}

- (void) hardStrat:(CGPoint)positionMonkey :(SKScene *)scene {

    if (_isHardStrat == NO) {
        _isHardStrat = YES;
        _isShoot = NO;
        
        [scene enumerateChildNodesWithName:NAME_SPRITE_FIRE_TANK usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
        [self shootFireBomb:CGPointMake(positionMonkey.x, [BaoPosition treeBranch].y - (IPAD ? 20 : 0)) :scene];
    };
    if (_isShoot == YES)
        [self lowStrat:positionMonkey :scene];
}

- (void) shootTank:(CGPoint)positionMonkey scene:(SKScene *)scene {
    if (_currentStrat == 0)
        [self lowStrat:positionMonkey :scene];
    else if (_currentStrat == 1)
        [self mediumStrat:positionMonkey :scene];
    else if (_currentStrat == 2)
        [self hardStrat:positionMonkey :scene];
}

@end
