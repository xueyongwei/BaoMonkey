//
//  MyScene+Climber.m
//  BaoMonkey
//
//  Created by iPPLE on 22/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "MyScene+Climber.h"
#import "Enemy.h"
#import "Climber.h"

@implementation MyScene (Climber)

- (void) actionClimber {
    
    for (Enemy *currrentEnemy in self->enemiesController.enemies) {
        if ([currrentEnemy isKindOfClass:[Climber class]]) {
            if (((Climber *)currrentEnemy).isClimb == NO) {
                [((Climber *)currrentEnemy) actionClimber:monkey.sprite.position.y];
            }
            if (((Climber *)currrentEnemy).isOnPlateform == YES) {
                [self moveOnPlateform:(Climber *)currrentEnemy];
            }
        }
    }
}

- (void) animeMoveClimber :(Climber *)climber {
    NSArray *textures;

    if ([climber.node actionForKey:@"keyMove"] != nil)
        return ;
    if (climber.kind == MONKEY) {
        textures = @[[SKTexture textureWithImageNamed:@"gorilla-walking-1"],
                     [SKTexture textureWithImageNamed:@"gorilla-walking-2"]];
    }
    else {
        textures = @[[SKTexture textureWithImageNamed:@"commando-walking-1"],
                     [SKTexture textureWithImageNamed:@"commando-walking-2"],
                     [SKTexture textureWithImageNamed:@"commando-walking-3"],
                     [SKTexture textureWithImageNamed:@"commando-walking-4"],
                     [SKTexture textureWithImageNamed:@"commando-walking-5"],
                     [SKTexture textureWithImageNamed:@"commando-walking-6"]];
    }
    [climber.node runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textures
                                                                           timePerFrame:0.4]]
                    withKey:@"keyMove"];
}

- (void) moveOnPlateform:(Climber *)climber {
    CGPoint newPositionClimber;

    [self animeMoveClimber:climber];
    if (self->monkey.sprite.position.x > climber.node.position.x) {
        climber.node.xScale = 1.0;
        newPositionClimber = CGPointMake(climber.node.position.x + 1,
                                         climber.node.position.y);
    }
    else {
        climber.node.xScale = -1.0;
        newPositionClimber = CGPointMake(climber.node.position.x - 1,
                                         climber.node.position.y);
    }
    climber.node.position = newPositionClimber;
}

@end
