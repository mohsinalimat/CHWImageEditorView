//
//  CHWConfigModel.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import "CHWConfigModel.h"
#import "CHWAngle.h"
#import "RotationCalculator.h"

@interface CHWConfigModel()
@end

@implementation CHWConfigModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rotationAngel = [[CHWAngle alloc] initWithRadians:0];
        self.numberShowSpan = 2;
        self.backgroundColor = [UIColor blackColor];
        self.bigScaleColor = [UIColor lightGrayColor];
        self.smallScaleColor = [UIColor lightGrayColor];
        self.indicatorColor = [UIColor lightGrayColor];
        self.centerAxisColor = [UIColor lightGrayColor];
        self.numberColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setTouchPoint:(CGPoint)touchPoint{
    CGPoint oldPoint = self.touchPoint;
    CGPoint newPoint = touchPoint;
    _touchPoint = touchPoint;
    if (CGPointEqualToPoint(oldPoint, CGPointZero)) {
        return;
    }
    if (CGPointEqualToPoint(newPoint, CGPointZero)) {
        return;
    }
    
    if (_rotationCal) {
        CGFloat radians = [_rotationCal  getRotationRadiansByOldPoint:oldPoint andNewPoint:newPoint];
        self.rotationAngel = [[CHWAngle alloc] initWithRadians:radians];
    }
}

-(void)createRotationCalculator:(CGPoint)midPoint{
    if (!_rotationCal) {
        self.rotationCal = [[RotationCalculator alloc] initMidPoint:midPoint];
    }
}

- (void)setTheme:(WheelTheme)theme{
    _theme = theme;
    switch (_theme) {
        case Dark:
            _backgroundColor = [UIColor blackColor];
            _bigScaleColor = [UIColor lightGrayColor];
            _smallScaleColor = [UIColor lightGrayColor];
            _indicatorColor = [UIColor lightGrayColor];
            _numberColor = [UIColor lightGrayColor];
            _centerAxisColor = [UIColor lightGrayColor];
            break;
        case Light:
            _backgroundColor = [UIColor whiteColor];
            _bigScaleColor = [UIColor darkGrayColor];
            _smallScaleColor = [UIColor darkGrayColor];
            _indicatorColor = [UIColor darkGrayColor];
            _numberColor = [UIColor darkGrayColor];
            _centerAxisColor = [UIColor darkGrayColor];
            break;
        default:
            break;
    }
}
@end
