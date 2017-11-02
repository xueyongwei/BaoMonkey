//
//  Resume.h
//  BaoMonkey
//
//  Created by Jeremy Peltier on 20/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Define.h"

@interface Resume : NSObject

+(SKSpriteNode *)backgroundNode;
+(SKSpriteNode *)replayNode;
+(SKSpriteNode *)resumeNode;
+(SKSpriteNode *)homeNode;
+(SKSpriteNode *)settingsNode;
+(SKSpriteNode *)gameOverNode;

@end
