//
//  CHWMaskView.m
//  CropRotateView
//
//  Created by cherish on 2019/12/4.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import "CHWMaskView.h"
#import "CHWUtils.h"

@interface CHWMaskView()
@property(nonatomic) CGFloat fixPathValue;
@property(nonatomic,strong)CAShapeLayer* maskViewSlayer;
@property(nonatomic,strong)CAShapeLayer* maskViewDlayer;
@end

@implementation CHWMaskView

- (instancetype)initWithFrame:(CGRect)frame withShape:(ShapeType)shapeType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fixPathValue = 8.0;
        self.shapeType = shapeType;
        [self setUpViews];
    }
    return self;
}

- (void)setShapeType:(ShapeType)shapeType{
    _shapeType = shapeType;
    [self removeMaskViews];
    [self setUpViews];
    [self resetMaskFrameByCropBox:_cropBoxFrame withShape:_shapeType];
}

-(void)setUpViews{
    [self addSubview:self.maskViewD];
    [self addSubview:self.maskViewS];
    [self changeMaskShowStatus:MASK_STATIC];
}

-(void)changeMaskShowStatus:(MaskShowStatus)showStatus{
    if (showStatus == MASK_DYNAMIC) {
        _maskViewD.hidden = NO;
        _maskViewS.hidden = YES;
    }else{
        _maskViewD.hidden = YES;
        _maskViewS.hidden = NO;
    }
}

-(void)resetMaskFrameByCropBox:(CGRect)cropBoxFrame withShape:(ShapeType)shapeType{
    self.cropBoxFrame = cropBoxFrame;
//    if (shapeType == CIRCLE_SHAPE || shapeType == STAR_SHAPE || shapeType == HALF_CIRCLE_SHAPE || shapeType == SECTOR_SHAPE) {
//
//        CGFloat scaleX = CGRectGetWidth(cropBoxFrame)/_fixPathValue;
//        CGFloat scaleY = CGRectGetHeight(cropBoxFrame)/_fixPathValue;
//        CGFloat scale = MIN(scaleX, scaleY);
//        _maskViewD.transform = CGAffineTransformMakeScale(scale, scale);
//        _maskViewS.transform = CGAffineTransformMakeScale(scale, scale);
//    }else{
//        CGFloat scaleX = CGRectGetWidth(cropBoxFrame)/_fixPathValue;
//        CGFloat scaleY = CGRectGetHeight(cropBoxFrame)/_fixPathValue;
//        _maskViewD.transform = CGAffineTransformMakeScale(scaleX, scaleY);
//        _maskViewS.transform = CGAffineTransformMakeScale(scaleX, scaleY);
//    }
    
    
    UIBezierPath* layerPath = [self createMaskLayerPath:_shapeType];
    self.maskViewDlayer.path = layerPath.CGPath;
    self.maskViewSlayer.path = layerPath.CGPath;
//    self.center =  CGPointMake(CGRectGetMidX(cropBoxFrame),CGRectGetMidY(cropBoxFrame));
    
}

-(UIBezierPath*)createMaskLayerPath:(ShapeType)shapeType{
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath* path1 = [self createSubPath:shapeType withRect:_cropBoxFrame];
    [path appendPath:path1];
    path.usesEvenOddFillRule = true;
    return path;
}

-(CAShapeLayer*)createMaskShaperLayer:(float)opacity{
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [UIColor blackColor].CGColor;
    layer.opacity = opacity;
    return layer;
}

- (UIView *)maskViewD{
    if (!_maskViewD) {
        self.maskViewD = [[UIView alloc] initWithFrame:self.bounds];
        _maskViewD.clipsToBounds = YES;
        self.maskViewDlayer = [self createMaskShaperLayer:0.5];
        [_maskViewD.layer addSublayer:_maskViewDlayer];
    }
    return _maskViewD;
}

- (UIView *)maskViewS{
    if (!_maskViewS) {
        self.maskViewS = [[UIView alloc] initWithFrame:self.bounds];
        _maskViewS.clipsToBounds = YES;
        self.maskViewSlayer = [self createMaskShaperLayer:0.75];
        [_maskViewS.layer addSublayer:_maskViewSlayer];
    }
    return _maskViewS;
}

-(void)removeMaskViews{
    [self.maskViewS removeFromSuperview];
    [self.maskViewD removeFromSuperview];
    self.maskViewS = nil;
    self.maskViewD = nil;
}

-(UIBezierPath*)createSubPath:(ShapeType)shapeType withRect:(CGRect)rect{
    UIBezierPath* path = nil;
    switch (shapeType) {
        case SQUARE_SHAPE:
            path = [UIBezierPath bezierPathWithRect:rect];
            break;
        case CIRCLE_SHAPE:
            path = [CHWUtils getCirclePath:rect];
            break;
        case OVAL_SHAPE:
            path = [CHWUtils getOvalPath:rect];
            break;
        case TRIANGLE_SHAPE:
            path = [CHWUtils getTrianglePath:rect];
            break;
        case HEART_SHAPE:
            path = [CHWUtils heartBezierPathWithToRect:rect];
            break;
        case HEXAGON_SHAPE:
            path = [CHWUtils getHopHexagonShapeBezierPath:rect];
            break;
        case STAR_SHAPE:
            path = [CHWUtils getStarShapeBezierPath:rect];
            break;
        case ARC_SHAPE:
            path = [CHWUtils getArcRectBezierPath:rect];
            break;
        case CROSS_SHAPE:
            path = [CHWUtils getCrossShapeBezierPath:rect];
            break;
        case SECTOR_SHAPE:
            path = [CHWUtils getSectorBezierPath:rect];
            break;
        case HALF_CIRCLE_SHAPE:
            path = [CHWUtils getHalfCirclePath:rect];
            break;
        case OCTAGON_SHAPE:
            path = [CHWUtils getOctagonPath:rect numberOfSides:8];
            break;
        default:
            path = [UIBezierPath bezierPathWithRect:rect];
            break;
    }
    return path;
}
@end
