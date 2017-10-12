//
//  UIImage+DSCategory.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/12.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "UIImage+DSCategory.h"

@implementation UIImage (DSCategory)

+ (UIImage *)ds_fetchBundleImage:(NSString *)imageNameOrPath bundleName:(NSString *)bundleName {
    NSString *name = [bundleName stringByAppendingPathComponent:imageNameOrPath];
    UIImage *image = [UIImage imageNamed:name];
    if (!image) [UIImage imageWithContentsOfFile:imageNameOrPath];
    return image;
}
@end
