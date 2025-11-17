//
//  ReachManager.m
//  YYReach
//
//  Created by jiang on 2019/3/30.
//

#import "ReachManager.h"

@interface ReachManager()

@property (nonatomic,strong) Reachability *hostReachability;
@property (nonatomic,strong) Reachability *internetReachability;

@end

@implementation ReachManager

- (instancetype)init
{
    if (self = [super init]) {
        //不要加http
        self.hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        self.internetReachability = [Reachability reachabilityForInternetConnection];;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static ReachManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ReachManager alloc] init];
    });
    return instance;
}

- (void) start{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
////打开一个监听器就够了
//    [self.hostReachability startNotifier];
//    [self statusCheck:self.hostReachability];
    
    [self.internetReachability startNotifier];
    [self statusCheck:self.internetReachability];
}

- (void) stop{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self.hostReachability stopNotifier];
    [self.internetReachability stopNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self statusCheck:curReach];
}

- (void) statusCheck:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    _connectionRequired = [reachability connectionRequired];
    
    switch (netStatus)
    {
        case NotReachable:{
            //NSLog(@"### 网络连接已断开");
            _connectionRequired = NO;
            if (self.listener != nil){
                self.listener(offLine);
            }
            break;
        }
        case ReachableViaWWAN:{
            //NSLog(@"### 已连接蜂窝移动网络");
            if (self.listener != nil){
                self.listener(onWWAN);
            }
            break;
        }
        case ReachableViaWiFi:{
            //NSLog(@"### 已连接WiFi网络");
            if (self.listener != nil){
                self.listener(onWiFi);
            }
            break;
        }
    }
}

- (void)dealloc
{
    [self stop];
}


@end
