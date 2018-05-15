//
//  DDRatScoresStarsView.m
//  DingDing
//
//  Created by 王万鹏 on 2018/1/11.
//  Copyright © 2018年 ddtech. All rights reserved.
//

#import "WWRatScoresStarsView.h"

@implementation WWRatScoresStarsView

{
    UIImage *_redImage;
    UIImage *_grayImage;
    UIImageView *_partStarImgView;
    NSMutableArray *_starViewArr;
    CGFloat _starHeight;
    CGFloat _star_origin_x;
    
}

- (instancetype)initWithFrame:(CGRect)frame height:(CGFloat)starHeight type:(WWRatScoresStarsType)type {
    if (self = [super initWithFrame:frame]) {
        _starViewArr = [NSMutableArray array];
        _starHeight = starHeight;
        _starsType = type;
    }
    return self;
}

- (void)creatViews {
    if (_partStarImgView) {
        [_partStarImgView removeFromSuperview];
    }
    if (_starViewArr.count > 0) {
        for (UIImageView *imageView in _starViewArr) {
            [imageView removeFromSuperview];
        }
        [_starViewArr removeAllObjects];
    }
    
    NSString *redStr;
    NSString *grayStr;
    if (_starsType == WWRatScoresStarsDefault) {
        self.userInteractionEnabled = NO;
        redStr = @"Star_da";
        grayStr = @"Star_hei";
    }else if (_starsType == WWRatScoresStarsNormalRating) {
        self.userInteractionEnabled = YES;
        redStr = @"Star_da";
        grayStr = @"Star_hei";
    }else if (_starsType == WWRatScoresStarsFloatRating){
        self.userInteractionEnabled = YES;
        redStr = @"Star_da";
        grayStr = @"Star_hei";
    }else if (_starsType == WWRatScoresStarsShow){
        self.userInteractionEnabled = NO;
        redStr = @"Star_da";
        grayStr = @"Star_hei";
    }
    _redImage = [UIImage imageNamed:redStr];
    _grayImage = [UIImage imageNamed:grayStr];
    
    CGFloat starScale = _redImage.size.width / _redImage.size.height;
    CGFloat oneStarWidth = self.frame.size.width * 0.20;
    
    //计算星星的frame
    CGFloat star_size_width;//星星frame的width
    CGFloat star_size_height;//星星frame的height
    CGFloat star_origin_y;//星星frame的y值
    CGFloat spaceBetween; //间距
    
    if (self.frame.size.height >= _starHeight ) {
        if (_starHeight * starScale <= oneStarWidth) {
            star_size_height = _starHeight;
            star_size_width = star_size_height * starScale;
            spaceBetween = oneStarWidth - star_size_width;

        }else{
            spaceBetween = 0;
            star_size_width = oneStarWidth;
            star_size_height = oneStarWidth / starScale;
        }
        star_origin_y = (self.frame.size.height - star_size_height) * 0.5;
    }else{
        _starHeight = self.frame.size.height;
        if (_starHeight * starScale <= oneStarWidth) {
            star_size_height = _starHeight;
            star_size_width = star_size_height * starScale;
            spaceBetween = oneStarWidth - star_size_width;
            
        }else{
            spaceBetween = 0;
            star_size_height = oneStarWidth / starScale;
            star_size_width = oneStarWidth;
        }
        star_origin_y = (self.frame.size.height - star_size_height) * 0.5;
    }
    
    _star_origin_x = spaceBetween * 0.5;
    
    //设置星星的frame
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:_grayImage];
        imageView.frame = CGRectMake(_star_origin_x + (spaceBetween + star_size_width) * i, star_origin_y, star_size_width, star_size_height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [_starViewArr addObject:imageView];
    }
    
    //小数星星ImageView
    _partStarImgView = [[UIImageView alloc]init];
    _partStarImgView.image = _redImage;
    _partStarImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_partStarImgView];

}

- (void)setRatNum:(CGFloat)ratNum {
    _ratNum = ratNum;
    NSInteger num = ratNum / 1;
    for (NSInteger i = 0 ; i < _starViewArr.count; i++) {
        UIImageView *imageView = _starViewArr[i];
        if (i < num && imageView.image == _grayImage) {
            imageView.image = _redImage;
        }else if (i >= num && imageView.image == _redImage){
            imageView.image = _grayImage;
        }
    }
    CGFloat decimals = ratNum - num;
    if (decimals > 0 && num < _starViewArr.count) {
        UIImageView *imageView = _starViewArr[num];
        CGRect rect = imageView.frame;
        CGFloat width = rect.size.width * decimals;
        rect.size.width = width;
        _partStarImgView.frame = rect;
        _partStarImgView.layer.contentsRect = CGRectMake(0,0,decimals,1);
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_starsType == WWRatScoresStarsNormalRating) {
        if (_partStarImgView) {
            [_partStarImgView removeFromSuperview];
        }
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        NSInteger cout = ((int)touchPoint.x - _star_origin_x) / ((self.frame.size.width - _star_origin_x)* 0.2) + 1;
        if (cout <= 0) {
            cout = 1;
        }
        for (NSInteger i = 0; i < _starViewArr.count; i ++) {
            UIImageView *imageView = _starViewArr[i];
            imageView.image = i < cout ? _redImage : _grayImage;
        }
        if ([self.delegate respondsToSelector:@selector(ratingStartsView:ratingNumber:)]) {
            [self.delegate ratingStartsView:self ratingNumber:cout];
        }
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_starsType == WWRatScoresStarsFloatRating) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        CGFloat cout = (touchPoint.x - _star_origin_x) / ((self.frame.size.width - _star_origin_x) * 0.2);
        if (cout < 0) {
            cout = 0;
        }
        [self setRatNum:cout];
        if ([self.delegate respondsToSelector:@selector(ratingStartsView:ratingNumber:)]) {
            [self.delegate ratingStartsView:self ratingNumber:cout];
        }
    }
}

- (void)setStarsType:(WWRatScoresStarsType)starsType {
    if ( _starsType != starsType) {
        _starsType = starsType;
        [self creatViews];
    }
}

@end
