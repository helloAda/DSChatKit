//
//  DSSession.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/19.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSession.h"

@interface DSSession ()

@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, assign) DSSessionType type;

@end

@implementation DSSession

+ (instancetype)session:(NSString *)sessionID type:(DSSessionType)type {
    DSSession *session = [[DSSession alloc] init];
    session.sessionid = sessionID;
    session.type = type;
    return session;
}

- (NSString *)sessionID {
    return self.sessionid;
}

- (DSSessionType)sessionType {
    return self.type;
}

@end
