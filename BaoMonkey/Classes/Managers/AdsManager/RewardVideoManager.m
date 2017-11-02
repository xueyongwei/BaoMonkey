//
//  RewardVideoManager.m
//  Jump
//
//  Created by xueyognwei on 2017/10/9.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import "RewardVideoManager.h"
#import "CoreSVP.h"
#import "RecommendViewController.h"
#import <AFNetworking.h>
#import <YYKit.h>
#import "RecommendAdRequest.h"
//#import "GameViewController.h"
@interface RewardVideoManager ()
@property (nonatomic,copy) void(^finishBlock)(UnityAdsFinishState state);
@property (nonatomic,copy) void(^errorBlock)(NSString *message);
@property (nonatomic,assign) NSInteger wannaShowTimes;

@end

@implementation RewardVideoManager
+(instancetype)defaultManager
{
    static RewardVideoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RewardVideoManager alloc]init];
    });
    return manager;
}
-(void)setUpManager{
    self.isADRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"HaveRemovedAD"];
    [UnityAds initialize:@"1570201" delegate:self];
    [[RecommendAdRequest request] preloadRecommondAd];
    self.wannaShowTimes = 0;
//    if (!self.isADRemoved) {
//        [UnityAds initialize:@"1570201" delegate:self];
//        [[RecommendAdRequest request] preloadRecommondAd];
//        self.wannaShowTimes = 0;
//    }
}

-(void)removeAD{
    self.isADRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HaveRemovedAD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

    
-(void)showRewardVideoInViewController:(UIViewController *)viewController Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock{
    if (self.isADRemoved) {
        return;
    }
    self.wannaShowTimes ++;
    if (self.wannaShowTimes<2) {
        return;
    }
    self.wannaShowTimes = 0;
    
    self.errorBlock = errorBlock;
    self.finishBlock = finishBlock;
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [CoreSVP dismiss];
        [self tryShowAdInViewController:viewController placementId:@"rewardedVideo"];
//        [UnityAds show:viewController placementId:@"rewardedVideo"];
    }else{
        [CoreSVP dismiss];
        errorBlock(NSLocalizedString(@"Not ready,Wait a jiff.", nil));
    }
}
-(void)showRewardVideoInViewController:(UIViewController *)viewController canSkip:(BOOL)canSkip Finished:(void(^)(UnityAdsFinishState state))finishBlock error:(void(^)(NSString *message))errorBlock
{
    if (self.isADRemoved) {
        return;
    }
    
    self.wannaShowTimes ++;
    if (self.wannaShowTimes<2) {
        return;
    }
    self.wannaShowTimes = 0;
    
    self.errorBlock = errorBlock;
    self.finishBlock = finishBlock;
    NSString *placementId = canSkip?@"video":@"rewardedVideo";
    if ([UnityAds isReady:@"rewardedVideo"]) {
        [CoreSVP dismiss];
        [self tryShowAdInViewController:viewController placementId:placementId];
//        [UnityAds show:viewController placementId:placementId];
    }else{
        [CoreSVP dismiss];
        errorBlock(NSLocalizedString(@"Not ready,Wait a jiff.", nil));
    }
}
-(void)showUnitsAD:(UIViewController *)viewController finished:(void(^)(UnityAdsFinishState state))finishBlock{
    if([UnityAds isReady:@"rewardedVideo"]){
        self.finishBlock = finishBlock;
        [UnityAds show:viewController placementId:@"rewardedVideo"];
    }else{
        finishBlock(kUnityAdsFinishStateError);
    }
}

-(void)tryShowAdInViewController:(UIViewController *)viewController placementId:placementId;
{
    RecommendAdModel *recommondAd = [[RecommendAdRequest request] recommendADModelWithPlacement:@"gamePause"];
    BOOL sdkADReady = [UnityAds isReady:placementId];
    if (!sdkADReady) {//第三方广告未就绪
        if (recommondAd) {
            [self showRecommondAD:recommondAd inViewController:viewController];
        }else{
            
        }
    }else{//第三方广告有了
        if (recommondAd) {
            NSInteger i = arc4random() % 10;
            if (i<3){//出现自家广告的概率为30%
                [self showRecommondAD:recommondAd inViewController:viewController];
            }else{
               [UnityAds show:viewController placementId:placementId];
            }
        }else{
            [UnityAds show:viewController placementId:placementId];
        }
    }
}

-(void)showRecommondAD:(RecommendAdModel *)recommondAD inViewController:(UIViewController *)viewController{
    RecommendViewController *recomendVC = [[RecommendViewController alloc]initWithNibName:@"RecommendViewController" bundle:nil];
    recomendVC.recommondADModel = recommondAD;
    [viewController presentViewController:recomendVC animated:YES completion:nil];
}
#pragma mark -- unity ADS delegate
- (void)unityAdsReady:(NSString *)placementId{
//    DDLogVerbose(@"unityAdsReady:%@",placementId);
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
//    DDLogError(@"unityAdsDidError :%@",message);
    if (self.errorBlock) {
        self.errorBlock(message);
    }
}

- (void)unityAdsDidStart:(NSString *)placementId{
//    DDLogVerbose(@"unityAdsDidStart:%@",placementId);
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
//    DDLogVerbose(@"unityAdsDidFinish");
    if (self.finishBlock) {
        self.finishBlock(state);
    }
    
}
@end
