//
//  DSSessionMsgDataSource.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/23.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionMsgDataSource.h"
#import "DSChatKitMessageProvider.h"
#import "DSMessageModel.h"
#import "DSChatKitMacro.h"

@interface DSSessionMsgDataSource()

//数据提供
@property (nonatomic, strong) id<DSChatKitMessageProvider> dataProvide;

@property (nonatomic, strong) NSMutableDictionary *msgIdDic;

@end

@implementation DSSessionMsgDataSource {
    DSSession *_session; //当前会话
}
- (instancetype)initWithSession:(DSSession *)session config:(id<DSSessionConfig>)sessionConfig {
    self = [super init];
    if (self) {
        _session = session;
        _sessionConfig = sessionConfig;
        _dataProvide = [_sessionConfig respondsToSelector:@selector(messageDataProvider)] ? [_sessionConfig messageDataProvider] : nil;
        if (_sessionConfig.messageLimit <= 0) {
            _messageLimit = 20;
        }else {
           _messageLimit = _sessionConfig.messageLimit;
        }
        if (_sessionConfig.showTimestampInterval <= 0) {
            _showTimeInterval = 300; //5min
        }else {
            _showTimeInterval = _sessionConfig.showTimestampInterval;
        }
        _items = [NSMutableArray array];
        _msgIdDic = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)loadHistoryMessagesWithComplete:(void (^)(NSInteger,
                                                  NSArray *, NSError *))handler {
    
    __block DSMessageModel *currentOldMsg = nil;
    [self.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DSMessageModel class]]) {
            currentOldMsg = (DSMessageModel *)obj;
            *stop = YES;
        }
    }];
    NSInteger index = 0;
    if (self.dataProvide && [self.dataProvide respondsToSelector:@selector(pullDown:handler:)]) {
        __weak typeof(self) wself = self;
        [self.dataProvide pullDown:currentOldMsg.message handler:^(NSError *error, NSArray<DSMessage *> *messages) {
            DS_Dispatch_Async_Main(^{
                NSInteger index = [wself insertMesaages:messages];
            });
        }];
    }
}


- (NSInteger)insertMesaages:(NSArray *)messages {
    NSInteger count = self.items.count;
    for (DSMessage *message in messages.reverseObjectEnumerator.allObjects) {
        [self insertMessage:message];
    }
    NSInteger currentIndex = self.items.count - 1;
    return currentIndex - count;
    
}


#pragma mark - private

- (void)insertMessage:(DSMessage *)message {
    
}
@end
