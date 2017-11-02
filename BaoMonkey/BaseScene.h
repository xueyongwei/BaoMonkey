//
//  BaseScene.h
//  BaoMonkey
//
//  Created by xueyognwei on 2017/10/30.
//  Copyright © 2017年 BaoMonkey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BaseScene : SKScene
@property (nonatomic,copy) NSString *sceneName;

-(void )analyScene;
@end
