//
//  DSAvatarImageView.h
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSChatKitDependency.h"

@class DSMessage;

@interface DSAvatarImageView : UIControl
//图片
@property (nonatomic, strong) UIImage *image;
//是否要剪切
@property (nonatomic, assign) BOOL clipPath;

//通过消息设置头像
- (void)setAvatarByMessage:(DSMessage *)message;


@end


//sd没有合适的方法直接设置 所以自己按sd的代码实现
@interface DSAvatarImageView (SDWebImageCahe)

- (void)ds_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)ds_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock;

@end
