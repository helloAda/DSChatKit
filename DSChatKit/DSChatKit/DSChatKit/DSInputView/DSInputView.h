//
//  DSInputView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/9/28.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSInputToolView.h"
#import "DSInputMoreView.h"

@interface DSInputView : UIView

@property (nonatomic, strong) DSInputToolView *toolView;
@property (nonatomic, strong) DSInputMoreView *moreView;


@end
