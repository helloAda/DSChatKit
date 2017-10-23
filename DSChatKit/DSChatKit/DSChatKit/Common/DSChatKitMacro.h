//
//  DSChatKitMacro.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/18.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#ifndef DSChatKitMacro_h
#define DSChatKitMacro_h

//rgb颜色
#define DScolorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define DS_Dispatch_Async_Main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif /* DSChatKitMacro_h */
