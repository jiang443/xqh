//
//  IMUtil.m
//  AfterDoctor
//
//  Created by jiang on 2018/9/5.
//  Copyright © 2018年 jiang. All rights reserved.
//

#import "IMUtil.h"
#import <BSChat-Swift.h>

@implementation IMUtil

+ (BOOL)canMessageBeRevoked:(NIMMessage *)message
{
    BOOL canRevokeMessageByRole  = [self canRevokeMessageByRole:message];
    BOOL isDeliverFailed = !message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryStateFailed;
    if (!canRevokeMessageByRole || isDeliverFailed) {
        return NO;
    }
    id<NIMMessageObject> messageObject = message.messageObject;
    if ([messageObject isKindOfClass:[NIMTipObject class]]
        || [messageObject isKindOfClass:[NIMNotificationObject class]]) {
        return NO;
    }
    if ([messageObject isKindOfClass:[NIMCustomObject class]])
    {
        id<IMCustomAttachmentInfo> attach = (id<IMCustomAttachmentInfo>)[(NIMCustomObject *)message.messageObject attachment];
        return [attach canBeRevoked];
    }
    return YES;
}

+ (BOOL)canRevokeMessageByRole:(NIMMessage *)message
{
    BOOL isFromMe  = [message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    BOOL isToMe        = [message.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    BOOL isTeamManager = NO;
    if (message.session.sessionType == NIMSessionTypeTeam)
    {
        NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:[NIMSDK sharedSDK].loginManager.currentAccount inTeam:message.session.sessionId];
        isTeamManager = member.type == NIMTeamMemberTypeOwner || member.type == NIMTeamMemberTypeManager;
    }
    
    BOOL isRobotMessage = NO;
    id<NIMMessageObject> messageObject = message.messageObject;
    if ([messageObject isKindOfClass:[NIMRobotObject class]]) {
        NIMRobotObject *robotObject = (NIMRobotObject *)messageObject;
        isRobotMessage = robotObject.isFromRobot;
    }
    //我发出去的消息并且不是发给我的电脑的消息并且不是机器人的消息，可以撤回
    //群消息里如果我是管理员可以撤回以上所有消息
    return (isFromMe && !isToMe && !isRobotMessage) || isTeamManager;
}


+ (NSString *)tipOnMessageRevoked:(NIMRevokeMessageNotification *)notificaton
{
    NSString *fromUid = nil;
    NIMSession *session = nil;
    NSString *tip = @"";
    BOOL isFromMe = NO;
    if([notificaton isKindOfClass:[NIMRevokeMessageNotification class]])
    {
        fromUid = [notificaton messageFromUserId];
        session = [notificaton session];
        isFromMe = [fromUid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
        
    }
    else if(!notificaton)
    {
        isFromMe = YES;
    }
    else
    {
        assert(0);
    }
    if (isFromMe)
    {
        tip = @"你";
    }
    else{
        switch (session.sessionType) {
            case NIMSessionTypeP2P:
                tip = @"对方";
                break;
            case NIMSessionTypeTeam:{
                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
                NIMTeamMember *member = [[NIMSDK sharedSDK].teamManager teamMember:fromUid inTeam:session.sessionId];
                if ([fromUid isEqualToString:team.owner])
                {
                    tip = @"群主";
                }
                else if(member.type == NIMTeamMemberTypeManager)
                {
                    tip = @"管理员";
                }
                NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
                option.session = session;
                NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:fromUid option:option];
                tip = [tip stringByAppendingString:info.showName];
            }
                break;
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%@撤回了一条消息",tip];
}



@end
