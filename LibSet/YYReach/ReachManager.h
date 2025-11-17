//
//  ReachManager.h
//  Alamofire
//
//  Created by jiang on 2019/3/30.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ReachStatus) {
    offLine = 0,
    onWiFi,
    onWWAN
};

@interface ReachManager : NSObject

/*!
 * 是否需要检查连接(网络故障)。
 * //TRUE:WWAN可用而未激活，或者WiFi需要VPN设置。
 * //FALSE:网络已关闭或已正常连接。
 */
@property (nonatomic,readonly) BOOL connectionRequired;

@property (nonatomic,copy) void (^listener)(ReachStatus status);

+ (instancetype)sharedInstance;
- (void) start;
- (void) stop;

@end

NS_ASSUME_NONNULL_END
