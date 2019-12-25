//
//  CHWUtils.h
//  画风
//
//  Created by Cherish on 19/12/26.
//  Copyright © 2019年 Cherish. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CHWUtils : NSObject


+(CHWUtils*)getInstance;
+(UIBezierPath*)getCirclePath:(CGRect)rect;

+(UIBezierPath*)getOvalPath:(CGRect)rect;

+(UIBezierPath*)getTrianglePath:(CGRect)rect;

#pragma make - HeartBezierPath
+(UIBezierPath*)getHexagonShapeBezierPath:(CGRect)rect;

+(UIBezierPath*)getHopHexagonShapeBezierPath:(CGRect)rect;

+(UIBezierPath*)getPolygonShapeBezierPath:(CGRect)overlayRect;

+(UIBezierPath*)getHeartPath:(CGRect)rect;

+(UIBezierPath*)getDiamondShapeBezierPath:(CGRect)rect;

+(UIBezierPath*)getStarShapeBezierPath:(CGRect)rect ;
+(UIBezierPath*)getCrossShapeBezierPath:(CGRect)rect;
+(UIBezierPath*)getArcRectBezierPath:(CGRect)rect;
+(UIBezierPath*)getSectorBezierPath:(CGRect)rect;
+ (UIBezierPath *)heartBezierPathWithToRect:(CGRect)rect;
+(UIBezierPath*)getHalfCirclePath:(CGRect)rect;
+(UIBezierPath*)getOctagonPath:(CGRect)rect numberOfSides:(int)numberOfSides;


+(CGMutablePathRef)getOvalCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getCircleCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getTriangleCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getHalfCircleCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getHopHexagonShapeBezierCGMutablePath:(CGRect)rect;
+ (CGMutablePathRef)getHeartCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getStarShapeCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getCrossShapeCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getArcRectCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getSectorCGMutablePath:(CGRect)rect;
+(CGMutablePathRef)getOctagonCGMutablePath:(CGRect)rect;
@end
