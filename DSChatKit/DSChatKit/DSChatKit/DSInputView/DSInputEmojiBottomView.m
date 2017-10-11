//
//  DSInputEmojiBottomView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiBottomView.h"
#import "UIView+DSCategory.h"
#import "DSInputEmojiManager.h"

const NSInteger DSInputEmojiBottomViewHieght = 35; //高度
const NSInteger DSInputEmojiSendButtonWidth  = 40; //发送按钮高度
const NSInteger DSInpitEmojiAddButtonWidth   = 35; //添加按钮宽度

const CGFloat separatedLineWidth = .5f; //分隔线宽度

@interface DSInputEmojiBottomView ()
//目录按钮
@property (nonatomic, strong) NSMutableArray *caltalogs;
//分割线
@property (nonatomic, strong) NSMutableArray *separatedLines;

@end

@implementation DSInputEmojiBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _caltalogs = [NSMutableArray array];
        _separatedLines = [NSMutableArray array];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _sendButton.backgroundColor = [UIColor blueColor];
        _sendButton.width = DSInputEmojiSendButtonWidth;
        _sendButton.height = DSInputEmojiBottomViewHieght;
        [self addSubview:_sendButton];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _addButton.width = DSInpitEmojiAddButtonWidth;
        _addButton.height = DSInputEmojiBottomViewHieght;
        [self addSubview:_addButton];
        
        _catalogsView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _catalogsView.showsVerticalScrollIndicator = NO;
        _catalogsView.showsHorizontalScrollIndicator = NO;
        _catalogsView.scrollsToTop = NO;
        [self addSubview:_catalogsView];
        
    }
    return self;
}


- (void)loadCatalogs:(NSArray *)emojiCatalogs {
    for (UIView *subView in [_caltalogs arrayByAddingObjectsFromArray:_separatedLines]) {
        [subView removeFromSuperview];
    }
    [_caltalogs removeAllObjects];
    [_separatedLines removeAllObjects];
    
    for (DSInputEmojiCatalogs *catelogs in emojiCatalogs) {
        
    }
}
@end
