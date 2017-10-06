//
//  DSPageView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/6.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSPageView.h"

@implementation DSPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
    }
}
@end
