//
//  DSChatKitDependency.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/22.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#ifndef DSChatKitDependency_h
#define DSChatKitDependency_h

#if __has_include(<SDWebImageCompat/SDWebImageCompat.h>)
#import <SDWebImageCompat/SDWebImageCompat.h>
#else
#import "SDWebImageCompat.h"
#endif


#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#else
#import "SDWebImageManager.h"
#import "UIView+WebCacheOperation.h"
#import "uiview+WebCache.h"
#endif

#endif /* DSChatKitDependency_h */
