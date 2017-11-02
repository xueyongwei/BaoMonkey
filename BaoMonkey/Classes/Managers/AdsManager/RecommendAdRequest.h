//
//  RecommendAdRequest.h
//  BaoMonkey
//
//  Created by xueyognwei on 2017/10/10.
//  Copyright © 2017年 BaoMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,Url_actionStyle) {
    Url_actionStyleH5_inner,
    Url_actionStyleSystem_action,
    Url_actionStyleLocalImage,
};

@interface RecommendAdModel : NSObject

@property (nonatomic,copy) NSString *title;//这里是标题
@property (nonatomic,copy) NSString *icon;//应用图标URL
@property (nonatomic,copy) NSString *banner;//图片URL
@property (nonatomic,copy) NSString *desc;//app的描述
@property (nonatomic,copy) NSString *url;//跳转商店的URL地址
@property (nonatomic,copy) NSString *scheme;//判断是否已经安装
@property (nonatomic,assign) Url_actionStyle url_action;//URL对应的操作 1=h5_inner, 2=system_action
@end


@interface RecommendAdRequest : NSObject


/**
 单例

 @return 广告请求
 */
+(instancetype)request;


/**
 预加载广告
 */
-(void)preloadRecommondAd;


/**
 获取一个广告数据

 @param Placement 广告位（仅作标识）
 @return 广告数据
 */
-(RecommendAdModel *)recommendADModelWithPlacement:(NSString *)Placement;

@end
