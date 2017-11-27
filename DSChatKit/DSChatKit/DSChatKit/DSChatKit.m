//
//  DSChatKit.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/12.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSChatKit.h"

@implementation DSChatKit

+ (instancetype)shareKit {
    static DSChatKit *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DSChatKit alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _emojiBundleName = @"DSInputEmoji.bundle";
    }
    return self;
}


//- (DSChatKitInfo *)infoByUser:(NSString *)userId option:(DSChatKitInfoFetchOption *)option {
//
//}
@end
