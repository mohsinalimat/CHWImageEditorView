//
//  CHWAngel.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import "CHWAngle.h"

@implementation CHWAngle

+(BOOL)isLessBetweenAngle:(CHWAngle*)lessAngle secondAngel:(CHWAngle*)secondAngle{
    return lessAngle.radians < secondAngle.radians;
}

+(CHWAngle*)addingTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle{
    return [[CHWAngle alloc] initWithRadians:firstAngle.radians+secondAngle.radians];
}

+(CHWAngle*)multiplyTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle{
    return [[CHWAngle alloc] initWithRadians:firstAngle.radians*secondAngle.radians];
}

+(CHWAngle*)subtractTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle{
    return [[CHWAngle alloc] initWithRadians:firstAngle.radians-secondAngle.radians];
}

+(CHWAngle*)divisionTwoAngel:(CHWAngle*)firstAngle withSecondAngel:(CHWAngle*)secondAngle{
    if (secondAngle.radians!=0.0) {
        return [[CHWAngle alloc] initWithRadians:firstAngle.radians/secondAngle.radians];
    }else{
        if (firstAngle.radians == 0.0) {
            return [[CHWAngle alloc] initWithRadians:0.0];
        }else{
            return [[CHWAngle alloc] initWithRadians:HUGE_VAL];
        }
    }
}

+(CHWAngle*)negativeAngel:(CHWAngle*)angle{
    return [[CHWAngle alloc] initWithRadians:-angle.radians];
}


- (instancetype)initWithRadians:(CGFloat)radians
{
    self = [super init];
    if (self) {
        self.radians = radians;
    }
    return self;
}

- (instancetype)initWithDegrees:(CGFloat)degrees
{
    self = [super init];
    if (self) {
        self.radians = degrees / 180.0 * M_PI;
    }
    return self;
}

- (CGFloat)degress{
    return _radians / M_PI * 180.0;
}

- (void)setDegress:(CGFloat)degress{
    _radians = degress / 180.0 * M_PI;
}
@end
