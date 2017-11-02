//
//  RewardVideoManager.h
//  Jump
//
//  Created by xueyognwei on 2017/10/9.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UnityAds/UnityAds.h>
@interface RewardVideoManager : NSObject <UnityAdsDelegate>
@property (nonatomic,assign) BOOL isADRemoved;
+(instancetype)defaultManager;
-(void)setUpManager;
-(void)removeAD;
-(void)showRewardVideoInViewController:(UIViewController *)viewController Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock;

-(void)showRewardVideoInViewController:(UIViewController *)viewController canSkip:(BOOL)canSkip Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock;
-(void)showUnitsAD:(UIViewController *)viewController finished:(void(^)(UnityAdsFinishState state))finishBlock;
@end
