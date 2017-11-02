//
//  BaseScene.m
//  BaoMonkey
//
//  Created by xueyognwei on 2017/10/30.
//  Copyright © 2017年 BaoMonkey. All rights reserved.
//

#import "BaseScene.h"

@implementation BaseScene
-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self analyScene];
    }
    return self;
}
-(void )analyScene{
    self.sceneName = NSStringFromClass([self class]);
    NSLog(@"sceneName = %@",self.sceneName);
}
@end
