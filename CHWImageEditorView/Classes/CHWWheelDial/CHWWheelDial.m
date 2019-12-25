//
//  CHWWheelDial.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import "CHWWheelDial.h"
#import "CHWConfigModel.h"
#import "CHWAngle.h"
#import <CoreText/CoreText.h>

@interface CHWWheelPlate ()
@property(nonatomic)NSInteger bigDegreeScaleNumber;
@property(nonatomic)NSInteger smallDegreeScaleNumber;
@property(nonatomic,strong)CAReplicatorLayer* smallDotLayer;
@property(nonatomic,strong)CAReplicatorLayer* bigDotLayer;
@property(nonatomic,strong)CHWConfigModel* configModel;
@property(nonatomic)CGFloat margin;
@property(nonatomic)CGFloat spaceBetweenScaleAndNumber;
@end

@implementation CHWWheelPlate

- (instancetype)initWithFrame:(CGRect)frame withConfig:(CHWConfigModel*)configModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.configModel = configModel;
        self.margin = 0.0;
        self.spaceBetweenScaleAndNumber = 10.0;
        if (!configModel) {
            self.configModel = [CHWConfigModel new];
        }
        self.bigDegreeScaleNumber = 36;
        self.smallDegreeScaleNumber = _bigDegreeScaleNumber*5;
        [self setUpForWheelPlate];
    }
    return self;
}

-(void)setUpForWheelPlate{
    [self setupSmallScaleMarks];
    [self setupBigScaleMarks];
    [self setupAngleNumber];
    [self setCenterPart];
}

- (CAReplicatorLayer *)smallDotLayer{
    if (!_smallDotLayer) {
        self.smallDotLayer = [CAReplicatorLayer new];
        _smallDotLayer.instanceCount = _smallDegreeScaleNumber;
        _smallDotLayer.instanceTransform = CATransform3DMakeRotation(2 * M_PI / _smallDotLayer.instanceCount, 0, 0, 1);
    }
    return _smallDotLayer;
}

- (CAReplicatorLayer *)bigDotLayer{
    if (!_bigDotLayer) {
        self.bigDotLayer = [CAReplicatorLayer new];
        _bigDotLayer.instanceCount = _bigDegreeScaleNumber;
        _bigDotLayer.instanceTransform = CATransform3DMakeRotation(2 * M_PI / _bigDotLayer.instanceCount, 0, 0, 1);
    }
    return _bigDotLayer;
}

-(CALayer*)getSmallScaleMark{
    CAShapeLayer* mark = [CAShapeLayer new];
    mark.frame = CGRectMake(0,0,2,2);
    mark.path = [UIBezierPath bezierPathWithOvalInRect:mark.bounds].CGPath;
    mark.fillColor = _configModel.smallScaleColor.CGColor;
    return mark;
}

-(CALayer*)getBigScaleMark{
    CAShapeLayer* mark = [CAShapeLayer new];
    mark.frame = CGRectMake(0,0,4,4);
    mark.path = [UIBezierPath bezierPathWithOvalInRect:mark.bounds].CGPath;
    mark.fillColor = _configModel.bigScaleColor.CGColor;
    return mark;
}

-(void)setupAngleNumber{
    UIFont* numberFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)(numberFont.fontName), numberFont.pointSize/2, nil);
    CALayer* numberPlateLayer = [CALayer new];
    if (numberPlateLayer.sublayers.count>0) {
        for (CALayer* layer in numberPlateLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    numberPlateLayer.frame = self.bounds;
    [self.layer addSublayer:numberPlateLayer];
    
    CGPoint origin = CGPointMake(CGRectGetMidX(numberPlateLayer.frame),CGRectGetMidY(numberPlateLayer.frame));
    CGPoint startPos = CGPointMake(CGRectGetMidX(numberPlateLayer.bounds),CGRectGetMaxY(numberPlateLayer.bounds) - _margin - _spaceBetweenScaleAndNumber);
    CGFloat step = (2 * M_PI) / _bigDegreeScaleNumber;
    for (NSInteger i = 0; i < _bigDegreeScaleNumber; i++) {
        if ((i % _configModel.numberShowSpan) != 0) {
            continue;
        }
        
        
        CATextLayer* numberLayer = [CATextLayer new];
        numberLayer.bounds = CGRectMake(0, 0, 30, 15);
        numberLayer.fontSize = numberFont.pointSize;
        numberLayer.alignmentMode = kCAAlignmentCenter;
        numberLayer.contentsScale = [UIScreen mainScreen].scale;
        numberLayer.font = fontRef;
        long angle = (i > _bigDegreeScaleNumber / 2 ? i - _bigDegreeScaleNumber : i) * 10;
        numberLayer.string = [NSString stringWithFormat:@"%ld",angle];
        numberLayer.foregroundColor = _configModel.numberColor.CGColor;
        
        CGFloat stepChange = i * step;
        
        CGFloat dx = startPos.x-origin.x;
        CGFloat dy = startPos.y-origin.y;
        CGVector verctor1 = CGVectorMake(dx * cos(-stepChange) - dy * sin(-stepChange), dx * sin(-stepChange) + dy * cos(-stepChange));
        CGVector verctor2 = CGVectorMake(origin.x, origin.y);
        CGVector verctor = CGVectorMake(verctor1.dx + verctor2.dx ,verctor1.dy + verctor2.dy);
        numberLayer.position = CGPointMake(verctor.dx, verctor.dy);
        numberLayer.transform = CATransform3DMakeRotation(-stepChange, 0, 0, 1);
        [numberPlateLayer addSublayer:numberLayer];
    }
    
}

-(void)setupSmallScaleMarks{
    self.smallDotLayer.frame = self.bounds;
    if (_smallDotLayer.sublayers.count>0) {
        for (CALayer* layer in _smallDotLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    CALayer* smallScaleMark = [self getSmallScaleMark];
    smallScaleMark.position = CGPointMake(CGRectGetMidX(_smallDotLayer.bounds),_margin);
    [_smallDotLayer addSublayer:smallScaleMark];
    
    [self.layer addSublayer:_smallDotLayer];
}

-(void)setupBigScaleMarks{
    self.bigDotLayer.frame = self.bounds;
    if (_bigDotLayer.sublayers.count>0) {
        for (CALayer* layer in _bigDotLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
    
    
    CALayer* bigScaleMark = [self getBigScaleMark];
    bigScaleMark.position = CGPointMake(CGRectGetMidX(_bigDotLayer.bounds),_margin);
    [_bigDotLayer addSublayer:bigScaleMark];
    [self.layer addSublayer:_bigDotLayer];
}

-(void)setCenterPart{
    CAShapeLayer* layer = [CAShapeLayer new];
    CGFloat r = 4;
    layer.frame = CGRectMake((self.layer.bounds.size.width - r) / 2 ,(self.layer.bounds.size.height - r) / 2, r, r);
    layer.path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds].CGPath;
    layer.fillColor = _configModel.centerAxisColor.CGColor;
    [self.layer addSublayer:layer];
}
@end

@interface CHWWheelDial()
@property(nonatomic)CGFloat pointerHeight;
@property(nonatomic)CGFloat pointerWidth;
@property(nonatomic)CGFloat spanBetweenWheelPlateAndPointer;
@property(nonatomic,copy)void(^doRotateBlock)(CGFloat angle);
@property(nonatomic,strong)CHWConfigModel* configModel;
@property(nonatomic)CHWAngle* angleCanRotateMax;
@property(nonatomic)CGFloat canShowMaxRadians;
@property(nonatomic,strong)CHWWheelPlate* wheelPlate;
@property(nonatomic,strong)UIView* container;
@property(nonatomic,strong)CAShapeLayer* pointerLayer;
@property(nonatomic,copy)void(^DidFinishedRotate)(void);

@end

@implementation CHWWheelDial

- (void)dealloc
{
    [self.configModel removeObserver:self forKeyPath:@"rotationAngel" context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame withConfigModel:(CHWConfigModel*)configModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointerHeight = 8.0;
        self.pointerWidth = 8 * sqrt(2);
        self.spanBetweenWheelPlateAndPointer = 6.0;
        self.angleCanRotateMax = [[CHWAngle alloc] initWithRadians:M_PI];
        [self setupWithConfig:configModel];
    }
    return self;
}

-(void)setupWithConfig:(CHWConfigModel*)configModel{
    self.configModel = configModel;
    [self setUpViews];
    [self registerKYO];
}

-(void)setUpViews{
    if (_configModel.rotateLimitType == Yes_Rotate_Limit) {
        if (_configModel.maxRotateAngle) {
            self.angleCanRotateMax = _configModel.maxRotateAngle;
        }
    }
    self.clipsToBounds = YES;
    self.backgroundColor = _configModel.backgroundColor;
    self.container = [[UIView alloc] init];
    if (_configModel.wheelOrientation == Normal || _configModel.wheelOrientation == UpsideDown) {
        _container.frame = self.bounds;
    }else{
        _container.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    [self addSubview:_container];
    [self.container addSubview:self.wheelPlate];
    [self setUpPointer:_container];
    [self setWheelPlateFrameByOrientation:_configModel.wheelOrientation];
}

-(void)resetWheelDial{
    _wheelPlate.transform = CGAffineTransformIdentity;
}

-(void)registerKYO{
    [self.configModel addObserver:self forKeyPath:@"rotationAngel" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    CGPoint rotationCenter = [self getRotationCenter];
    [self.configModel createRotationCalculator:rotationCenter];
}

- (CHWWheelPlate *)wheelPlate{
    if (!_wheelPlate) {
        CGFloat margin = _configModel.margin;
        if (_configModel.showLimitType == Yes_Show_Limit) {
            margin = 0.0;
            _canShowMaxRadians = _configModel.maxShowAngle.radians;
        }else{
            _canShowMaxRadians = M_PI;
        }
        CGFloat wheelPlateShowHeight = CGRectGetHeight(self.container.frame)-margin-_pointerHeight - _spanBetweenWheelPlateAndPointer;
        CGFloat radius = wheelPlateShowHeight/(1 - cos(_canShowMaxRadians));
        
        if (radius * 2 * sin(_canShowMaxRadians) > CGRectGetWidth(self.container.frame)) {
            radius = (CGRectGetWidth(self.container.frame) / 2) / sin(_canShowMaxRadians);
            wheelPlateShowHeight = radius - radius * cos(_canShowMaxRadians);
        }
        
        CGFloat wheelPlateLength = 2 * radius;
        CGRect wheelPlateFrame = CGRectMake((CGRectGetWidth(self.container.frame) - wheelPlateLength) / 2, margin - (wheelPlateLength - wheelPlateShowHeight),wheelPlateLength,wheelPlateLength);
        
        self.wheelPlate = [[CHWWheelPlate alloc] initWithFrame:wheelPlateFrame withConfig:_configModel];
    }
    return _wheelPlate;
}

-(void)setUpPointer:(UIView*)container{
    if (!_wheelPlate) {
        return;
    }
    self.pointerLayer = [CAShapeLayer new];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat pointerEdgeLength = _pointerWidth;
    
    CGPoint pointTop = CGPointMake(container.bounds.size.width/2,CGRectGetMaxY(_wheelPlate.frame) + _spanBetweenWheelPlateAndPointer);
    CGPoint pointLeft = CGPointMake(container.bounds.size.width/2 - pointerEdgeLength / 2,pointTop.y + _pointerHeight);
    CGPoint pointRight = CGPointMake(container.bounds.size.width/2 + pointerEdgeLength / 2,pointLeft.y);
    
    CGPathMoveToPoint(path, NULL, pointTop.x, pointTop.y);
    CGPathAddLineToPoint(path, NULL, pointLeft.x, pointLeft.y);
    CGPathAddLineToPoint(path, NULL, pointRight.x, pointRight.y);
    CGPathAddLineToPoint(path, NULL, pointTop.x, pointTop.y);
  
    _pointerLayer.fillColor = _configModel.pointerColor.CGColor;
    _pointerLayer.path = path;
    [container.layer addSublayer:_pointerLayer];
}

-(void) setWheelPlateFrameByOrientation:(WheelOrientation)orientation {
    switch (orientation) {
        case Normal:
            
            break;
        case Left:
            _container.transform = CGAffineTransformMakeRotation(-M_PI_2);
            _container.frame= CGRectMake(0, 0, CGRectGetWidth(_container.frame), CGRectGetHeight(_container.frame));
            break;
        case Right:
            _container.transform = CGAffineTransformMakeRotation(M_PI_2);
            _container.frame= CGRectMake(0, 0, CGRectGetWidth(_container.frame), CGRectGetHeight(_container.frame));
            break;
        case UpsideDown:
            _container.transform = CGAffineTransformMakeRotation(M_PI);
            _container.frame= CGRectMake(0, 0, CGRectGetWidth(_container.frame), CGRectGetHeight(_container.frame));
            break;
            
        default:
            break;
    }
}

-(CGPoint) getRotationCenter{
    if (!_wheelPlate) {
        return CGPointZero;
    }
    if (_configModel.rotationCenterType == Custom_Center) {
        return _configModel.rotationCenterOfPoint;
    }else{
        CGPoint point = CGPointMake(CGRectGetMidX(_wheelPlate.bounds),CGRectGetMidY(_wheelPlate.bounds));
        return [_wheelPlate convertPoint:point toView:self];
    }
}

-(void)dideRotationByAngle:(CHWAngle*)angle {
    if (_configModel.rotateLimitType == Yes_Rotate_Limit) {
        if (angle.radians > _configModel.maxRotateAngle.radians) {
            return;
        }
    }
    
    if ([self rotateWheelPlateByAngle:angle]) {
        if (self.didRotateBlock) {
            self.didRotateBlock([self getRotationAngle]);
        }
    }
}

-(BOOL)rotateWheelPlateByAngle:(CHWAngle*)angle{
    if (!_wheelPlate) {
        return NO;
    }
    CGFloat radians = angle.radians;
    if (_configModel.rotateLimitType == Yes_Rotate_Limit) {
        if ([CHWAngle multiplyTwoAngel:[self getRotationAngle] withSecondAngel:angle].radians > 0 && fabs([self getRotationAngle].radians + radians) >= _angleCanRotateMax.radians) {
            
            if (radians > 0) {
                [self rotateWheelPlateToAngle:_angleCanRotateMax animated:NO];
            } else {
                [self rotateWheelPlateToAngle:[CHWAngle negativeAngel:_angleCanRotateMax] animated:NO];
            }
            return NO;
        }
    }
    _wheelPlate.transform = CGAffineTransformRotate(_wheelPlate.transform, radians);
    return YES;
}

-(void)rotateWheelPlateToAngle:(CHWAngle*)angle animated:(BOOL)animated {
    CGFloat radians = angle.radians;
    if (_configModel.rotateLimitType == Yes_Rotate_Limit) {
        if (fabs(radians) > _angleCanRotateMax.radians) {
            return;
        }
    }
    void (^rotateBlock)(void) = ^{
        self.wheelPlate.transform = CGAffineTransformMakeRotation(radians);
    };
    
    if (animated) {
        [UIView animateWithDuration:0.45 animations:^{
            rotateBlock();
        }];
    } else {
        rotateBlock();
    }
}

-(CHWAngle*)getRotationAngle{
    if (!_wheelPlate) {
        return [[CHWAngle alloc] initWithDegrees:0];
    }
    
    NSDecimalNumber* decimalb = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",_wheelPlate.transform.b]];
    
    NSDecimalNumber* decimala = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",_wheelPlate.transform.a]];
    
    float radians = atan2f(decimalb.floatValue, decimala.floatValue);
    return [[CHWAngle alloc] initWithRadians:radians];
}

-(void)resetAngle:(BOOL)animated {
    [self rotateWheelPlateToAngle:[[CHWAngle alloc] initWithRadians:0] animated:animated];
}

-(void)setRotationCenterByPoint:(CGPoint)point ofView:(UIView*)view {
    CGPoint p = [view convertPoint:point toView:self];
    _configModel.rotationCenterType = Custom_Center;
    _configModel.rotationCenterOfPoint = p;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rotationAngel"]) {
        CHWAngle* angle = [change objectForKey:NSKeyValueChangeNewKey];
        if (!angle) {
            return;
        }
        [self dideRotationByAngle:angle];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint p = [self convertPoint:point toView:self];
    
    if (CGRectContainsPoint(self.bounds, p)) {
        return self;
    }
    return nil;
}

-(void)handle:(NSSet<UITouch *> *)touches {
    if (touches.count == 1) {
        UITouch* touch = [touches anyObject];
        _configModel.touchPoint = [touch locationInView:self];
    }else{
        return;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self handle:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self handle:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.didFinishedRotateBlock) {
        self.didFinishedRotateBlock();
    }
    self.configModel.touchPoint = CGPointZero;
}
@end
