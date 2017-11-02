//
//  GameData.m
//  BaoMonkey
//
//  Created by Jeremy Peltier on 07/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "GameData.h"
#import "UserData.h"
#import "Achievement.h"

@implementation GameData

static GameData *singleton;

+(id)singleton {
    if (!singleton) {
        singleton = [[GameData alloc] init];
    }
    return singleton;
}

#pragma mark - Init

+(void)resetGameData {
    [[GameData singleton] initGameData];
}

#pragma mark - Init

+(void)initGameData {
    [[GameData singleton] initGameData];
}

-(void)initGameData {
    score = 0;
    trunkLife = 100;
    gameOver = NO;
    level = 0;
    levels = [[NSArray alloc] initWithObjects:  [NSNumber numberWithInt:30],
                                                [NSNumber numberWithInt:50],
                                                [NSNumber numberWithInt:100],
                                                [NSNumber numberWithInt:300],
                                                [NSNumber numberWithInt:500],
                                                [NSNumber numberWithInt:600],
                                                [NSNumber numberWithInt:700],
                                                [NSNumber numberWithInt:800],
                                                [NSNumber numberWithInt:900],
                                                [NSNumber numberWithInt:1000], nil];
    
    settings = [NSUserDefaults standardUserDefaults];
    accelerometerUserSpeed = [settings floatForKey:NSUSERDEFAULT_ACCELEROMETER_SPEED];
    musicUserVolume = [settings floatForKey:NSUSERDEFAULT_MUSIC_VOLUME];
    soundEffectsUserVolume = [settings floatForKey:NSUSERDEFAULT_EFFECTS_VOLUME];
}

#pragma mark - Score Functions

+(NSInteger)getScore {
    return [[GameData singleton] getScore];
}

-(NSInteger)getScore {
    return score;
}

+(void)addPointToScore:(NSInteger)point {
    [[GameData singleton] addPointToScore:point];
}

-(void)addPointToScore:(NSInteger)point {
    score += point;
    [self setLevel];
}

+(void)substractPointToScore:(NSInteger)point {
    [[GameData singleton] substractPointToScore:point];
}

-(void)substractPointToScore:(NSInteger)point {
    score -= point;
    [self setLevel];
}

+(void)multiplyPointToScore:(NSInteger)point {
    [[GameData singleton] multiplyPointToScore:point];
}

-(void)multiplyPointToScore:(NSInteger)point {
    score *= point;
    [self setLevel];
}

+(void)dividePointToScore:(NSInteger)point {
    [[GameData singleton] dividePointToScore:point];
}

-(void)dividePointToScore:(NSInteger)point {
    score /= point;
    [self setLevel];
}

#pragma mark - Level Functions

+(NSUInteger)getLevel {
    return [[GameData singleton] getLevel];
}

-(NSUInteger)getLevel {
    return level;
}

-(void)setLevel {
    int i = 0;
    
    for (NSNumber *levelPoint in levels) {
        if (score < [levelPoint intValue]) {
            level = i;
            return ;
        }
        i++;
    }
}

#pragma mark - TrunkLife Functions

+(CGFloat)getTrunkLife {
    return [[GameData singleton] getTrunkLife];
}

-(CGFloat)getTrunkLife {
    return trunkLife;
}

+(void)addLifeToTrunkLife:(CGFloat)life {
    [[GameData singleton] addLifeToTrunkLife:life];
}

-(void)addLifeToTrunkLife:(CGFloat)life {
    trunkLife += life;
}

+(void)substractLifeToTrunkLife:(CGFloat)life {
    [[GameData singleton] substractLifeToTrunkLife:life];
}

-(void)substractLifeToTrunkLife:(CGFloat)life {
    trunkLife -= life;
}

+(void)multiplyLifeToTrunkLife:(CGFloat)life {
    [[GameData singleton] multiplyLifeToTrunkLife:life];
}

-(void)multiplyLifeToTrunkLife:(CGFloat)life {
    trunkLife *= life;
}

+(void)divideLifeToTrunkLife:(CGFloat)life {
    [[GameData singleton] divideLifeToTrunkLife:life];
}

-(void)divideLifeToTrunkLife:(CGFloat)life {
    trunkLife /= life;
}

+(void)regenerateTrunkLife {
    [[GameData singleton] regenerateTrunkLife];
}

-(void)regenerateTrunkLife {
    if (trunkLife < 100) {
        trunkLife += TRUNKLIFE_REGENERATE;
    }
}

#pragma mark - Pause Functions

+(BOOL)isGameOver {
    return ([[GameData singleton] isGameOver]);
}

-(BOOL)isGameOver {
    return (gameOver);
}

+(BOOL)isPause {
    return [[GameData singleton] isPause];
}

-(BOOL)isPause {
    return pause;
}

+(void)pauseGame {
    [[GameData singleton] pauseGame];
    
}

-(void)pauseGame {
    pause = YES;
}

+(void)resumeGame {
    [[GameData singleton] resumeGame];
}

-(void)resumeGame {
    pause = NO;
}

+(void)updatePause {
    [[GameData singleton] updatePause];
}

-(void)updatePause {
    if (pause)
        pause = FALSE;
    else
        pause = TRUE;
}

+(void)initPause {
    [[GameData singleton] initPause];
}

-(void)initPause {
    pause = FALSE;
}

+(void)gameOver {
    [[GameData singleton] gameOver];
}

-(void)gameOver {
    gameOver = YES;
}

@end
