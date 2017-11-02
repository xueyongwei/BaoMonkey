//
//  Size.m
//  BaoMonkey
//
//  Created by Jeremy Peltier on 22/05/2014.
//  Copyright (c) 2014 BaoMonkey. All rights reserved.
//

#import "BaoSize.h"
#import "Define.h"

@implementation BaoSize

#pragma mark - PLATEFORM

+(CGSize)plateform{
    return IPAD ? CGSizeMake(300, 116) : CGSizeMake(150, 58);
}

#pragma mark - MENU SETTINGS

+(CGSize)cursorSettings{
    
    return CGSizeMake(SCREEN_WIDTH * 0.55, SCREEN_HEIGHT *0.048);
//    return IPAD ? CGSizeMake(330, 41.5f) : CGSizeMake(180, 22.5f);
}

+ (CGFloat) sizeMoveAccelerometer {
    return (IPAD ? 12 : 6);
}
+(CGSize)settingBackBtnSize{
    return CGSizeMake(SCREEN_WIDTH*0.16, SCREEN_WIDTH*0.16);
}
+(CGSize)settingADBtnSize{
    return CGSizeMake(SCREEN_WIDTH*0.18, SCREEN_WIDTH*0.18);
}
@end
