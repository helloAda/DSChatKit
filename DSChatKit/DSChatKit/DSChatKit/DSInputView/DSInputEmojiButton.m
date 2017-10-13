//
//  DSInputEmojiButton.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/13.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiButton.h"
#import "UIImage+DSCategory.h"
#import "DSChatKit.h"

@implementation DSInputEmojiButton

+ (DSInputEmojiButton *)emojiButtonWithData:(DSInputEmoji *)data catalogID:(NSString *)catalogID delegate:(id<DSEmojiButtonDelegate>)delegate {
    DSInputEmojiButton *btn = [[DSInputEmojiButton alloc] init];
    [btn addTarget:btn action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage ds_fetchBundleImage:data.fileName bundleName:[DSChatKit shareKit].emojiBundleName];
    
    btn.emojiData = data;
    btn.catalogID = catalogID;
    btn.userInteractionEnabled = YES;
    btn.exclusiveTouch = YES;
    btn.contentMode = UIViewContentModeScaleToFill;
    btn.delegate = delegate;
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

- (void)buttonClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedEmoji:catalogID:)]) {
        [self.delegate selectedEmoji:self.emojiData catalogID:self.catalogID];
    }
}

@end
