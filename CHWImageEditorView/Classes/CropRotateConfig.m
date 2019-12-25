//
//  CropRotateConfig.m
//  CropRotateView
//
//  Created by cherish on 2019/12/4.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import "CropRotateConfig.h"
#import "CropBoxLockedAspectFrameBuilder.h"
#import "CropBoxFreeAspectFrameBuilder.h"
#import "CHWWheelDial/CHWAngle.h"

@interface CropRotateConfig()
@property(nonatomic)CGPoint touchBeginPoint;
@property(nonatomic)CGFloat degrees;
@end


@implementation CropRotateConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shapeType = SQUARE_SHAPE;
        self.cropBoxFrame = CGRectZero;
        self.cropBoxOriginalFrame = CGRectZero;
        self.startOriginPoint = CGPointZero;
        self.touchedEdgeType = none;
        self.degrees = 0.0;
        self.rotate90Degree = Rotate90Degree_0;
        self.aspectRatio = -1;
        self.pointLocationOnLeftTop = CGPointZero;
        self.pointLocationOnRightBottom = CGPointMake(1, 1);
        self.wheelConfig = [CHWConfigModel new];
    }
    return self;
}

-(void)reset:(BOOL)forceFixedRatio{
    self.cropBoxFrame = CGRectZero;
    self.degrees = 0;
    self.rotate90Degree = Rotate90Degree_0;
    
    if (!forceFixedRatio) {
        self.aspectRatio = -1;
    }
    
    _pointLocationOnLeftTop = CGPointZero;
    _pointLocationOnRightBottom = CGPointMake(1, 1);
    
    self.viewStatus = initial;
}

-(void)counterclockwiseRotate90:(BOOL)isClockwise{
    if (isClockwise) {
        self.rotate90Degree = self.rotate90Degree-90;
    }else{
        self.rotate90Degree = self.rotate90Degree+90;
    }
    if (self.rotate90Degree == 360 || self.rotate90Degree == -360)  {
        self.rotate90Degree = Rotate90Degree_0;
    }
}


-(CGFloat)getTotalRadiasByRadians:(CGFloat)radians {
    return radians + _rotate90Degree * M_PI / 180;
}

-(CGFloat)getTotalRadians{
    return [self getTotalRadiasByRadians:_radians];
}

- (void)setViewStatus:(CropRotateViewStatus)viewStatus{
    _viewStatus = viewStatus;
    if (self.statusChanged) {
        self.statusChanged(viewStatus);
    }
}

-(void)calulateCropBoxFrame:(CGRect)initialCropBox byImageScale:(CGFloat)scale{
    CGRect cropBoxFrame = initialCropBox;
    CGPoint center = CGPointMake(CGRectGetMidX(cropBoxFrame), CGRectGetMidY(cropBoxFrame));
    if (_aspectRatio > scale) {
        cropBoxFrame.size.height = cropBoxFrame.size.width / _aspectRatio;
    }else{
        if (_aspectRatio != 0.0) {
            cropBoxFrame.size.width = cropBoxFrame.size.height * _aspectRatio;
        }
    }
    
    cropBoxFrame.origin.x = center.x - cropBoxFrame.size.width / 2;
    cropBoxFrame.origin.y = center.y - cropBoxFrame.size.height / 2;
    
    self.cropBoxFrame = cropBoxFrame;
}

- (CGFloat)radians{
    _radians = _degrees * M_PI / 180;
    return _radians;
}

-(CGFloat)getCurrentRadians{
    return self.radians + _rotate90Degree * M_PI / 180;
}

- (void)setAngle:(CHWAngle *)angle{
    _angle = angle;
    self.radians = angle.radians;
    self.degrees = angle.degress;
}

-(void)prepareForCropByTouchPoint:(CGPoint)point{
    _startOriginPoint = point;
    _cropBoxOriginalFrame = _cropBoxFrame;
    
    self.touchedEdgeType = [self getCropOverlayEdge:point];
    
    if (_touchedEdgeType == none){
        self.viewStatus = touchedImage;
    } else {
        self.viewStatus = touchedCropbox;
    }
}

-(void)resetCropFrame:(CGRect)frame{
    self.cropBoxFrame = frame;
    self.cropBoxOriginalFrame = frame;
}

-(BOOL)checkNeedCropOrNot{
    return !CGRectEqualToRect(_cropBoxOriginalFrame, _cropBoxFrame);
}

-(CGRect)getNewCropBoxFrameWith:(CGPoint) point contentFrame:(CGRect)contentFrame withViewPading:(CGFloat)cropViewPadding aspectRatioLockEnabled:(BOOL)aspectRatioLockEnabled{
    CGPoint p = point;
    p.x = MAX(contentFrame.origin.x - cropViewPadding, p.x);
    p.y = MAX(contentFrame.origin.y - cropViewPadding, p.y);
    
    CGFloat xDelta = ceil(p.x - _startOriginPoint.x);
    CGFloat yDelta = ceil(p.y - _startOriginPoint.y);
    
    CGRect newCropBoxFrame = CGRectZero;
    if (aspectRatioLockEnabled) {
        CropBoxLockedAspectFrameBuilder* cropBoxLockedAspectFrameBuilder = [[CropBoxLockedAspectFrameBuilder alloc] initTouchedEdge:_touchedEdgeType withContentFrame:contentFrame withCropOriginFrame:_cropBoxOriginalFrame withCropBoxFrame:_cropBoxFrame];
        [cropBoxLockedAspectFrameBuilder updateCropBoxFrame:xDelta withYDelta:yDelta];
        newCropBoxFrame = cropBoxLockedAspectFrameBuilder.cropBoxFrame;
    } else {
        CropBoxFreeAspectFrameBuilder* cropBoxFreeAspectFrameBuilder = [[CropBoxFreeAspectFrameBuilder alloc] initTouchedEdge:_touchedEdgeType withContentFrame:contentFrame withCropOriginFrame:_cropBoxOriginalFrame withCropBoxFrame:_cropBoxFrame];
        [cropBoxFreeAspectFrameBuilder updateCropBoxFrame:xDelta by:yDelta];
        newCropBoxFrame = cropBoxFreeAspectFrameBuilder.cropBoxFrame;
    }
    
    return newCropBoxFrame;
}

-(void)setCropBoxFrame:(CGRect)initialCropBox andRationH:(CGFloat)imageRationH {
    CGRect cropBoxFrame = initialCropBox;
    CGPoint center = CGPointMake(CGRectGetMidX(cropBoxFrame), CGRectGetMidY(cropBoxFrame));
    CGFloat height = CGRectGetHeight(cropBoxFrame);
    CGFloat width = CGRectGetWidth(cropBoxFrame);
    if (_aspectRatio > imageRationH) {
        height = CGRectGetWidth(cropBoxFrame) / _aspectRatio;
    } else {
        width = CGRectGetHeight(cropBoxFrame) * _aspectRatio;
    }
    CGFloat x = center.x - width / 2;
    CGFloat y = center.y - height / 2;
    
    self.cropBoxFrame = CGRectMake(x, y, width, height);
}

-(CropRotateOverlayEdge)getCropOverlayEdge:(CGPoint)point{
    CGRect currentTouchedRect = CGRectInset(_cropBoxFrame, -hotAreaUnit / 2, -hotAreaUnit / 2);
    CGRect topLeftRect = CGRectMake(currentTouchedRect.origin.x,currentTouchedRect.origin.y, hotAreaUnit,hotAreaUnit);
    if (CGRectContainsPoint(topLeftRect, point)) {
        return topLeft;
    }
    
    CGRect topRightRect = CGRectOffset(topLeftRect, currentTouchedRect.size.width - hotAreaUnit, 0);
    if (CGRectContainsPoint(topRightRect, point)) {
        return topRight;
    }
    
    CGRect bottomLeftRect = CGRectOffset(topLeftRect, 0, currentTouchedRect.size.width - hotAreaUnit);
    if (CGRectContainsPoint(bottomLeftRect, point)) {
        return bottomLeft;
    }
    
    CGRect bottomRightRect = CGRectOffset(bottomLeftRect, currentTouchedRect.size.width - hotAreaUnit, 0);
    if (CGRectContainsPoint(bottomRightRect, point)) {
        return bottomRight;
    }
    
    //Check for outer line border edge
    CGRect topRect = CGRectMake(currentTouchedRect.origin.x,currentTouchedRect.origin.y,currentTouchedRect.size.width,hotAreaUnit);
    if (CGRectContainsPoint(topRect, point)) {
        return top;
    }
    
    CGRect leftRect = CGRectMake(currentTouchedRect.origin.x,currentTouchedRect.origin.y, hotAreaUnit,currentTouchedRect.size.height);
    if (CGRectContainsPoint(leftRect, point)) {
        return left;
    }
    
    CGRect rightRect = CGRectMake(CGRectGetMaxX(currentTouchedRect) - hotAreaUnit, currentTouchedRect.origin.y,hotAreaUnit,CGRectGetHeight(currentTouchedRect));
    if (CGRectContainsPoint(rightRect, point)) {
        return right;
    }
    
    CGRect bottomRect = CGRectMake(currentTouchedRect.origin.x, CGRectGetMaxY(currentTouchedRect) - hotAreaUnit, currentTouchedRect.size.width, hotAreaUnit);
    if (CGRectContainsPoint(bottomRect, point)) {
        return bottom;
    }
    return none;
}
@end
