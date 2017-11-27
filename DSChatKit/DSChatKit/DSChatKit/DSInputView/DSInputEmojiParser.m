//
//  DSInputEmojiParser.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/27.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiParser.h"

@implementation DSInputTextToken
@end


@interface DSInputEmojiParser ()

@property (nonatomic, strong) NSCache *tokens;

@end

@implementation DSInputEmojiParser

+ (instancetype)currentParser {
    static DSInputEmojiParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DSInputEmojiParser alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tokens = [[NSCache alloc] init];
    }
    return self;
}


- (NSArray *)tokens:(NSString *)text {
    NSArray *tokens = nil;
    if (text.length) {
        tokens = [_tokens objectForKey:text];
        if (!tokens) {
            tokens = [self parseToken:text];
            [_tokens setObject:tokens forKey:text];
        }
    }
    return tokens;
}

- (NSArray *)parseToken:(NSString *)text {
    NSMutableArray *tokens = [NSMutableArray array];
    static NSRegularExpression *exp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        exp = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    __block NSInteger index = 0;
    [exp enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        //匹配到的字符串
        NSString *rangeText = [text substringWithRange:result.range];
        //如果有对应的表情
        if ([[DSInputEmojiManager manager] emojiByTag:rangeText]) {
            if (result.range.location > index) {
                //这一部分属于文本
                NSString *rawText = [text substringWithRange:NSMakeRange(index, result.range.location - index)];
                
                DSInputTextToken *token = [[DSInputTextToken alloc] init];
                token.type = DSInputTokenTypeText;
                token.text = rawText;
                [tokens addObject:token];
            }
            //rangeText就是对应的表情部分
            DSInputTextToken *token = [[DSInputTextToken alloc] init];
            token.type = DSInputTokenTypeEmoji;
            token.text = rangeText;
            [tokens addObject:token];
            
            //改变下标，下一次查找到的时候才能判断文本范围
            index = result.range.location + result.range.length;
        }
    }];
    
    //后面还有一段文字没有被加入
    if (index < text.length) {
        NSString *rawText = [text substringWithRange:NSMakeRange(index, text.length - index)];
        DSInputTextToken *token = [[DSInputTextToken alloc] init];
        token.type = DSInputTokenTypeText;
        token.text = rawText;
        [tokens addObject:token];
    }
    return tokens;
}
@end
