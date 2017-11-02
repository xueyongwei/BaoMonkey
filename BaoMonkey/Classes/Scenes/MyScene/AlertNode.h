//
//  AlertNode.h
//  BaoMonkey
//
//  Created by xueyognwei on 18/10/2017.
//  Copyright © 2017 BaoMonkey. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef NS_ENUM(NSInteger,SKAlertType) {
    SKAlertTypeInquiry,
    SKAlertTypeNotice,
};
@interface AlertNode : SKSpriteNode
//@property (nonatomic,strong) void(^cancleBlock)(void);
//@property (nonatomic,strong) void(^finishBlock)(void);
-(id)initWithType:(SKAlertType )type message:(NSString *)msg;
-(void)showInNode:(SKNode *)node;
-(void)animateDismissComplete:(void(^)(void))complete;
@end
