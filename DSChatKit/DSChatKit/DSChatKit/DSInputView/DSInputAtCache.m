//
//  DSInputAtCache.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputAtCache.h"




@interface DSInputAtCache ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation DSInputAtCache


- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}


- (NSArray *)allAtUid:(NSString *)sendText {
    NSArray *names = [self matchString:sendText];
    NSMutableArray *uids = [[NSMutableArray alloc] init];
    for (NSString *name in names) {
        DSInputAtItem *item = [self item:name];
        if (item) {
            [uids addObject:item.uid];
        }
    }
    return [NSArray arrayWithObject:uids];
}

- (void)clean {
    [self.items removeAllObjects];
}

- (void)addAtItem:(DSInputAtItem *)item {
    [_items addObject:item];
}

- (DSInputAtItem *)item:(NSString *)name {
    __block DSInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DSInputAtItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    return item;
}

- (DSInputAtItem *)removeName:(NSString *)name {
    __block DSInputAtItem *item;
    [_items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DSInputAtItem *object = obj;
        if ([object.name isEqualToString:name]) {
            item = object;
            *stop = YES;
        }
    }];
    if (item) {
        [_items removeObject:item];
    }
    return item;
}

//匹配字符串
- (NSArray *)matchString:(NSString *)sendText {
    NSString *pattern = [NSString stringWithFormat:@"%@([^%@]+%@)",DSInputAtStartChar,DSInputAtEndChar,DSInputAtEndChar];
    NSError *error = nil;
    //不区分 大小写 NSRegularExpressionCaseInsensitive
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern  options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *results = [regular matchesInString:sendText options:0 range:NSMakeRange(0, sendText.length)];
    NSMutableArray *matchs = [[NSMutableArray alloc] init];
    
    
    for (NSTextCheckingResult *result in results) {
        NSString *name = [sendText substringWithRange:result.range];
        name = [name substringFromIndex:1];//去掉@
        name = [name substringToIndex:name.length - 1];//去掉 空格
        [matchs addObject:name];
    }
    return matchs;
}
@end
