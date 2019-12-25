//
//  CHWMacroDefine.h
//  CropRotateView
//
//  Created by cherish on 2019/12/4.
//  Copyright © 2019 JackyHe. All rights reserved.
//

#ifndef CHWMacroDefine_h
#define CHWMacroDefine_h

static const CGFloat hotAreaUnit = 14.0;

typedef NS_ENUM(NSUInteger, CroppingStyle) {
    RATIO_STYLE,
    SHAPE_STYLE
};

typedef NS_ENUM(NSUInteger, CropRotateStatus) {
    NONE,
    SQUARE_CROP,
    SHAPE_CROP,
    ROTATE
};

typedef NS_ENUM(NSUInteger,MaskShowStatus) {
    MASK_DYNAMIC,
    MASK_STATIC
};

typedef NS_ENUM(NSUInteger, CropRotateOverlayEdge) {
    none,
    topLeft,
    top,
    topRight,
    right,
    bottomRight,
    bottom,
    bottomLeft,
    left
};

typedef NS_ENUM(NSInteger, Rotate90Degree) {// please do not use the NSUInteger
    Rotate90Degree_0 = 0,
    Rotate90Degree_90 = 90,
    Rotate90Degree_180 = 180,
    Rotate90Degree_270 = 270,
    Rotate90Degree_Neg_90_ = -90,
    Rotate90Degree_Neg_180 = -180,
    Rotate90Degree_Neg_270 = -270
};

typedef NS_ENUM(NSUInteger,CropRotateViewStatus) {
    initial,
    rotatieAngle,
    degree90Rotated,
    touchedImage,
    touchedRotationBoard,
    touchedCropbox,
    endAllOperation
};

typedef NS_ENUM(NSUInteger, SquareCropRatio) {
    SquareCropRatio_Origin,
    SquareCropRatio_Free,
    SquareCropRatio_1x1,
    SquareCropRatio_2x3,
    SquareCropRatio_3x2,
    SquareCropRatio_3x4,
    SquareCropRatio_4x3,
    SquareCropRatio_5x7,
    SquareCropRatio_7x5,
    SquareCropRatio_16x9,
    SquareCropRatio_9x16
};

typedef NS_ENUM(NSUInteger, ShapeType) {
    SQUARE_SHAPE,
    CIRCLE_SHAPE,
    OVAL_SHAPE,
    TRIANGLE_SHAPE,
    HEART_SHAPE,
    HEXAGON_SHAPE,
    STAR_SHAPE,
    ARC_SHAPE,
    CROSS_SHAPE,
    SECTOR_SHAPE,
    HALF_CIRCLE_SHAPE,
    OCTAGON_SHAPE,
};

#define Bottom_Bar_Text_Font   [UIFont boldSystemFontOfSize:14.0]
#define Default_White_Color        COLOR_RGB(255,255,255)

#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
isPhoneX = YES;\
}\
}\
isPhoneX;\
})

#define AdaptNaviHeight      (isIphoneX ? 24 : 0) //状态栏高度

#define AdaptTabHeight       (isIphoneX ? 34 : 0) //Tab bar 圆角部分高度

#define NAVIHEIGHT           (isIphoneX ? 88 : 64) //导航

#define TABBARHEIGHT         (isIphoneX ? 83 : 49) // 分栏

#define Highlighted_Color  COLOR_RGB(254, 88, 77)

#define COLOR_RGB(R,G,B)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define COLOR_RGB_ALPHA(R,G,B,A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#endif /* CHWMacroDefine_h */
