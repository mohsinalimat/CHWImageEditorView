//
//  CHWShapeView.m
//  画风
//
//  Created by Cherish on 2019/3/16.
//  Copyright © 2019 Cherish. All rights reserved.
//

#import "CHWShapeView.h"
#import "CHWUtils.h"

@interface CHWShapeView()
@property(nonatomic)ShapeType shapeType;
@end

@implementation CHWShapeView

- (instancetype)initWithShape:(ShapeType)shapeType{
    self = [super init];
    if (self) {
        self.shapeType = shapeType;
    }
    return self;
}

-(void)setColor:(UIColor *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, self.color.CGColor);
    CGContextSetShouldAntialias(currentContext, YES);
    UIBezierPath* path = nil;
    CGRect contentRect = CGRectInset(self.frame, 4, 4);
    if (self.shapeType == CIRCLE_SHAPE) {
        path = [CHWUtils getCirclePath:contentRect];
    }else if (self.shapeType == OVAL_SHAPE){
        path = [CHWUtils getOvalPath:CGRectMake(4, 4+CGRectGetHeight(contentRect)/4, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)*2/4)];
    }else if (self.shapeType == TRIANGLE_SHAPE){
        path = [CHWUtils getTrianglePath:contentRect];
    }else if (self.shapeType == HEART_SHAPE){
        path = [CHWUtils heartBezierPathWithToRect:contentRect];
    }else if (self.shapeType == HEXAGON_SHAPE){
        path = [CHWUtils getHopHexagonShapeBezierPath:contentRect];
    }else if (self.shapeType == STAR_SHAPE){
        path = [CHWUtils getStarShapeBezierPath:contentRect];
    }else if (self.shapeType == ARC_SHAPE){
        path = [CHWUtils getArcRectBezierPath:contentRect];
    }else if (self.shapeType == CROSS_SHAPE){
        path = [CHWUtils getCrossShapeBezierPath:contentRect];
    }else if (self.shapeType == SECTOR_SHAPE){
        path = [CHWUtils getSectorBezierPath:contentRect];
    }else if (self.shapeType == HALF_CIRCLE_SHAPE){
        path = [CHWUtils getHalfCirclePath:contentRect];
    }else if (self.shapeType == OCTAGON_SHAPE){
        path = [CHWUtils getOctagonPath:contentRect numberOfSides:8];
    }
    [path stroke];
}
@end
