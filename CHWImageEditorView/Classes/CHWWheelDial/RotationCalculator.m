//
//  RotationCalculator.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import "RotationCalculator.h"

@interface RotationCalculator()
@property(nonatomic)CGPoint midPoint;
@property(nonatomic)CGFloat rotationAngle;
@property(nonatomic)CGPoint currentPoint;
@property(nonatomic)CGPoint previousPoint;
@property(nonatomic)CGFloat angle;
@property(nonatomic)CGFloat distance;
@end

@implementation RotationCalculator

- (instancetype)initMidPoint:(CGPoint)midPoint
{
    self = [super init];
    if (self) {
        self.midPoint = midPoint;
    }
    return self;
}

- (CGFloat)rotationAngle{
    CGFloat rotation = [self angleBetweenPoint:_currentPoint withPoint2:_previousPoint];
    if (rotation > M_PI) {
        rotation -= M_PI*2;
    }else if(rotation < -M_PI){
        rotation += M_PI * 2;
    }
    return rotation;
}

-(CGFloat)angleBetweenPoint:(CGPoint)point1 withPoint2:(CGPoint)point2{
    return [self angleForPoint:point1] - [self angleForPoint:point2];
}

-(CGFloat)angleForPoint:(CGPoint)point{
    NSDecimalNumber *deciNumX1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",point.x]];
    NSDecimalNumber *deciNumX2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",_midPoint.x]];
    NSDecimalNumber *deciNumX = [deciNumX1 decimalNumberBySubtracting:deciNumX2];
    float dx = deciNumX.floatValue;
    
    NSDecimalNumber *deciNumY1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",point.y]];
    NSDecimalNumber *deciNumY2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",_midPoint.y]];
    NSDecimalNumber *deciNumY = [deciNumY1 decimalNumberBySubtracting:deciNumY2];
    float dy = deciNumY.floatValue;
    
    CGFloat angle = -atan2f(dx, dy) + M_PI_2;
    
    if (angle < 0) {
        angle += M_PI * 2;
    }
    
    return angle;
}



-(CGFloat)distanceBetween:(CGPoint)pointA andPointB:(CGPoint)pointB{
    NSDecimalNumber *deciNumXA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pointA.x]];
    NSDecimalNumber *deciNumXB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pointB.x]];
    NSDecimalNumber *deciNumX = [deciNumXA decimalNumberBySubtracting:deciNumXB];
    float dx = deciNumX.floatValue;
    
    NSDecimalNumber *deciNumYA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pointA.y]];
    NSDecimalNumber *deciNumYB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pointB.y]];
    NSDecimalNumber *deciNumY = [deciNumYA decimalNumberBySubtracting:deciNumYB];
    float dy = deciNumY.floatValue;

    NSDecimalNumber * value = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sqrtf(dx*dx + dy*dy)]];
    return value.doubleValue;
}

- (CGFloat)angle{
    return [self angleForPoint:_currentPoint];
}

- (CGFloat)distance{
    return [self distanceBetween:_midPoint andPointB:_currentPoint];
}

-(CGFloat)getRotationRadiansByOldPoint:(CGPoint)p1 andNewPoint:(CGPoint)p2{
    self.previousPoint = p1;
    self.currentPoint = p2;
    return self.rotationAngle;
}
@end
