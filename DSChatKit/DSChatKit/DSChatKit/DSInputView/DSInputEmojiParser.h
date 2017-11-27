//
//  DSInputEmojiParser.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSInputEmojiManager.h"

typedef NS_ENUM(NSInteger, DSInputTokenType) {
    DSInputTokenTypeText,       //文本
    DSInputTokenTypeEmoji,      //表情
};


@interface DSInputTextToken : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) DSInputTokenType type;

@end

@interface DSInputEmojiParser : NSObject

+ (instancetype)currentParser;
- (NSArray *)tokens:(NSString *)text;

@end
