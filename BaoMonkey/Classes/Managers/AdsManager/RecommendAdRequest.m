//
//  RecommendAdRequest.m
//  BaoMonkey
//
//  Created by xueyognwei on 2017/10/10.
//  Copyright © 2017年 BaoMonkey. All rights reserved.
//

#import "RecommendAdRequest.h"
#import <AFNetworking.h>
#import <YYKit.h>
#import <AdSupport/AdSupport.h>
#import "AFHTTPSessionManager+SharedManager.h"
#import <sys/utsname.h>

#pragma mark -- RecommendAdModel

@implementation RecommendAdModel

@end

#pragma mark -- RecommendAdRequest
@interface RecommendAdRequest ()
@property (nonatomic,strong) NSMutableArray  <RecommendAdModel *> *adModels;
@property (nonatomic,strong) NSMutableDictionary *markedByPlacementAdsDic;
@property (nonatomic,assign) NSInteger adCurrentIndex;
@end


@implementation RecommendAdRequest
+(instancetype)request
{
    static RecommendAdRequest *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[RecommendAdRequest alloc]init];
        
    });
    return request;
}


/**
 预加载广告
 */
-(void)preloadRecommondAd
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *bundle_id = [UIApplication sharedApplication].appBundleID;
        NSString *version = [UIApplication sharedApplication].appVersion;
        NSString *uid = @"";
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }else{
            uid = [[NSUUID UUID] UUIDString];
        }
        
        NSString *network = [self newWorkString];
        NSString *os_version = [NSString stringWithFormat:@"%.1f",[UIDevice systemVersion]];
        NSString *model = [self iphoneType];
        NSString *sign = [NSString stringWithFormat:@"bundle_id=%@&model=%@&network=%@&os_version=%@&uid=%@&version=%@%@",bundle_id,model,network,os_version,uid,version,bundle_id];
        NSString *urlstr = [NSString stringWithFormat:@"https://api.tools.superlabs.info/ad/v1.0/ios/native_ads?bundle_id=%@&model=%@&network=%@&os_version=%@&uid=%@&version=%@&sign=%@",bundle_id,model,network,os_version,uid,version,sign.md5String.uppercaseString];
        
        [[AFHTTPSessionManager sharedManager] GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (![responseObject isKindOfClass:[NSArray class]]) {
                
                return ;
            }
            NSArray *result = (NSArray *)responseObject;
            NSLog(@"推荐广告请求成功 %@",result);
            
            
            if (result.count>0) {
                
                self.adModels = [[NSMutableArray alloc]init];
                self.markedByPlacementAdsDic = [[NSMutableDictionary alloc]init];
                
                for (NSDictionary *dic in result) {
                    RecommendAdModel *model = [RecommendAdModel modelWithDictionary:dic];
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[model.scheme stringByAppendingString:@"://"]]]) {
                        NSLog(@"%@ 已安装！",model.scheme);
                    }else{
                        [self.adModels addObject:model];
                    }
                }
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"推荐广告请求失败");
        }];
        
    });
}

/**
 获取一个广告数据
 
 @param Placement 广告位（仅作标识）
 @return 广告数据
 */
-(RecommendAdModel *)recommendADModelWithPlacement:(NSString *)Placement{
    RecommendAdModel *adModel = [self.markedByPlacementAdsDic objectForKey:Placement];
    if (adModel) {
        return adModel;
    }
    if (self.adModels.count>0) {
        if (self.adCurrentIndex>self.adModels.count-1) {
            self.adCurrentIndex = 0;
        }
        adModel = self.adModels[self.adCurrentIndex];
        self.adCurrentIndex ++;
        [self.markedByPlacementAdsDic setObject:adModel forKey:Placement];
        return adModel;
    }
    return nil;
}


-(NSString *)newWorkString{
    AFNetworkReachabilityStatus networkState = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (networkState) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"4G";
            break;
        default:
            return @"unknown";
            break;
    }
    
}
- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

@end
