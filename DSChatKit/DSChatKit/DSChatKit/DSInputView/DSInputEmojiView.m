//
//  DSInputEmojiView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiView.h"
#import "UIView+DSCategory.h"

const NSInteger DSPageViewHeight = 159;
const NSInteger EmojiPageControlHeight = 36;

@interface DSInputEmojiView ()<DSPageViewDelegate,DSPageViewDataSource,DSInputEmojiBottomViewDelegate>

@end

@implementation DSInputEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setConfig:(id<DSSessionConfig>)config {
    _config = config;
    [self setupUI];
    [self reloadData];
}

- (void)setupUI {
    _emojiPageView  = [[DSPageView alloc] initWithFrame:self.bounds];
    _emojiPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _emojiPageView.height = DSPageViewHeight;
    _emojiPageView.backgroundColor = [UIColor clearColor];
    _emojiPageView.dataSource = self;
    _emojiPageView.delegate = self;
    [self addSubview:_emojiPageView];
    
    _emojiPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.width, EmojiPageControlHeight)];
    _emojiPageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _emojiPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _emojiPageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _emojiPageControl.userInteractionEnabled = NO;
    [self addSubview:_emojiPageControl];
    
}

- (void)setFrame:(CGRect)frame {
    CGFloat originalWidth = self.width;
    [super setFrame:frame];
    if (originalWidth != frame.size.width) {
        [self reloadData];
    }
}

//刷新数据
- (void)reloadData {
    NSArray *catalogs = [self loadEmojiAndEmoticons];
    self.totalCatalogData = catalogs;
    self.currentCatalogData = catalogs.firstObject;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.emojiPageControl.top = self.emojiPageView.bottom - 10;
    self.emojiPageView.bottom = self.height;
}



#pragma mark ---- 处理数据

//所有表情的页数
- (NSInteger)sumPages {
    __block NSInteger pagesCount = 0;
    [self.totalCatalogData enumerateObjectsUsingBlock:^(DSInputEmojiCatalog *catalog, NSUInteger idx, BOOL * _Nonnull stop) {
        pagesCount += catalog.pagesCount;
    }];
    return pagesCount;
}


- (UIView *)emojiPageView:(DSPageView *)pageView inEmojiCatalog:(DSInputEmojiCatalog *)emoji page:(NSInteger)page {
    UIView *subView = [[UIView alloc] init];
    
}

//加载emoji表情 和 自己添加的表情包
- (NSArray *)loadEmojiAndEmoticons {
    
    DSInputEmojiCatalog *emojiCatalog = [self loadEmojiCatalog];
    NSArray *emoticons = [self loadEmoticons];
    NSArray *catalogs = emojiCatalog ? [@[emojiCatalog] arrayByAddingObjectsFromArray:emoticons] : emoticons;
    return catalogs;
}


//返回表情目录对象
- (DSInputEmojiCatalog *)loadEmojiCatalog {
    DSInputEmojiCatalog *emojiCatalog = [[DSInputEmojiManager manager] emojiCatalog:EmojiCatalog];
    if (emojiCatalog) {
        DSInputEmojiLayout *layout = [[DSInputEmojiLayout alloc] initEmojiLayout:self.width];
        emojiCatalog.layout = layout;
        emojiCatalog.pagesCount = [self numberOfPagesWithEmoji:emojiCatalog];
    }
    return emojiCatalog;
}

//所有表情包数据
- (NSArray *)loadEmoticons {
    NSArray *emoticons = nil;
    if (self.config && [self.config respondsToSelector:@selector(emoticons)]) {
        emoticons = [self.config emoticons];
        for (DSInputEmojiCatalog *emoticonCatalog in emoticons) {
            DSInputEmojiLayout *layout = [[DSInputEmojiLayout alloc] initEmoticonLayout:self.width];
            emoticonCatalog.layout = layout;
            emoticonCatalog.pagesCount = [self numberOfPagesWithEmoji:emoticonCatalog];
        }
    }
    return emoticons;
}

//表情需要多少页显示
- (NSInteger)numberOfPagesWithEmoji:(DSInputEmojiCatalog *)emojiCatalog {
    if (emojiCatalog.emojis.count % emojiCatalog.layout.itemCountInPage == 0) {
        return emojiCatalog.emojis.count / emojiCatalog.layout.itemCountInPage;
    }
    else
    {
        return emojiCatalog.emojis.count / emojiCatalog.layout.itemCountInPage + 1;
    }
}


#pragma mark -- get

- (DSInputEmojiBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[DSInputEmojiBottomView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bottomView.delegate = self;
        [_bottomView.sendButton addTarget:self action:@selector(didSelectedSend:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.addButton addTarget:self action:@selector(didSelectAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomView];
        
        if (_currentCatalogData.pagesCount > 0) {
            _emojiPageControl.numberOfPages = _currentCatalogData.pagesCount;
            _emojiPageControl.currentPage = 0;
        }
    }
    return _bottomView;
}
@end
