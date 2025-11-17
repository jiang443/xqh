//
//  IMUtil.h
//  AfterDoctor
//
//  Created by jiang on 2018/9/5.
//  Copyright © 2018年 jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMHeaders.h"

@interface IMUtil : NSObject

+ (BOOL)canMessageBeRevoked:(NIMMessage *)message;
+ (NSString *)tipOnMessageRevoked:(NIMRevokeMessageNotification *)notificaton;

@end
