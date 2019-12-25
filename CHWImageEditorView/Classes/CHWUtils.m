//
//  CHWUtils.m
//  画风
//
//  Created by Cherish on 16/12/26.
//  Copyright © 2016年 Cherish. All rights reserved.
//

#import "CHWUtils.h"

@implementation CHWUtils

+(CHWUtils*)getInstance{
    static CHWUtils* utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[CHWUtils alloc] init];
    });
    return utils;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(UIBezierPath*)getOvalPath:(CGRect)rect{
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

+(CGMutablePathRef)getOvalCGMutablePath:(CGRect)rect{
    UIBezierPath* path = [CHWUtils getOvalPath:rect];
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path1, &tr, path.CGPath);
    return path1;
}

+(UIBezierPath*)getCirclePath:(CGRect)rect{
    CGFloat minValue = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)) radius:minValue/2.0 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    return path;
}

+(CGMutablePathRef)getCircleCGMutablePath:(CGRect)rect{
    CGFloat minValue = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = minValue/2.0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, 0.0, M_PI*2, YES);
    return path;
}

+(UIBezierPath*)getTrianglePath:(CGRect)rect{
    CGRect frame = rect;
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(frame.origin.x+CGRectGetWidth(frame)*0.5, frame.origin.y)];
    [path addLineToPoint:CGPointMake(frame.origin.x+CGRectGetWidth(frame), frame.origin.y+CGRectGetHeight(frame))];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y+CGRectGetHeight(frame))];
    [path closePath];
    return path;
}

+(CGMutablePathRef)getTriangleCGMutablePath:(CGRect)rect{
    CGRect frame = rect;
    CGPoint firstPoint = CGPointMake(frame.origin.x+CGRectGetWidth(frame)*0.5, frame.origin.y+CGRectGetHeight(frame));
    CGPoint secPoint = CGPointMake(frame.origin.x+CGRectGetWidth(frame), frame.origin.y);
    CGPoint thirdPoint = CGPointMake(frame.origin.x, frame.origin.y);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, NULL, secPoint.x, secPoint.y);
    CGPathAddLineToPoint(path, NULL, thirdPoint.x, thirdPoint.y);
    CGPathCloseSubpath(path);
    return path;
}

+(UIBezierPath*)getHopHexagonShapeBezierPath:(CGRect)rect{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width/4.0, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width*3/4.0, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y+rect.size.height/2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width*3/4.0, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/4.0, rect.origin.y)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path closePath];
    return path;
}


+(CGMutablePathRef)getHopHexagonShapeBezierCGMutablePath:(CGRect)rect{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y+rect.size.height/2.0);
    CGPathAddLineToPoint(path, NULL, rect.origin.x+rect.size.width/4.0, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width*3/4.0, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y+rect.size.height/2.0);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width*3/4.0, rect.origin.y);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width/4.0, rect.origin.y);
    CGPathCloseSubpath(path);
    return path;
}

+(UIBezierPath*)getPolygonShapeBezierPath:(CGRect)overlayRect{
    CGFloat minValue = MIN(CGRectGetWidth(overlayRect), CGRectGetHeight(overlayRect));
    CGRect rect = CGRectMake((CGRectGetWidth(overlayRect)-minValue)*0.5, (CGRectGetHeight(overlayRect)-minValue)*0.5, minValue, minValue);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x+rect.size.width/2.0, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width/2.0 + rect.size.width*cos(3*M_PI/8.0)*sin(3*M_PI/8.0), rect.origin.y + rect.size.height*cos(3*M_PI/8.0)*cos(3*M_PI/8.0))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width/2.0 + rect.size.width*cos(3*M_PI/8.0)*sin(3*M_PI/8.0), rect.origin.y + rect.size.height/2.0 + rect.size.height*cos(3*M_PI/8.0)*sin(3*M_PI/8.0))];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y+rect.size.width)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width*cos(3*M_PI/8.0)*cos(3*M_PI/8.0), rect.origin.y + rect.size.height/2.0 + rect.size.height*cos(3*M_PI/8.0)*sin(3*M_PI/8.0))];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.width/2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width*cos(3*M_PI/8.0)*cos(3*M_PI/8.0), rect.origin.y + rect.size.height*cos(3*M_PI/8.0)*cos(3*M_PI/8.0))];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path closePath];
    return path;
}

+ (UIBezierPath *)heartBezierPathWithToRect:(CGRect)rect{
    NSInteger spaceWidth = 0;
    
    NSInteger topSpaceWidth = 0;
    
    CGFloat radius;//半径
    
    CGPoint leftPoint;//最左侧的点
    
    CGPoint leftCenter;//左侧圆心
    
    CGPoint rightCenter;//右侧圆心
    
    CGPoint bottomVertices;//底部顶点
    
    CGPoint rightControlPoint;//右边曲线控制点
    
    CGPoint leftControlPoint;//左边曲线控制点
    
    if (CGRectEqualToRect(rect, CGRectZero)) {//当rect为CGRectZero的时候，基于[UIScreen mainScreen].bounds上在你希望的位置画出bezierPath
        
        //半径
        radius = (rect.size.width-spaceWidth*2)/4;
        
        //最左侧的点
        leftPoint = CGPointMake(spaceWidth, spaceWidth+radius+topSpaceWidth);
        
        //左侧圆心 位于左侧边距＋半径宽度
        leftCenter = CGPointMake(spaceWidth+radius, spaceWidth+radius+topSpaceWidth);
        
        //右侧圆心 位于左侧圆心的右侧 距离为两倍半径
        rightCenter = CGPointMake(spaceWidth+radius*3, spaceWidth+radius+topSpaceWidth);
        
        //底部顶点
        bottomVertices = CGPointMake(rect.size.width/2,radius*4+topSpaceWidth+spaceWidth);
        
        //右边曲线控制点
        rightControlPoint = CGPointMake(rect.size.width-spaceWidth, radius*4*0.55+topSpaceWidth+spaceWidth);
        
        //左边曲线控制点
        leftControlPoint = CGPointMake(spaceWidth, radius*4*0.55+topSpaceWidth+spaceWidth);
        
    }else{//rect不为CGRectZero时
        
        //上部分的两半圆半径
        radius = rect.size.width/4;
        //最左点，x=0+rect.origin.x   y = radius + rect.origin.y
        leftPoint = CGPointMake(rect.origin.x,radius+rect.origin.y);
        
        leftCenter = CGPointMake((radius+rect.origin.x), (radius+rect.origin.y));
        
        rightCenter = CGPointMake((radius*3+rect.origin.x), (radius+rect.origin.y));
        
        bottomVertices = CGPointMake((rect.size.width/2+rect.origin.x),(rect.size.height+rect.origin.y));
        
        rightControlPoint = CGPointMake(rect.size.width+rect.origin.x,rect.origin.y+rect.size.height*0.55);
        
        leftControlPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height*0.55);
    }
    
    //左侧半圆
    UIBezierPath *heartLine = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //右侧半圆
    [heartLine addArcWithCenter:rightCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //曲线连接到底部顶点
    [heartLine addQuadCurveToPoint:bottomVertices controlPoint:rightControlPoint];
    
    //用曲线 底部的顶点连接到左侧半圆的左起点
    [heartLine addQuadCurveToPoint:leftPoint controlPoint:leftControlPoint];
    
    [heartLine setLineCapStyle:kCGLineCapRound];
    
    return heartLine;
}


+ (CGMutablePathRef)getHeartCGMutablePath:(CGRect)rect{
    CGFloat radius;//半径
    
    CGPoint leftPoint;//最左侧的点
    
    CGPoint leftCenter;//左侧圆心
    
    CGPoint rightCenter;//右侧圆心
    
    CGPoint bottomVertices;//底部顶点
    
    CGPoint rightControlPoint;//右边曲线控制点
    
    CGPoint leftControlPoint;//左边曲线控制点
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //上部分的两半圆半径
    radius = rect.size.width/4;
    //最左点，x=0+rect.origin.x   y = radius + rect.origin.y
    leftPoint = CGPointMake(rect.origin.x,radius+rect.origin.y);
    
    leftCenter = CGPointMake((radius+rect.origin.x), (radius+rect.origin.y));
    
    rightCenter = CGPointMake((radius*3+rect.origin.x), (radius+rect.origin.y));
    
    bottomVertices = CGPointMake((rect.size.width/2+rect.origin.x),(rect.size.height+rect.origin.y));
    
    rightControlPoint = CGPointMake(rect.size.width+rect.origin.x,rect.origin.y+rect.size.height*0.55);
    
    leftControlPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height*0.55);
    
    //左侧半圆
    CGPathAddArc(path, NULL, leftCenter.x, leftCenter.y, radius, M_PI, 0, NO);
    
    
    //右侧半圆
     CGPathAddArc(path, NULL, rightCenter.x, rightCenter.y, radius, M_PI, 0, NO);
    
    //曲线连接到底部顶点
    CGPathAddQuadCurveToPoint(path, NULL, rightControlPoint.x, rightControlPoint.y, bottomVertices.x, bottomVertices.y);
    
//    CGPathAddLineToPoint(path, NULL, bottomVertices.x, bottomVertices.y);
//    CGPathAddLineToPoint(path, NULL, leftPoint.x, leftPoint.y);

    //用曲线 底部的顶点连接到左侧半圆的左起点
    CGPathAddQuadCurveToPoint(path, NULL, leftControlPoint.x, leftControlPoint.y, leftPoint.x, leftPoint.y);
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path1, &tr, path);
    return path1;
}

+(UIBezierPath*)getHeartPath:(CGRect)rect{
    CGRect originalFrame = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGRect frame = originalFrame;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.49986 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.24129 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.64732 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05022 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.55044 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11201 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33067 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.06393 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.46023 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14682 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.39785 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08864 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.25304 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05011 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.30516 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05454 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.27896 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04999 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00841 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36081 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.12805 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.05067 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.00977 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15998 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.29627 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70379 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.00709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55420 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.18069 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62648 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50061 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.92498 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40835 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77876 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.48812 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88133 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.70195 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70407 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50990 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88158 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59821 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.77912 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.99177 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.35870 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.81539 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62200 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.99308 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.55208 * CGRectGetHeight(frame))];
    [bezierPath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.74182 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04948 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.99040 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.15672 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86824 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.04848 * CGRectGetHeight(frame))];
    [bezierPath closePath];
    bezierPath.miterLimit = 4;
    
    return bezierPath;
}

+(UIBezierPath*)getDiamondShapeBezierPath:(CGRect)rect{
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height/2.0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0)];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path closePath];
    return path;
}

+(UIBezierPath*)getStarShapeBezierPath:(CGRect)rect {
    CGFloat viewWidth = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    UIBezierPath *star = [UIBezierPath bezierPath];
    //确定中心点
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(rect)/2+CGRectGetMinX(rect), CGRectGetHeight(rect)/2+CGRectGetMinY(rect));
    //确定半径
    CGFloat bigRadius = viewWidth/2;
    CGFloat smallRadius = bigRadius * sin(2*M_PI/20) / cos(2*M_PI/10);
    //起始点
    CGPoint start=CGPointMake(centerPoint.x, centerPoint.y-bigRadius);
    [star moveToPoint:start];
    
    
    //五角星每个顶角与圆心连线的夹角 2π/5，
    CGFloat angle=2*M_PI/5.0;
    for (int i=1; i<=10; i++) {
        CGFloat x;
        CGFloat y;
        NSInteger c = i/2;
        if (i%2 == 0) {
            x=centerPoint.x-sinf(c*angle)*bigRadius;
            y=centerPoint.y-cosf(c*angle)*bigRadius;
        } else {
            x=centerPoint.x-sinf(c*angle + angle/2)*smallRadius;
            y=centerPoint.y-cosf(c*angle + angle/2)*smallRadius;
        }
        [star addLineToPoint:CGPointMake(x, y)];
    }
    
    //连接点
    star.lineJoinStyle = kCGLineJoinRound;
    return star;
}


+(CGMutablePathRef)getStarShapeCGMutablePath:(CGRect)rect {
    UIBezierPath* bezierPath  = [CHWUtils getStarShapeBezierPath:rect];
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path, &tr, bezierPath.CGPath);
    return path;
}

+(UIBezierPath*)getCrossShapeBezierPath:(CGRect)rect{
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(CGRectGetWidth(rect)/3+x, 0+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)*2/3+x, 0+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)/3+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)+x,CGRectGetHeight(rect)/3+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)+x, CGRectGetHeight(rect)*2/3+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)*2/3+y)];
   [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)*2/3+y)];
    [path1 addLineToPoint:CGPointMake(0+x, CGRectGetHeight(rect)*2/3+y)];
    [path1 addLineToPoint:CGPointMake(0+x, CGRectGetHeight(rect)/3+y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)/3+y)];
    [path1 closePath];
    return path1;
}

+(CGMutablePathRef)getCrossShapeCGMutablePath:(CGRect)rect{
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetWidth(rect)/3+x, y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)*2/3+x, y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)/3+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)+x, CGRectGetHeight(rect)/3+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)+x, CGRectGetHeight(rect)*2/3+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)*2/3+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)*2/3+x, CGRectGetHeight(rect)+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)*2/3+y);
    CGPathAddLineToPoint(path, NULL, x, CGRectGetHeight(rect)*2/3+y);
    CGPathAddLineToPoint(path, NULL, x, CGRectGetHeight(rect)/3+y);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect)/3+x, CGRectGetHeight(rect)/3+y);
    CGPathCloseSubpath(path);
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path1, &tr, path);
    CGPathRelease(path);
    return path1;
}

+(UIBezierPath*)getArcRectBezierPath:(CGRect)rect{
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+CGRectGetHeight(rect)/3.0)];
    [path1 addQuadCurveToPoint:CGPointMake(CGRectGetWidth(rect)+rect.origin.x, CGRectGetHeight(rect)/3.0+rect.origin.y) controlPoint:CGPointMake(rect.origin.x+CGRectGetWidth(rect)/2.0, -CGRectGetHeight(rect)/3.0+rect.origin.y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)+rect.origin.x, CGRectGetHeight(rect)+rect.origin.y)];
    [path1 addLineToPoint:CGPointMake(rect.origin.x,CGRectGetHeight(rect)+rect.origin.y)];
    [path1 closePath];
    return path1;
}

+(CGMutablePathRef)getArcRectCGMutablePath:(CGRect)rect{
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+CGRectGetHeight(rect)/3.0)];
    [path1 addQuadCurveToPoint:CGPointMake(CGRectGetWidth(rect)+rect.origin.x, CGRectGetHeight(rect)/3.0+rect.origin.y) controlPoint:CGPointMake(rect.origin.x+CGRectGetWidth(rect)/2.0, -CGRectGetHeight(rect)/3.0+rect.origin.y)];
    [path1 addLineToPoint:CGPointMake(CGRectGetWidth(rect)+rect.origin.x, CGRectGetHeight(rect)+rect.origin.y)];
    [path1 addLineToPoint:CGPointMake(rect.origin.x,CGRectGetHeight(rect)+rect.origin.y)];
    [path1 closePath];
    CGMutablePathRef path = CGPathCreateMutable();
     CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path, &tr, path1.CGPath);
    return path;
}

+(UIBezierPath*)getSectorBezierPath:(CGRect)rect{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat radius = -1;
    CGPoint center = CGPointZero;
    if (width>=height) {
        if (height>=width/2.0) {
            radius = width/(2.0*sin(M_PI_4));
            center = CGPointMake(CGRectGetMidX(rect),CGRectGetMinY(rect)+radius);
        }else{
            radius = height/sin(M_PI_4);
            center = CGPointMake(CGRectGetMidX(rect),CGRectGetMinY(rect)+radius);
        }
        
    }else{
        radius = width/(2.0*sin(M_PI_4));
        center = CGPointMake(CGRectGetMidX(rect),CGRectGetMinY(rect)+radius);
    }
    
    CGFloat angle = M_PI_4;
    CGFloat startAngle = angle;
    CGFloat endAngle = M_PI-angle;
    
    
    
    CGPoint center2 = center;
    CGFloat radius2 = radius/2.0;
    
    CGFloat xValue = radius2/sin(M_PI_4);
    
    
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 addArcWithCenter:center radius:radius startAngle:startAngle+M_PI endAngle:endAngle+M_PI clockwise:YES];
    [path1 addLineToPoint:CGPointMake(center.x+xValue, center.y-xValue)];
    [path1 addArcWithCenter:center2 radius:radius2 startAngle:endAngle+M_PI endAngle:startAngle+M_PI clockwise:NO];
    [path1 closePath];
//    [path1 addLineToPoint:CGPointMake(center.x-2*xValue, center.y-2*xValue)];
    
    return path1;
}

+(CGMutablePathRef)getSectorCGMutablePath:(CGRect)rect{
    UIBezierPath* path1 = [CHWUtils getSectorBezierPath:rect];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path, &tr, path1.CGPath);
    return path;
}

+(UIBezierPath*)getHalfCirclePath:(CGRect)rect{
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2;
    [path1 addArcWithCenter:center radius:radius startAngle: M_PI endAngle:2*M_PI clockwise:YES];
    [path1 closePath];
    return path1;
}

+(CGMutablePathRef)getHalfCircleCGMutablePath:(CGRect)rect{
    //    UIBezierPath* path1 = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2;
    //    [path1 addArcWithCenter:center radius:radius startAngle: M_PI endAngle:2*M_PI clockwise:YES];
    //    [path1 closePath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, center.x, center.y, radius, M_PI, 2*M_PI, YES);
    return path;
}

+(UIBezierPath*)getOctagonPath:(CGRect)rect numberOfSides:(int)numberOfSides{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width/8+x, 0+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width*7/8+x, 0+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width+x, height/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width+x, height*7/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width*7/8+x, height+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width/8+x, height+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(0+x, height*7/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(0+x, height/8+y)]];

    UIBezierPath* path = [UIBezierPath bezierPath];
    for(NSValue * point in result)
    {
        CGPoint val = [point CGPointValue];
        if([result indexOfObject:point] == 0 ){
            [path moveToPoint:CGPointMake(val.x, val.y)];
        }else{
            [path addLineToPoint:CGPointMake(val.x, val.y)];
        }
    }
    [path closePath];
    
    return path;
}


+(CGMutablePathRef)getOctagonCGMutablePath:(CGRect)rect{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat x = CGRectGetMinX(rect);
    CGFloat y = CGRectGetMinY(rect);
    
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width/8+x, y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width*7/8+x, y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width+x, height/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width+x, height*7/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width*7/8+x, height+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(width/8+x, height+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(0+x, height*7/8+y)]];
    [result addObject:[NSValue valueWithCGPoint:CGPointMake(0+x, height/8+y)]];
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    for(NSValue * point in result)
    {
        CGPoint val = [point CGPointValue];
        if([result indexOfObject:point] == 0 ){
            [path moveToPoint:CGPointMake(val.x, val.y)];
        }else{
            [path addLineToPoint:CGPointMake(val.x, val.y)];
        }
    }
    [path closePath];
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformTranslate(CGAffineTransformMakeRotation(M_PI), -rect.size.width, -rect.size.height);
    CGPathAddPath(path1, &tr, path.CGPath);
    return path1;
}

@end
