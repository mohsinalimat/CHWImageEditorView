//
//  CHWCropRotateView.m
//  CropRotateView
//
//  Created by cherish on 2019/12/3.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#import "CHWCropRotateView.h"
#import "CHWScrollView.h"
#import "CHWMacroDefine.h"
#import "CHWGridOverlayView.h"
#import "CHWMaskView.h"
#import "CHWWheelDial/CHWWheelDial.h"
#import "CHWWheelDial/CHWAngle.h"
#import "CHWCropInfoModel.h"
#import "UIImage+CHWImageTool.h"
#import "CHWUtils.h"

@interface CHWCropRotateView()<UIScrollViewDelegate>
@property(nonatomic,strong)CHWScrollView* scrollView;
@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,strong)CHWGridOverlayView* gridOverlayView;
@property(nonatomic,strong)CropRotateConfig* mConfig;
@property(nonatomic,strong)CHWMaskView* maskView;
@property(nonatomic)CGFloat cropRotatePading;
@property(nonatomic)CGFloat  cropViewMinimumBoxSize;
@property(nonatomic)CGFloat originImageScale;
@property(nonatomic)CGRect initialCropBoxFrame;
@property(nonatomic)BOOL manualZoomed;
@property(nonatomic,strong)CHWWheelDial* rotationWheelDial;
@property(nonatomic)CGFloat angleDashboardHeight;
@property(nonatomic)BOOL aspectRatioLockEnabled;
@end

@implementation CHWCropRotateView

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (CGFloat)originImageScale{
    if (!_image) {
        return 0;
    }
    return _image.size.width/_image.size.height;
}

- (CGRect)initialCropBoxFrame{
    CGSize imageSize = self.image.size;
    if (imageSize.height<=0 || imageSize.width<=0) {
        return CGRectZero;
    }
    
    CGRect contentRect = [self getContentRect];
    return [self calulateRectByContentRect:contentRect withScale:self.originImageScale];
}

- (void)dealloc
{
    [self.mConfig removeObserver:self forKeyPath:@"cropBoxFrame"];
}

- (instancetype)initWithConfig:(CropRotateConfig*)config{
    return [self initWithImage:nil withConfig:config];
}

- (instancetype)initWithImage:(UIImage*)image withConfig:(CropRotateConfig*)config
{
    self = [super init];
    if (self) {
        self.forceFixedRatio = NO;
        self.aspectRatioLockEnabled = NO;
        self.manualZoomed = NO;
        self.mConfig = config;
        self.image = image;
        self.originImageScale = _image.size.width/_image.size.height;
        self.cropRotatePading = 10.0;
        self.angleDashboardHeight = 60.0;
        self.cropViewMinimumBoxSize = 42;
        [self setDefaultConfig];
        [self initalRender];
        [self.mConfig addObserver:self forKeyPath:@"cropBoxFrame" options:NSKeyValueObservingOptionNew context:nil];
        
        __weak typeof(self)weak_self = self;
        self.mConfig.statusChanged = ^(CropRotateViewStatus viewStatus) {
            __strong typeof(weak_self)strong_self = weak_self;
            if (strong_self) {
                strong_self.gridOverlayView.hidden = NO;
                switch (viewStatus) {
                    case initial:// reset UI
                        [strong_self initalRender];
                        break;
                    case rotatieAngle:
                        [strong_self  rotateScrollView];
                        break;
                    case degree90Rotated:
                        [strong_self.maskView changeMaskShowStatus:MASK_STATIC];
                        strong_self.gridOverlayView.hidden = YES;
                        strong_self.rotationWheelDial.hidden = YES;
                        break;
                    case touchedImage:
                        [strong_self.maskView changeMaskShowStatus:MASK_DYNAMIC];
                        strong_self.gridOverlayView.cropRotateStatus = SQUARE_CROP;
                        [strong_self.gridOverlayView setGridLineStatus:NO animate:YES];
                        break;
                    case touchedRotationBoard:
                        strong_self.gridOverlayView.cropRotateStatus = ROTATE;
                        [strong_self.gridOverlayView setGridLineStatus:NO animate:YES];
                        [strong_self.maskView changeMaskShowStatus:MASK_DYNAMIC];
                        break;
                    case touchedCropbox:
                        strong_self.rotationWheelDial.hidden = YES;
                        [strong_self.maskView changeMaskShowStatus:MASK_DYNAMIC];
                        strong_self.gridOverlayView.cropRotateStatus = SQUARE_CROP;
                        [strong_self.gridOverlayView setGridLineStatus:NO animate:YES];
                        break;
                    case endAllOperation:
                        [strong_self.gridOverlayView setGridLineStatus:YES animate:YES];
                        strong_self.rotationWheelDial.hidden = NO;
                        [strong_self adaptAngleWheelDialToCropBox];
                        [strong_self.maskView changeMaskShowStatus:MASK_STATIC];
                        [strong_self resetResetButtonStatus];
                        break;
                    default:
                        break;
                }
            }
        };
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self layoutSubViewsFrame];
    [self resetUIFrame];
}

-(void)setDefaultConfig{
    if (!_mConfig.aspectRatio) {
        _mConfig.aspectRatio = _image.size.width/_image.size.height;
    }
    
    if (!_mConfig.cornerColor) {
        _mConfig.cornerColor = [UIColor whiteColor];
    }
    
    if (!_mConfig.innerLineColor) {
        _mConfig.innerLineColor = [UIColor whiteColor];
    }
    
    if (!_mConfig.outerLineColor) {
        _mConfig.outerLineColor = [UIColor whiteColor];
    }
    
    if (!_mConfig.rotateLinesCount) {
        _mConfig.rotateLinesCount = 9;
    }
    
    if (!_mConfig.cropLinesCount) {
        _mConfig.cropLinesCount = 3;
    }
    
    if (!_mConfig.outerLineBorderWidth) {
        _mConfig.outerLineBorderWidth = 1.0;
    }
    
    if (!_mConfig.innerLineBorderWidth) {
        _mConfig.innerLineBorderWidth = 1.0;
    }
    
    if (!_mConfig.cornerBorderLong) {
        _mConfig.cornerBorderLong = 24.0;
    }
    
    if (!_mConfig.cornerBorderThickness) {
        _mConfig.cornerBorderThickness = 4.0;
    }
}

-(void)initalRender{
    [self setUpViews];
    [self resetResetButtonStatus];
}

-(void)resetResetButtonStatus{
    BOOL cropRotateViewCanResetAble = [self checkCropRotateViewCanReset];
    if (_delegate && [_delegate respondsToSelector:@selector(cropViewDidBecomeResettable:canResettable:)]) {
        [_delegate cropViewDidBecomeResettable:self canResettable:cropRotateViewCanResetAble];
    }
}

-(void)setUpViews{
    self.scrollView = [[CHWScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    _imageView.layer.minificationFilter = kCAFilterTrilinear;
    [_scrollView addSubview:_imageView];
    _scrollView.imageContainer = _imageView;
    
    self.gridOverlayView = [[CHWGridOverlayView alloc] initWithFrame:CGRectZero withConfig:_mConfig];
    _gridOverlayView.currentGridLineHidden = NO;
    [self addSubview:_gridOverlayView];
    
    self.maskView = [[CHWMaskView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*10, [UIScreen mainScreen].bounds.size.height*10) withShape:self.mConfig.shapeType];
    [self addSubview:_maskView];
}

-(void)reset{
    [self.scrollView removeFromSuperview];
    [self.gridOverlayView removeFromSuperview];
    [self.rotationWheelDial removeFromSuperview];
    
    if (self.forceFixedRatio) {
        self.aspectRatioLockEnabled = YES;
    } else {
        self.aspectRatioLockEnabled = NO;
    }
    [self.mConfig reset:self.forceFixedRatio];
    [self resetUIFrame];
    
    [self.rotationWheelDial resetWheelDial];
    CHWAngle* angel = [[CHWAngle alloc] initWithRadians:0];
    self.mConfig.angle = angel; 
}

-(void)resetUIFrame{
    [self.maskView removeMaskViews];
    [self.maskView setUpViews];
    [self.mConfig resetCropFrame:self.initialCropBoxFrame];
    self.scrollView.transform = CGAffineTransformIdentity;
    [self.scrollView resetByRect:self.mConfig.cropBoxFrame];
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.center = CGPointMake(_scrollView.bounds.size.width/2,_scrollView.bounds.size.height/2);
    
    [self.gridOverlayView.superview bringSubviewToFront:_gridOverlayView];
    
    [self addSubview:self.rotationWheelDial];
    
//    if (_aspectRatioLockEnabled) {
//        [self setFixedRatioCropBox];
//    }
    self.mConfig.viewStatus = endAllOperation;
}

- (CHWWheelDial *)rotationWheelDial{
    if (!_rotationWheelDial) {
        CHWConfigModel* wheelConfig = _mConfig.wheelConfig;
        wheelConfig.backgroundColor = [UIColor clearColor];
        wheelConfig.showLimitType = Yes_Show_Limit;
        wheelConfig.maxShowAngle = [[CHWAngle alloc] initWithDegrees:40];
        wheelConfig.rotateLimitType = Yes_Rotate_Limit;
        wheelConfig.maxRotateAngle = [[CHWAngle alloc] initWithDegrees:45];
        wheelConfig.numberShowSpan = 1;
        wheelConfig.pointerColor = [UIColor lightGrayColor];
        
        CGFloat wheelLength = MIN(CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)) * 0.6;
        self.rotationWheelDial = [[CHWWheelDial alloc] initWithFrame:CGRectMake(0, 0, wheelLength, _angleDashboardHeight) withConfigModel:wheelConfig];
        _rotationWheelDial.userInteractionEnabled = YES;
        [_rotationWheelDial setRotationCenterByPoint:_gridOverlayView.center ofView:self];
        
        __weak typeof(self)weak_self = self;
        _rotationWheelDial.didRotateBlock = ^(CHWAngle * _Nonnull angle) {
            __strong typeof(weak_self)strong_self = weak_self;
            if (strong_self) {
                if (strong_self.forceFixedRatio) {
                    CGFloat newRadians = [strong_self.mConfig getTotalRadiasByRadians:angle.radians];
                    strong_self.mConfig.viewStatus = rotatieAngle;
                    strong_self.mConfig.angle =  [[CHWAngle alloc] initWithRadians:newRadians];
                } else {
                    strong_self.mConfig.angle =  angle;
                    strong_self.mConfig.viewStatus = rotatieAngle;
                }
            }
        };
        _rotationWheelDial.didFinishedRotateBlock = ^{
            __strong typeof(weak_self)strong_self = weak_self;
            if (strong_self) {
                strong_self.mConfig.viewStatus = endAllOperation;
            }
        };
        
        [_rotationWheelDial rotateWheelPlateByAngle:[[CHWAngle alloc] initWithRadians:[self.mConfig getCurrentRadians]]];
        [self adaptAngleWheelDialToCropBox];
    }
    return _rotationWheelDial;
}

-(void)rotateScrollView{
    CGFloat totalRadians = _mConfig.getCurrentRadians;
    self.scrollView.transform = CGAffineTransformMakeRotation(totalRadians);
    [self updateScrollViewPosition:totalRadians];
}

-(void)counterclockwiseRotate90:(BOOL)isClock{
    self.mConfig.viewStatus =  degree90Rotated;
    if (_forceFixedRatio) {
        CHWAngle* angleInitial = [[CHWAngle alloc] initWithRadians:[self.mConfig getCurrentRadians]];
        self.mConfig.angle = angleInitial;
        self.mConfig.viewStatus = rotatieAngle;
        CHWAngle* angle = [[CHWAngle alloc] initWithRadians:isClock?-M_PI_2:M_PI_2+[self.mConfig getCurrentRadians]];
        self.mConfig.angle = angle;
        [UIView animateWithDuration:0.45 animations:^{
            self.mConfig.viewStatus = rotatieAngle;
        } completion:^(BOOL finished) {
            [self.mConfig counterclockwiseRotate90:isClock];
            self.mConfig.viewStatus = endAllOperation;
        }];
        return;
    }
    
    CGRect rect = _gridOverlayView.frame;
    CGFloat width = rect.size.height;
    CGFloat height = rect.size.width;
    rect = CGRectMake(self.gridOverlayView.frame.origin.x, self.gridOverlayView.frame.origin.y, width, height);
    
    CGRect contentRect = [self getContentRect];
    CGFloat scale = CGRectGetWidth(rect)/CGRectGetHeight(rect);
    CGRect newRect = [self calulateRectByContentRect:contentRect withScale:scale];
    
    CGFloat radian = isClock?-M_PI_2:M_PI_2;
    CGAffineTransform transform = CGAffineTransformRotate(_scrollView.transform, radian);
    [UIView animateWithDuration:0.45 animations:^{
        self.mConfig.cropBoxFrame = newRect;
        self.scrollView.transform = transform;
        [self updatePositionFor90Rotation:radian + self.mConfig.radians];
    } completion:^(BOOL finished) {
        [self.mConfig counterclockwiseRotate90:isClock];
        self.mConfig.viewStatus = endAllOperation;
    }];
}

-(void)updateScrollViewPosition:(CGFloat)radians{
    CGFloat width = fabs(cos(radians)) * _gridOverlayView.frame.size.width + fabs(sin(radians)) * _gridOverlayView.frame.size.height;
    CGFloat height = fabs(sin(radians)) * _gridOverlayView.frame.size.width + fabs(cos(radians)) * _gridOverlayView.frame.size.height;
    [_scrollView updateLayout:CGSizeMake(width, height)];
    if (!_manualZoomed || [_scrollView shouldScale]){
        [_scrollView zoomScaleToBoundByAnimated:NO];
        _manualZoomed = NO;
    }
    
    [_scrollView validateContentOffset];
}

-(void)saveAnchorPoints{
    self.mConfig.pointLocationOnRightBottom = [self getImageRightBottomFixPoint];
    self.mConfig.pointLocationOnLeftTop = [self getImageLeftTopFixPoint];
}

-(CGPoint)getImageLeftTopFixPoint{
    if (CGRectIsEmpty(_imageView.frame)) {
        return _mConfig.pointLocationOnLeftTop;
    }
    CGPoint lt = [_gridOverlayView convertPoint:CGPointMake(0, 0) toView:_imageView];
    CGPoint point = CGPointMake(lt.x / _imageView.bounds.size.width, lt.y / _imageView.bounds.size.height);
    
     return point;
}

-(CGPoint)getImageRightBottomFixPoint{
    if (CGRectIsEmpty(_imageView.frame)) {
        return _mConfig.pointLocationOnRightBottom;
    }
    CGPoint rb = [_gridOverlayView convertPoint:CGPointMake(_gridOverlayView.bounds.size.width, _gridOverlayView.bounds.size.height) toView:_imageView];
    
    CGPoint point = CGPointMake(rb.x / _imageView.bounds.size.width, rb.y / _imageView.bounds.size.height);
    return point;
}

-(BOOL)isSamePoint:(CGPoint)point1 point2:(CGPoint)point2{
    if (fabs(point1.x-point2.x) < 1 && fabs(point1.y-point2.y) < 1) {
        return YES;
    }
    return NO;
}

-(BOOL)checkCropRotateViewCanReset{
    if ([self.mConfig getCurrentRadians] != 0) {
        return YES;
    }
    
    CGRect gridOverlayFrame = _gridOverlayView.frame;
    CGRect imageViewFrame = [_imageView convertRect:_imageView.frame toView:self];
    
    
    if (!([self isSamePoint:gridOverlayFrame.origin point2:imageViewFrame.origin] && [self isSamePoint:CGPointMake(CGRectGetMaxX(gridOverlayFrame), CGRectGetMaxY(gridOverlayFrame)) point2:CGPointMake(CGRectGetMaxX(imageViewFrame), CGRectGetMaxY(imageViewFrame))])) {
        return YES;
    }
//    CGPoint leftTopPoint = [self getImageLeftTopFixPoint];
//
//    if (!(fabs(leftTopPoint.x-0) < DBL_EPSILON && fabs(leftTopPoint.y-0) < DBL_EPSILON)) {
//        return YES;
//    }
//
//    CGPoint rightBottomPoint = [self getImageRightBottomFixPoint];
//
//    if (!(fabs(rightBottomPoint.x-1) < DBL_EPSILON && fabs(rightBottomPoint.y-1) < DBL_EPSILON)) {
//        return YES;
//    }
    
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cropBoxFrame"]) {
        CGRect rect = [((NSValue*)[change objectForKey:NSKeyValueChangeNewKey]) CGRectValue];
        self.gridOverlayView.frame = rect;
        [self.maskView resetMaskFrameByCropBox:rect withShape:self.mConfig.shapeType];
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)layoutSubViewsFrame{
    self.mConfig.cropBoxFrame = self.initialCropBoxFrame;
    self.mConfig.cropBoxOriginalFrame = _initialCropBoxFrame;
    [_maskView changeMaskShowStatus:MASK_STATIC];
    _scrollView.transform = CGAffineTransformIdentity;
    _scrollView.frame = _mConfig.cropBoxFrame;
    
    _imageView.frame = _scrollView.bounds;
    
    [self.gridOverlayView.superview bringSubviewToFront:self.gridOverlayView];
}

-(CGRect)getContentRect{
    CGRect contentRect = CGRectMake(_cropRotatePading, _cropRotatePading, CGRectGetWidth(self.bounds)-2*_cropRotatePading, CGRectGetHeight(self.bounds)-2*_cropRotatePading);
    return contentRect;
}

-(CGRect)calulateRectByContentRect:(CGRect)contentRect withScale:(CGFloat)scale{
    CGFloat contentScale = CGRectGetWidth(contentRect)/CGRectGetHeight(contentRect);
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (contentScale>scale) {
        height = CGRectGetHeight(contentRect);
        width = height*scale;
    }else{
        width = CGRectGetWidth(contentRect);
        height = width/scale;
    }
    return CGRectMake(CGRectGetMidX(contentRect)-width/2.0, CGRectGetMidY(contentRect)-height/2.0, width, height);
}

#pragma mark provide the interface for calling
- (void)squareCropImageByRatio:(SquareCropRatio)cropRatio{
    CGFloat ratio = -1.0;
    switch (cropRatio) {
        case SquareCropRatio_Free:
            ratio = 0.0;
            break;
        case SquareCropRatio_Origin:
            ratio = self.originImageScale;
            break;
        case SquareCropRatio_1x1:
            ratio = 1.0;
            break;
        case SquareCropRatio_2x3:
            ratio = 2.0/3.0;
            break;
        case SquareCropRatio_3x2:
            ratio = 3.0/2.0;
            break;
        case SquareCropRatio_4x3:
            ratio = 4.0/3.0;
            break;
        case SquareCropRatio_3x4:
            ratio = 3.0/4.0;
            break;
        case SquareCropRatio_5x7:
            ratio = 5.0/7.0;
            break;
        case SquareCropRatio_7x5:
            ratio = 7.0/5.0;
            break;
        case SquareCropRatio_16x9:
            ratio = 16.0/9.0;
            break;
        case SquareCropRatio_9x16:
            ratio = 9.0/16.0;
            break;
            
        default:
            break;
    }
    if (cropRatio == SquareCropRatio_Free) {
        self.aspectRatioLockEnabled = NO;
    }else{
        self.aspectRatioLockEnabled = YES;
    }
    self.mConfig.aspectRatio = ratio;
    [self.mConfig calulateCropBoxFrame:self.initialCropBoxFrame byImageScale:self.originImageScale];
    
    //    adjustUIForNewCrop(contentRect: contentRect, animation: false) { [weak self] in
    //        self?.viewModel.setBetweenOperationStatus()
    //    }
    
    [self updateViewsWhenDoNewCrop:NO withCompleteBlock:^{
        self.mConfig.viewStatus = endAllOperation;
    }];
    
    [self adaptAngleWheelDialToCropBox];
}

-(void)updatePositionFor90Rotation:(CGFloat)radians {
    CGFloat width = fabs(cos(radians)) * _gridOverlayView.frame.size.width + fabs(sin(radians)) * _gridOverlayView.frame.size.height;
    CGFloat height = fabs(sin(radians)) * _gridOverlayView.frame.size.width + fabs(cos(radians)) * _gridOverlayView.frame.size.height;
    
    CGSize newSize = CGSizeZero;
    if (_mConfig.rotate90Degree == Rotate90Degree_0 || _mConfig.rotate90Degree == Rotate90Degree_180 || _mConfig.rotate90Degree == Rotate90Degree_Neg_180) {
        newSize = CGSizeMake(width,height);
    } else {
        newSize = CGSizeMake(height,width);
    }
    
    CGFloat scale = newSize.width / _scrollView.bounds.size.width;
    [_scrollView updateLayout:newSize];
    
    CGFloat newZoomScale = _scrollView.zoomScale * scale;
    _scrollView.minimumZoomScale = newZoomScale;
    _scrollView.zoomScale = newZoomScale;
    
    [_scrollView validateContentOffset];
}

-(void)updateViewsWhenDoNewCrop:(BOOL)animation withCompleteBlock:(void(^)(void)) completion{
    CGRect contentRect = [self getContentRect];
    CGFloat scaleX = CGRectGetWidth(contentRect) / CGRectGetWidth(_mConfig.cropBoxFrame);
    CGFloat scaleY = CGRectGetHeight(contentRect) / CGRectGetHeight(_mConfig.cropBoxFrame);
    
    CGFloat scale = MIN(scaleX, scaleY);
    
    CGRect newCropFrame = CGRectMake(0,0,CGRectGetWidth(_mConfig.cropBoxFrame) * scale,CGRectGetHeight(_mConfig.cropBoxFrame) * scale);
    
    CGFloat currentRadians = [self.mConfig getCurrentRadians];
    
    CGFloat width = fabs(cos(currentRadians)) * newCropFrame.size.width + fabs(sin(currentRadians)) * newCropFrame.size.height;
    CGFloat height = fabs(sin(currentRadians)) * newCropFrame.size.width + fabs(cos(currentRadians)) * newCropFrame.size.height;
    
    CGRect scaleFrame = _mConfig.cropBoxFrame;
    if (CGRectGetWidth(scaleFrame) >= _scrollView.contentSize.width) {
        scaleFrame.size.width = _scrollView.contentSize.width;
    }
    if (CGRectGetHeight(scaleFrame) >= _scrollView.contentSize.height) {
        scaleFrame.size.height = _scrollView.contentSize.height;
    }
    
    CGPoint contentOffset = _scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake((contentOffset.x + _scrollView.bounds.size.width / 2),(contentOffset.y + _scrollView.bounds.size.height / 2));
    
    
    _scrollView.bounds = CGRectMake(0,0,width,height);
    
    CGPoint newContentOffset = CGPointMake((contentOffsetCenter.x - _scrollView.bounds.size.width/ 2),
                                           (contentOffsetCenter.y - _scrollView.bounds.size.height / 2));
    _scrollView.contentOffset = newContentOffset;
    
    CGRect newCropBoxFrame = [self calulateRectByContentRect:contentRect withScale:CGRectGetWidth(_mConfig.cropBoxFrame)/CGRectGetHeight(_mConfig.cropBoxFrame)];
    
    void(^ZoomScrollViewBlock)(CGRect,CGRect)  = ^(CGRect cropBoxFrame,CGRect scaleFrame){
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        self.mConfig.cropBoxFrame = cropBoxFrame;
        CGRect zoomRect = [self convertRect:scaleFrame toView:self.imageView];
        [self.scrollView zoomToRect:zoomRect animated:NO];
        [self.scrollView validateContentOffset];
    };
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            ZoomScrollViewBlock(newCropBoxFrame,scaleFrame);
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        ZoomScrollViewBlock(newCropBoxFrame,scaleFrame);
        completion();
    }
    self.manualZoomed = YES;
}

-(void)adaptAngleWheelDialToCropBox{
    if (!_rotationWheelDial) {
        return;
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _rotationWheelDial.transform = CGAffineTransformMakeRotation(0);
        CGFloat x = _gridOverlayView.frame.origin.x +  (_gridOverlayView.frame.size.width - _rotationWheelDial.frame.size.width) / 2;
        CGFloat y = CGRectGetMaxY(_gridOverlayView.frame);
        _rotationWheelDial.frame = CGRectMake(x, y, CGRectGetWidth(_rotationWheelDial.frame), CGRectGetHeight(_rotationWheelDial.frame));
    }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
        _rotationWheelDial.transform = CGAffineTransformMakeRotation(-M_PI_2);
        CGFloat x = CGRectGetMaxX(_gridOverlayView.frame);
        CGFloat y = _gridOverlayView.frame.origin.y + (_gridOverlayView.frame.size.height - _rotationWheelDial.frame.size.height) / 2;
        _rotationWheelDial.frame = CGRectMake(x, y, CGRectGetWidth(_rotationWheelDial.frame), CGRectGetHeight(_rotationWheelDial.frame));
        
    }else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        _rotationWheelDial.transform = CGAffineTransformMakeRotation(M_PI_2);
        CGFloat x = CGRectGetMinX(_gridOverlayView.frame) - _rotationWheelDial.frame.size.width;
        CGFloat y = _gridOverlayView.frame.origin.y + (_gridOverlayView.frame.size.height - _rotationWheelDial.frame.size.height) / 2;
        _rotationWheelDial.frame = CGRectMake(x, y, CGRectGetWidth(_rotationWheelDial.frame), CGRectGetHeight(_rotationWheelDial.frame));
    }
}

-(void)updateCropBoxFrame:(CGPoint)point{
    CGRect contentFrame = [self getContentRect];
    CGRect newCropBoxFrame = [self.mConfig getNewCropBoxFrameWith:point contentFrame:contentFrame withViewPading:_cropRotatePading aspectRatioLockEnabled:_aspectRatioLockEnabled];
    if (CGRectGetWidth(newCropBoxFrame) >= _cropViewMinimumBoxSize && CGRectGetHeight(newCropBoxFrame) >= _cropViewMinimumBoxSize){
        
        CGRect newRect = [self convertRect:newCropBoxFrame toView:_imageView];
        
        CGPoint p1 = newRect.origin;
        CGPoint p2 = CGPointMake(CGRectGetMaxX(newRect),CGRectGetMaxY(newRect));
        
        CGFloat tolerance = 1e-6;
        CGRect refBounds = CGRectInset(_imageView.bounds, -tolerance, -tolerance);
        
        BOOL isContains = CGRectContainsPoint(refBounds, p1) && CGRectContainsPoint(refBounds, p2);
        isContains = YES;//Temp
        if (isContains){
            self.mConfig.cropBoxFrame = newCropBoxFrame;
        }
    }
}

-(CGFloat)getImageRatioH{
    if (self.mConfig.rotate90Degree == Rotate90Degree_0 || self.mConfig.rotate90Degree == Rotate90Degree_180 || self.mConfig.rotate90Degree == Rotate90Degree_Neg_180) {
        return _image.size.width / _image.size.height;
    } else {
        return _image.size.height / _image.size.width;
    }
}

-(void)setFixedRatioCropBox{
    [self.mConfig calulateCropBoxFrame:self.initialCropBoxFrame byImageScale:[self getImageRatioH]];
    [self updateViewsWhenDoNewCrop:NO withCompleteBlock:^{
        self.mConfig.viewStatus = endAllOperation;
    }];
    [self adaptAngleWheelDialToCropBox];
}

- (void)setCroppingStyle:(CroppingStyle)croppingStyle{
    _croppingStyle = croppingStyle;
    if (_croppingStyle == SHAPE_STYLE) {
        self.mConfig.shapeType = CIRCLE_SHAPE;
        self.maskView.cropBoxFrame = self.mConfig.cropBoxFrame;
        self.maskView.shapeType = CIRCLE_SHAPE;
        [self resetCropButtonStatus:YES];
    }else{
        self.mConfig.shapeType = SQUARE_SHAPE;
        self.maskView.shapeType = SQUARE_SHAPE;
    }
}

-(void)resetCropButtonStatus:(BOOL)isCanCrop{
    if (_delegate && [_delegate respondsToSelector:@selector(cropViewDidBecomeCropable:canCropable:)]) {
        [_delegate cropViewDidBecomeCropable:self canCropable:isCanCrop];
    }
}

- (void)setCroppingShapeStyle:(ShapeType)shapeType{
    self.mConfig.shapeType = shapeType;
    self.maskView.cropBoxFrame = self.mConfig.cropBoxFrame;
    self.maskView.shapeType = shapeType;
    [self resetCropButtonStatus:YES];
}

-(UIImage*)crop{
    
    CGRect rect = [_imageView convertRect:_imageView.bounds toView:self];
    CGPoint point = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGPoint zeroPoint = _gridOverlayView.center;
    
    CGPoint translation =  CGPointMake((point.x - zeroPoint.x),(point.y - zeroPoint.y));
    
    CGFloat totalRadians = [_mConfig getCurrentRadians];
    
    CHWCropInfoModel* cropInfo = [[CHWCropInfoModel alloc] initWithTranslation:translation rotation:totalRadians scale:_scrollView.zoomScale cropSize:_gridOverlayView.frame.size imageViewSize:_imageView.bounds.size shapeType:self.mConfig.shapeType];
    return [self.image getCroppedImage:cropInfo];
}

#pragma mark handle touch event
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint touchPoint = [self convertPoint:point toView:self];
    
    if (_rotationWheelDial && CGRectContainsPoint(_rotationWheelDial.frame, point)) {
        return _rotationWheelDial;
    }
    
    if (CGRectContainsPoint(CGRectInset(_gridOverlayView.frame, -hotAreaUnit, -hotAreaUnit), touchPoint) && ! CGRectContainsPoint(CGRectInset(_gridOverlayView.frame, hotAreaUnit, hotAreaUnit), touchPoint)) {
        return self;
    }
    
    if (CGRectContainsPoint(self.bounds, touchPoint)) {
        return self.scrollView;
    }
    
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (touches.count!=1) {
        return;
    }
    UITouch* touch = [touches anyObject];
    if ([touch.view isMemberOfClass:[CHWWheelDial class]]) {
        self.mConfig.viewStatus = touchedRotationBoard;
        return;
    }
    
    CGPoint point = [touch locationInView:self];
    [self.mConfig prepareForCropByTouchPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (touches.count != 1) {
        return;
    }
    UITouch* touch = [touches anyObject];
    
    if ([touch.view isMemberOfClass:[CHWWheelDial class]]) {
        return;
    }
    
    CGPoint point = [touch locationInView:self];
    [self updateCropBoxFrame:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (touches.count != 1) {
        return;
    }
    UITouch* touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[CHWCropRotateView class]]) {
        if ([self.mConfig checkNeedCropOrNot]) {
            [self updateViewsWhenDoNewCrop:YES withCompleteBlock:^{
                self.mConfig.viewStatus = endAllOperation;
            }];
        } else {
            self.mConfig.viewStatus = endAllOperation;
        }
        return;
    }
    
    if ([touch.view isKindOfClass:[CHWScrollView class]]) {
        self.mConfig.viewStatus = endAllOperation;
        return;
    }
}

#pragma mark UIScrollViewDelegate methods
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
}
@end
