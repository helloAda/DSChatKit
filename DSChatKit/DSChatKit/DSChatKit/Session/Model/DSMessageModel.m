//
//  DSMessageModel.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSMessageModel.h"

@interface DSMessageModel ()

@end

@implementation DSMessageModel

- (instancetype)initWithMessage:(DSMessage *)message {
    self = [super init];
    if (self) {
        _message = message;
        _messageTime = message.timestamp;
    }
    return self;
}

@end
