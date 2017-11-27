//
//  DSAvatarImageView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSAvatarImageView.h"
#import "UIView+DSCategory.h"
#import "DSMessage.h"
#import "DSChatKit.h"
#import "objc/runtime.h"


static char imageURLKey;


@implementation DSAvatarImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.geometryFlipped = YES;
        self.clipPath = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        [self setNeedsDisplay];
    }
}


#pragma mark -- drawRect

- (void)drawRect:(CGRect)rect {
    if (!self.width || !self.height) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将图片旋转过来
    CGContextTranslateCTM(context, 0, self.height);
    CGContextScaleCTM(context, 1, -1);
    //这里 在会话中就不做圆角处理
    if (_clipPath) {
        CGContextAddPath(context, [self path]);
        CGContextClip(context);
    }
    UIImage *image = _image;
    if (image && image.size.height && image.size.width) {
        
        CGPoint center = CGPointMake(self.width * .5f, self.height * .5f);
        //哪个小按哪个缩
        CGFloat scaleW = image.size.width / self.width;
        CGFloat scaleH = image.size.height / self.height;
        CGFloat scale = scaleW < scaleH ? scaleW : scaleH;
        CGSize size = CGSizeMake(image.size.width / scale, image.size.height / scale);
        //这里会将比较长的一个方向 裁掉两边
        CGRect drawRect = CGRectMake(center.x - size.width / 2, center.y - size.height / 2, size.width, size.height);
        
        CGContextDrawImage(context, drawRect, image.CGImage);
    }
}

//最近列表里的头像需要一点圆角
- (CGPathRef)path {
    return [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CGRectGetWidth(self.bounds) / 2] CGPath];
}

- (void)setAvatarByMessage:(DSMessage *)message {
    
    DSChatKitInfoFetchOption *option = [[DSChatKitInfoFetchOption alloc] init];
    option.message = message;
    NSString *from = message.from;
    DSChatKitInfo *info = [[DSChatKit shareKit] infoByUser:from option:option];
    NSURL *url = info.avatarUrlString ? [NSURL URLWithString:info.avatarUrlString] : nil;
    [self ds_setImageWithURL:url placeholderImage:info.avatarImage];
    
}

@end

@implementation DSAvatarImageView (SDWebImageCache)

- (void)ds_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self ds_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)ds_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {
    NSString *validOperationKey = NSStringFromClass([self class]);
    [self sd_cancelImageLoadOperationWithKey:validOperationKey];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            [self ds_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:nil];
        });
    }
    
    if (url) {
        // check if activityView is enabled or not
        if ([self sd_showActivityIndicatorView]) {
            [self sd_addActivityIndicator];
        }
        
        __weak __typeof(self)wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong __typeof (wself) sself = wself;
            [sself sd_removeActivityIndicator];
            if (!sself) {
                return;
            }
            dispatch_main_async_safe(^{
                if (!sself) {
                    return;
                }
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock) {
                    completedBlock(image, error, cacheType, url);
                    return;
                } else if (image) {
                    [sself ds_setImage:image imageData:data basedOnClassOrViaCustomSetImageBlock:nil];
                    [sself ds_setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        [sself ds_setImage:placeholder imageData:nil basedOnClassOrViaCustomSetImageBlock:nil];
                        [sself ds_setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:validOperationKey];
    } else {
        dispatch_main_async_safe(^{
            [self sd_removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
    

}


- (void)ds_setImage:(UIImage *)image imageData:(NSData *)imageData basedOnClassOrViaCustomSetImageBlock:(SDSetImageBlock)setImageBlock {
    if (setImageBlock) {
        setImageBlock(image, imageData);
        return;
    }
    self.image = image;
}

- (void)ds_setNeedsLayout {
    [self setNeedsLayout];
}
@end
