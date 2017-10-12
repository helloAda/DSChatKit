//
//  UIImage+DSCategory.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/12.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DSCategory)


//从bundle资源中获取图片
+ (UIImage *)ds_fetchBundleImage:(NSString *)imageNameOrPath bundleName:(NSString *)bundleName;

@end
