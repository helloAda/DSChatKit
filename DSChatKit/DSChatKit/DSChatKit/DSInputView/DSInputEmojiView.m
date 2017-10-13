//
//  DSInputEmojiView.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/10/11.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSInputEmojiView.h"
#import "UIView+DSCategory.h"
#import "DSInputEmojiButton.h"
#import "UIImage+DSCategory.h"
#import "DSChatKit.h"

const NSInteger DSPageViewHeight = 159;
const NSInteger EmojiPageControlHeight = 36;

@interface DSInputEmojiView ()<DSPageViewDelegate,DSPageViewDataSource,DSInputEmojiBottomViewDelegate,DSEmojiButtonDelegate>

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


//返回page页 表情view
- (UIView *)emojiPageView:(DSPageView *)pageView inEmojiCatalog:(DSInputEmojiCatalog *)emoji page:(NSInteger)page {
    
    UIView *subView = [[UIView alloc] init];
    //表情布局
    CGFloat imageHeight = emoji.layout.imageHeight;
    CGFloat imageWidth = emoji.layout.imageWidth;
    CGFloat originX = (emoji.layout.emojiWidth - imageWidth) / 2 + EmojiMargin;
    CGFloat originY = (emoji.layout.emojiHeight - imageHeight) / 2 + EmojiMarginTop;
    
    int coloumnIndex = 0;
    int rowIndex = 0;
    int indexInPage = 0;
    
    NSInteger begin = page * emoji.layout.itemCountInPage;
    NSInteger end = begin + emoji.layout.itemCountInPage;
    end = end > emoji.emojis.count ? emoji.emojis.count : end;
    
    for (NSInteger index = begin; index < end; index ++) {
        DSInputEmoji *data = [emoji.emojis objectAtIndex:index];
        
        DSInputEmojiButton *btn = [DSInputEmojiButton emojiButtonWithData:data catalogID:emoji.catalogID delegate:self];
        rowIndex = indexInPage / emoji.layout.columes;
        coloumnIndex = indexInPage % emoji.layout.columes;
        CGFloat x = coloumnIndex * emoji.layout.emojiWidth + originX;
        CGFloat y = rowIndex *emoji.layout.emojiHeight + originY;
        btn.frame = CGRectMake(x, y, imageWidth, imageHeight);
        [subView addSubview:btn];
        indexInPage++;
     }
    //如果刚好一排排完了 删除键要从第二行开始
    if (coloumnIndex == emoji.layout.columes - 1) {
        rowIndex = rowIndex + 1;
        coloumnIndex = -1;
    }
    if ([emoji.catalogID isEqualToString:EmojiCatalog]) {
        [self addDeleteEmojiButtonToView:subView coloumnIndex:coloumnIndex rowIndex:rowIndex originX:originX originY:originY imageWidth:imageWidth imageHeight:imageHeight inEmojiCatalog:emoji];
    }
    return subView;
}

//添加删除键
- (void)addDeleteEmojiButtonToView:(UIView *)view
                      coloumnIndex:(NSInteger)coloumnIndex
                          rowIndex:(NSInteger)rowIndex
                           originX:(CGFloat)originX
                           originY:(CGFloat)originY
                        imageWidth:(CGFloat)imageWidth
                       imageHeight:(CGFloat)imageHeight
                    inEmojiCatalog:(DSInputEmojiCatalog *)emojiCatalog {
    DSInputEmojiButton *delete = [[DSInputEmojiButton alloc] init];
    delete.delegate = self;
    delete.userInteractionEnabled = YES;
    delete.exclusiveTouch = YES;
    delete.contentMode = UIViewContentModeCenter;
    NSString *normalName = [EmojiPath stringByAppendingPathComponent:@"emoji_del_normal"];
    NSString *highlightName = [EmojiPath stringByAppendingPathComponent:@"emoji_del_pressed"];
    
    [delete setImage:[UIImage ds_fetchBundleImage:normalName bundleName:[DSChatKit shareKit].emojiBundleName] forState:UIControlStateNormal];
    [delete setImage:[UIImage ds_fetchBundleImage:highlightName bundleName:[DSChatKit shareKit].emojiBundleName] forState:UIControlStateHighlighted];
    [delete addTarget:delete action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat x = (coloumnIndex + 1) * emojiCatalog.layout.emojiWidth + originX;
    CGFloat y = rowIndex * emojiCatalog.layout.emojiHeight + originY;
    delete.frame = CGRectMake(x, y, imageWidth, imageHeight);
    [view addSubview:delete];
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

//所有添加的表情包数据
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

//这组表情需要多少页显示
- (NSInteger)numberOfPagesWithEmoji:(DSInputEmojiCatalog *)emojiCatalog {
    if (emojiCatalog.emojis.count % emojiCatalog.layout.itemCountInPage == 0) {
        return emojiCatalog.emojis.count / emojiCatalog.layout.itemCountInPage;
    }
    else
    {
        return emojiCatalog.emojis.count / emojiCatalog.layout.itemCountInPage + 1;
    }
}

//找到某组表情的起始位置
- (NSInteger)pageIndexWithEmoji:(DSInputEmojiCatalog *)emojiCatalog {
    NSInteger pageIndex = 0;
    for (DSInputEmojiCatalog *catalog in self.totalCatalogData) {
        if (emojiCatalog == catalog) {
            break;
        }
        pageIndex += catalog.pagesCount;
    }
    return pageIndex;
}

//当前这组表情中的第几页
- (NSInteger)pageIndexWithTotalIndex:(NSInteger)index {
    DSInputEmojiCatalog *catalog = [self emojiWithIndex:index];
    NSInteger begin = [self pageIndexWithEmoji:catalog];
    return index - begin;
}

//找到当前要显示的那一页的数据
- (DSInputEmojiCatalog *)emojiWithIndex:(NSInteger)index {
    NSInteger page  = 0;
    DSInputEmojiCatalog *emoji;
    for (emoji in self.totalCatalogData) {
        NSInteger newPage = page + emoji.pagesCount;
        if (newPage > index) break;
        page   = newPage;
    }
    return emoji;
    
}

//所有表情
- (NSArray *)allEmoji {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (DSInputEmojiCatalog *catalog in self.totalCatalogData) {
        [array addObjectsFromArray:catalog.emojis];
    }
    return array;
}

#pragma mark -- DSPageViewDataSource

- (NSInteger)numberOfPages:(DSPageView *)pageView {
    return [self sumPages];
}

- (UIView *)pageView:(DSPageView *)pageView viewInPage:(NSInteger)index {
    NSInteger page = 0;
    DSInputEmojiCatalog *emojiCatalog;
    //找到当前要显示的是那页的数据
    for (emojiCatalog in self.totalCatalogData) {
        NSInteger newPage = page + emojiCatalog.pagesCount;
        if (newPage > index) break;
        page = newPage;
    }
    return [self emojiPageView:pageView inEmojiCatalog:emojiCatalog page:index - page];
    
}


#pragma mark -- DSPageViewDelegate

- (void)pageViewScrollEnd:(DSPageView *)page currentIndex:(NSInteger)index totolPage:(NSInteger)pages {
    DSInputEmojiCatalog *emojiCatalog = [self emojiWithIndex:index];
    self.emojiPageControl.numberOfPages = emojiCatalog.pagesCount;
    self.emojiPageControl.currentPage = [self pageIndexWithTotalIndex:index];
    NSInteger selectBottomIndex = [self.totalCatalogData indexOfObject:emojiCatalog];
    [self.bottomView selectIndex:selectBottomIndex];
}

#pragma mark -- DSInputEmojiBottomViewDelegate

- (void)bottomView:(DSInputEmojiBottomView *)bottomView didSelectBottomIndex:(NSInteger)index {
    self.currentCatalogData = self.totalCatalogData[index];
}


#pragma mark -- add send Click and DSInputEmojiButtonDelegate

- (void)didSelectSend:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSend:)]) {
        [self.delegate didSelectedSend:btn];
    }
}

- (void)didSelectedAdd:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAdd:)]) {
        [self.delegate didSelectedAdd:btn];
    }
}

- (void)selectedEmoji:(DSInputEmoji *)emoji catalogID:(NSString *)catalogID {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedEmoji:catalogID:)]) {
        [self.delegate selectEmoji:emoji.emojiID catalog:catalogID description:emoji.tag];
    }
}

#pragma mark -- set

- (void)setCurrentCatalogData:(DSInputEmojiCatalog *)currentCatalogData {
    _currentCatalogData = currentCatalogData;
    [self.emojiPageView scrollToPage:[self pageIndexWithEmoji:_currentCatalogData]];
}

- (void)setTotalCatalogData:(NSArray *)totalCatalogData {
    _totalCatalogData = totalCatalogData;
    [self.bottomView loadCatalogs:_totalCatalogData];
}



#pragma mark -- get

- (DSInputEmojiBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[DSInputEmojiBottomView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bottomView.delegate = self;
        [_bottomView.sendButton addTarget:self action:@selector(didSelectSend:) forControlEvents:UIControlEventTouchUpInside];
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
