//
//  GameController.h
//  BaoMonkey
//
//  Created by Jeremy Peltier on 07/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "Define.h"
#import "UserData.h"

@interface GameController : NSObject{
    CMMotionManager *motionManager;
    float acceleration;
    float speed;
}

+(id)singleton;

+(void)resetAccelerometer;
+(void)initAccelerometer;

+(void)updateAccelerometerAcceleration;
+(void)updateAcceleration:(float)acceleration;
+(float)getAcceleration;

@end
