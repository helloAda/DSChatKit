//
//  DSInputEmojiManager.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiManager.h"
#import "DSChatKit.h"


@implementation DSInputEmojiLayout

- (instancetype)initEmojiLayout:(CGFloat)width {
    self = [super init];
    if (self) {
        _rows = EmojiRow;
        _columes = (width - EmojiMargin * 2) / EmojiImageWidth;
        _itemCountInPage = _rows * _columes - 1; //减一个删除键
        _emojiWidth = (width - EmojiMargin * 2) / _columes;
        _emojiHeight = EmojiHeight;
        _imageWidth = EmojiImageWidth;
        _imageHeight = EmojiImageHeight;
        _emoji = YES;
    }
    return self;
}

- (instancetype)initEmoticonLayout:(CGFloat)width {
    self = [super init];
    if (self) {
        _rows = EmoticonRow;
        _columes = (width - EmojiMargin * 2) / EmoticonImageWidth;
        _itemCountInPage = _rows * _columes;
        _emojiWidth = (width - EmojiMargin * 2) / _columes;
        _emojiHeight = EmoticonHeight;
        _emojiWidth = EmoticonImageWidth;
        _emojiHeight = EmoticonImageHeight;
        _emoji = NO;
    }
    return self;
}
@end

@interface DSInputEmojiManager ()

@property (nonatomic,strong) NSArray *catalogs;

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
    NSURL *url = [[NSBundle mainBundle] URLForResource:[DSChatKit shareKit].emojiBundleName withExtension:nil];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    NSString *filePath = [bundle pathForResource:@"emoji" ofType:@"plist" inDirectory:EmojiPath];
    if (filePath) {
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dic in array) {
            NSArray *emojis = dic[@"data"];
            NSDictionary *info = dic[@"info"];
            
            DSInputEmojiCatalog *catalog = [self catalogByInfo:info emojis:emojis];
            [catalogs addObject:catalog];
        }
    }
    _catalogs = catalogs;
}

//将文件中的表情数据字典 转为DSInputEmojiCatalog类型
- (DSInputEmojiCatalog *)catalogByInfo:(NSDictionary *)info emojis:(NSArray *)emojis {
    DSInputEmojiCatalog *catalogs = [[DSInputEmojiCatalog alloc] init];
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


- (DSInputEmojiCatalog *)emojiCatalog:(NSString *)catalogID {
    for (DSInputEmojiCatalog *catalog in _catalogs) {
        if ([catalog.catalogID isEqualToString:catalogID]) {
            return catalog;
        }
    }
    return nil;
}

@end
