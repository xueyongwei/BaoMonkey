//
//  AlertNode.m
//  BaoMonkey
//
//  Created by xueyognwei on 18/10/2017.
//  Copyright © 2017 BaoMonkey. All rights reserved.
//

#import "AlertNode.h"
#import "Define.h"
@implementation AlertNode

-(id)initWithType:(SKAlertType )type message:(NSString *)msg{
    if (self = [super initWithColor:[UIColor colorWithWhite:0 alpha:0.8] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        SKSpriteNode *body =[self bodyNode] ;
        body.position = CGPointMake(0, SCREEN_HEIGHT/2 + body.size.height);
        [self addChild:body];
       
        
//        buttonCancleNode.size = CGSizeMake((body.size.width-25)/2, 44) ;
        
        
        if (type == SKAlertTypeNotice ){
            SKSpriteNode *buttonOKNode = [self buttonNodeWithText:NSLocalizedString(@"OK", nil)];
            buttonOKNode.position = CGPointMake(0, -body.size.height/2 +10 +44);
            buttonOKNode.name = @"ALERT_OK";
            [body addChild:buttonOKNode];
        }else{
            SKSpriteNode *buttonCancleNode = [self buttonNodeWithText:NSLocalizedString(@"NO", nil)];
            buttonCancleNode.position = CGPointMake(-body.size.width*0.25, -body.size.height/2 +10 +44);
            buttonCancleNode.name = @"ALERT_NO";
            [body addChild:buttonCancleNode];
            
            SKSpriteNode *buttonYesNode = [self buttonNodeWithText:NSLocalizedString(@"YES", nil)];
            buttonYesNode.name = @"ALERT_YES";
            buttonYesNode.position = CGPointMake(body.size.width*0.25, -body.size.height/2 +10 +44);
            [body addChild:buttonYesNode];
        }
        NSArray *array = [msg componentsSeparatedByString:@"\n"];
        
        SKLabelNode *titleLabel = [SKLabelNode labelNodeWithText:NSLocalizedString(array.firstObject, nil) ];
        titleLabel.position = CGPointMake(0, 0);
        titleLabel.fontName = @"changchengtecuyuan";
        titleLabel.fontSize = 25;
        [body addChild:titleLabel];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithText:NSLocalizedString(array.lastObject,nil)];
        label.fontName = @"changchengteyuanti";
        label.fontSize = 16;
        label.position = CGPointMake(0, -body.size.height*0.15);
        [body addChild:label];
    }
    return self;
}
-(void)showInNode:(SKNode *)node{
    self.position = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    self.zPosition = 100;
    [node addChild:self ];
    
    SKSpriteNode *body = (SKSpriteNode *)[self childNodeWithName:@"body"];
    SKAction *moveDown = [SKAction moveTo:CGPointMake(0, SCREEN_HEIGHT/2-body.size.height/2) duration:0.5];
    [body runAction:moveDown];
    
}
-(void)animateDismissComplete:(void(^)(void))complete{
    SKSpriteNode *body = (SKSpriteNode *)[self childNodeWithName:@"body"];
    SKAction *moveDown = [SKAction moveTo:CGPointMake(0, SCREEN_HEIGHT/2+ body.size.height) duration:0.5];
    __weak typeof(self) wkSelf=self;
    [body runAction:moveDown completion:^{
        [wkSelf removeFromParent ];
        complete();
    }];
}
-(SKSpriteNode *)bodyNode{
    SKTexture *bodyTexture = [SKTexture textureWithImageNamed:@"panel-virgin"];
    SKSpriteNode *body = [SKSpriteNode spriteNodeWithTexture:bodyTexture ];
    body.name = @"body";
    return body;
}

-(SKSpriteNode *)buttonNodeWithText:(NSString *)text{
    SKTexture *btnNodeTexture = [SKTexture textureWithImageNamed:@"button-enpty"];
    SKSpriteNode *btnNode = [SKSpriteNode spriteNodeWithTexture:btnNodeTexture];
    
    btnNode.name = @"text";
    SKLabelNode *label = [SKLabelNode labelNodeWithText:text];
    label.fontName = @"changchengteyuanti";
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.name = [NSString stringWithFormat:@"ALERT_%@",text];
    label.fontSize = 20;
    [btnNode addChild:label];
    return btnNode;
}
@end
