//
//  DSSessionTimestampCell.m
//  DSChatKit
//
//  Created by 黄铭达 on 2017/11/17.
//  Copyright © 2017年 黄铭达. All rights reserved.
//

#import "DSSessionTimestampCell.h"
#import "DSChatKitMacro.h"
#import "DSChatKitUtil.h"
#import "UIView+DSCategory.h"

@interface DSSessionTimestampCell ()

@property (nonatomic, strong) DSTimestampModel *model;

@end

@implementation DSSessionTimestampCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = DSColorFromRGB(0xe4e7ec);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_timeBGView];
        _timeLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLable.font = [UIFont boldSystemFontOfSize:10.f];
        _timeLable.textColor = [UIColor whiteColor];
        [self addSubview:_timeLable];
        
        [_timeBGView setImage:[[UIImage imageNamed:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
    }
    return self;
}


- (void)refreshData:(DSTimestampModel *)data {
    self.model = data;
    if ([self.model isKindOfClass:[DSTimestampModel class]]) {
        _timeLable.text = [DSChatKitUtil showTime:data.messageTime showDetail:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_timeLable sizeToFit];
    _timeLable.center = CGPointMake(self.centerX, 20);
    _timeBGView.frame = CGRectMake(_timeLable.left - 7, _timeLable.top - 2, _timeLable.width + 14, _timeLable.height + 4);
}
@end
