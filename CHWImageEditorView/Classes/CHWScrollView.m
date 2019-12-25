//
//  CHWScrollView.m
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import "CHWScrollView.h"

@interface CHWScrollView()
@end

@implementation CHWScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 15.0;
        self.clipsToBounds = YES;
        self.contentSize = self.bounds.size;
    }
    return self;
}

-(void)zoomScaleToRect:(CGRect)rect animated:(BOOL)animated{
    if (CGRectIsNull(rect) || CGRectIsEmpty(rect) || CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    CGFloat scaleW = CGRectGetWidth(self.bounds)/CGRectGetWidth(rect);
    CGFloat scaleH = CGRectGetHeight(self.bounds)/CGRectGetHeight(rect);
    CGFloat scale = MAX(scaleW,scaleH);
    self.minimumZoomScale = scale;
    [self setZoomScale:scale animated:animated];
}

-(void)validateContentOffset{
    CGFloat contentOffsetX = MAX(self.contentOffset.x, 0);
    CGFloat contentOffsetY = MAX(self.contentOffset.y, 0);
    if (self.contentSize.width-contentOffsetX<CGRectGetWidth(self.bounds)) {
        contentOffsetX = self.contentSize.width - CGRectGetWidth(self.bounds);
    }
    if (self.contentSize.height-contentOffsetY<CGRectGetHeight(self.bounds)) {
        contentOffsetY = self.contentSize.height - CGRectGetHeight(self.bounds);
    }
    self.contentOffset = CGPointMake(contentOffsetX,contentOffsetY);
}

-(void)updateLayout:(CGSize)newSize{
    CGPoint oldCenter = self.center;
    CGPoint oldContentOffset = self.contentOffset;
    CGPoint newContentOffset = CGPointMake(oldContentOffset.x+(CGRectGetWidth(self.bounds)-newSize.width), oldContentOffset.y+(CGRectGetHeight(self.bounds)-newSize.height));
    self.bounds = CGRectMake(0, 0, newSize.width, newSize.height);
    self.contentOffset = newContentOffset;
    self.center = oldCenter;
}

-(BOOL)shouldScale{
    return self.contentSize.width/CGRectGetWidth(self.bounds) <=1 || self.contentSize.height/CGRectGetHeight(self.bounds) <=1;
}

-(void)zoomScaleToBoundByAnimated:(BOOL)animated{
    CGFloat scaleW = CGRectGetWidth(self.bounds)/CGRectGetWidth(_imageContainer.bounds);
    CGFloat scaleH = CGRectGetHeight(self.bounds)/CGRectGetHeight(_imageContainer.bounds);
    CGFloat scale = MAX(scaleW, scaleH);
    self.minimumZoomScale = scale;
    [self setZoomScale:scale animated:animated];
}

-(void)resetByRect:(CGRect)rect{
    self.minimumZoomScale = 1.0;
    self.zoomScale = 1.0;
    
    self.frame = rect;
    self.contentSize = rect.size;
}
@end
