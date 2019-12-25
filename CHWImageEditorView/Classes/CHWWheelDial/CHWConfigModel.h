//
//  CHWConfigModel.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/8.
//

#import <Foundation/Foundation.h>
@class CHWAngle;
@class RotationCalculator;

typedef NS_ENUM(NSUInteger, WheelOrientation) {
    Normal,
    Right,
    Left,
    UpsideDown
};

typedef NS_ENUM(NSUInteger, AngleShowLimitType) {
    No_Show_Limit,
    Yes_Show_Limit
};

typedef NS_ENUM(NSUInteger, AngleRotateLimitType) {
    No_Rotate_Limit,
    Yes_Rotate_Limit
};

typedef NS_ENUM(NSUInteger, RotationCenterType) {
    Custom_Center = 1,
    Default_Center
};

typedef NS_ENUM(NSUInteger, WheelTheme) {
    Dark,
    Light
};

NS_ASSUME_NONNULL_BEGIN

@interface CHWConfigModel : NSObject
@property(nonatomic,strong)UIColor* backgroundColor;
@property(nonatomic,strong)UIColor* smallScaleColor;
@property(nonatomic,strong)UIColor* bigScaleColor;
@property(nonatomic,strong)UIColor* numberColor;
@property(nonatomic,strong)UIColor* indicatorColor;
@property(nonatomic,strong)UIColor* centerAxisColor;
@property(nonatomic)WheelOrientation wheelOrientation;
@property(nonatomic)CGFloat margin;
@property(nonatomic)AngleShowLimitType showLimitType;
@property(nonatomic)AngleRotateLimitType rotateLimitType;
@property(nonatomic,strong)CHWAngle* currentAngle;
@property(nonatomic,strong)CHWAngle* maxShowAngle;
@property(nonatomic,strong)CHWAngle* maxRotateAngle;
@property(nonatomic,strong)UIColor* pointerColor;
@property(nonatomic,strong)CHWAngle* rotationAngel;
@property(nonatomic)CGPoint touchPoint;
@property(nonatomic)RotationCenterType rotationCenterType;
@property(nonatomic)CGPoint rotationCenterOfPoint;
@property(nonatomic)NSInteger numberShowSpan;
@property(nonatomic)WheelTheme theme;
@property(nonatomic,strong)RotationCalculator* rotationCal;

-(void)createRotationCalculator:(CGPoint)midPoint;
@end

NS_ASSUME_NONNULL_END
