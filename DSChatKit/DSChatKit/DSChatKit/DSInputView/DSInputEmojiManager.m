//
//  DSInputEmojiManager.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiManager.h"

#define EmojiBundleName @"DSInputEmoji.bundle" //资源所在bundle
#define EmojiPath       @"Emoji"               //在bundle中的文件夹名称

@interface DSInputEmojiManager ()

@property (nonatomic,strong)    NSArray *catalogs;
@end

@implementation DSInputEmojiManager

+ (instancetype)manager {
    static DSInputEmojiManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DSInputEmojiManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self parsePlist];
    }
    return self;
}

//解析emoji表情的 plist文件
- (void)parsePlist {
    
    NSMutableArray *catalogs = [NSMutableArray array];
    NSURL *url = [[NSBundle mainBundle] URLForResource:EmojiBundleName withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *filePath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:EmojiPath];
    if (filePath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dic in array) {
            NSArray *emojis = dic[@"data"];
            NSDictionary *info = dic[@"info"];
            
            DSInputEmojiCatalogs *catalog = [self catalogByInfo:info emojis:emojis];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

//将文件中的表情数据字典 转为DSInputEmojiCatalogs类型
- (DSInputEmojiCatalogs *)catalogByInfo:(NSDictionary *)info emojis:(NSArray *)emojis {
    DSInputEmojiCatalogs *catalogs = [[DSInputEmojiCatalogs alloc] init];
    catalogs.catalogID = info[@"id"];
    catalogs.title     = info[@"title"];
    NSString *prefix = EmojiPath;
    catalogs.icon = [prefix stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",info[@"normal"]]];
    catalogs.iconSelected = [prefix stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",info[@"pressed"]]];
    
    NSMutableDictionary *tagEmojiDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *idEmojiDic = [NSMutableDictionary dictionary];
    NSMutableArray *emojisArray = [NSMutableArray array];
    for (NSDictionary *emojiDic in emojis) {
        DSInputEmoji *emoji = [[DSInputEmoji alloc] init];
        emoji.emojiID = emojiDic[@"id"];
        emoji.tag     = emojiDic[@"tag"];
        emoji.fileName = [prefix stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",emojiDic[@"file"]]];
        
        if (emoji.emojiID) {
            [emojisArray addObject:emoji];
            idEmojiDic[emoji.emojiID] = emoji;
        }
        if (emoji.tag) {
            tagEmojiDic[emoji.tag] = emoji;
        }
    }
    
    catalogs.emojis = emojisArray;
    catalogs.idEmoji = idEmojiDic;
    catalogs.tagEmoji = tagEmojiDic;
    return catalogs;
}
@end
