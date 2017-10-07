//
//  DSMediaItem.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/7.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSMediaItem.h"

@implementation DSMediaItem

+ (DSMediaItem *)item:(NSString *)selector normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    DSMediaItem *item = [[DSMediaItem alloc] init];
    item.selctor = NSSelectorFromString(selector);
    item.normalImage = normalImage;
    item.selectedImage = selectedImage;
    item.title = title;
    return item;
}

@end
