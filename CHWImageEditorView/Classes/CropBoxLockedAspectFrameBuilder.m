//
//  CropBoxLockedAspectFrameBuilder.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/10.
//

#import "CropBoxLockedAspectFrameBuilder.h"

@interface CropBoxLockedAspectFrameBuilder()
@property(nonatomic)CGRect contentFrame;
@property(nonatomic)CGRect cropOriginFrame;
@property(nonatomic)CropRotateOverlayEdge touchedEdge;
@end

@implementation CropBoxLockedAspectFrameBuilder

- (instancetype)initTouchedEdge:(CropRotateOverlayEdge)touchedEdge withContentFrame:(CGRect)contentFrame withCropOriginFrame:(CGRect)cropOriginFrame withCropBoxFrame:(CGRect)cropBoxFrame
{
    self = [super init];
    if (self) {
        self.touchedEdge = touchedEdge;
        self.contentFrame = contentFrame;
        self.cropBoxFrame = cropBoxFrame;
        self.cropOriginFrame = cropOriginFrame;
    }
    return self;
}

-(void)updateCropBoxFrame:(CGFloat)xDelta withYDelta:(CGFloat)yDelta {
    CGFloat aspectRatio = (_cropOriginFrame.size.width / _cropOriginFrame.size.height);
    
    void(^UpdateHeightFromBothSides)(void) = ^{
        CGFloat  height = self.cropBoxFrame.size.width / aspectRatio;
        CGFloat y = CGRectGetMidY(self.cropOriginFrame) - (CGRectGetHeight(self.cropBoxFrame) * 0.5);
        self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, y, self.cropBoxFrame.size.width, height);
    };
    
    void(^UpdateWidthFromBothSides)(void) = ^{
        CGFloat width = self.cropBoxFrame.size.height * aspectRatio;
        CGFloat x = CGRectGetMidX(self.cropOriginFrame) - CGRectGetWidth(self.cropBoxFrame) * 0.5;
        self.cropBoxFrame = CGRectMake(x, self.cropBoxFrame.origin.y, width, self.cropBoxFrame.size.height);
    };
    
    void(^HandleLeftEdgeFrameUpdate)(void) = ^{
        UpdateHeightFromBothSides();
        if (xDelta < 0) {
            CGFloat x = self.cropOriginFrame.origin.x;
            CGFloat width = CGRectGetWidth(self.cropOriginFrame);
            self.cropBoxFrame = CGRectMake(x, self.cropOriginFrame.origin.y, width, self.cropBoxFrame.size.height);
        }else{
            CGFloat x = self.cropOriginFrame.origin.x + xDelta;
            CGFloat width = CGRectGetWidth(self.cropOriginFrame) - xDelta;
            self.cropBoxFrame = CGRectMake(x, self.cropOriginFrame.origin.y, width, self.cropBoxFrame.size.height);
        }
    };
    
    void(^HandleRightEdgeFrameUpdate)(void) = ^{
        UpdateHeightFromBothSides();
        CGFloat width = MIN(CGRectGetWidth(self.cropOriginFrame)+xDelta, CGRectGetHeight(self.contentFrame)*aspectRatio);
        self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, self.cropBoxFrame.origin.y, width, CGRectGetHeight(self.cropBoxFrame));
    };
    
    void(^HandleTopEdgeFrameUpdate)(void) = ^{
        UpdateWidthFromBothSides();
        if (yDelta < 0) {
            CGFloat y = self.cropOriginFrame.origin.y;
            CGFloat height = CGRectGetHeight(self.cropOriginFrame);
            self.cropBoxFrame = CGRectMake(self.cropOriginFrame.origin.x, y, CGRectGetWidth(self.cropBoxFrame), height);
        }else{
            CGFloat y = self.cropOriginFrame.origin.y + yDelta;
            CGFloat height = CGRectGetHeight(self.cropOriginFrame) - yDelta;
            self.cropBoxFrame = CGRectMake(self.cropOriginFrame.origin.x, y, CGRectGetWidth(self.cropBoxFrame), height);
        }
    };
    
    void(^HandleBottomEdgeFrameUpdate)(void) = ^{
        UpdateWidthFromBothSides();
        CGFloat height = MIN(CGRectGetHeight(self.cropOriginFrame) + yDelta, CGRectGetWidth(self.contentFrame) / aspectRatio);
        self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, self.cropBoxFrame.origin.y, self.cropBoxFrame.size.width, height);
    };
    void(^SetCropBoxSize)(CGFloat,CGFloat) = ^(CGFloat x,CGFloat y){
        CGFloat myXDelta = -1;
        CGFloat myYDelta = -1;
        switch (self.touchedEdge) {
            case topLeft:
                myXDelta = x;
                myYDelta = y;
                break;
            case topRight:
                myXDelta = -x;
                myYDelta = y;
                break;
            case bottomLeft:
                myXDelta = x;
                myYDelta = -y;
                break;
            case bottomRight:
                myXDelta = -x;
                myYDelta = -y;
                break;
            default:
                break;
        }
        
        CGFloat x1 = 1.0 - (myXDelta / CGRectGetWidth(self.cropOriginFrame));
        CGFloat y1 = 1.0 - (myYDelta / CGRectGetHeight(self.cropOriginFrame));
        CGPoint distance = CGPointMake(x1, y1);
        CGFloat scale = (distance.x + distance.y) * 0.5;
        CGFloat width = ceil(CGRectGetWidth(self.cropOriginFrame)* scale);
        CGFloat height = ceil(CGRectGetHeight(self.cropOriginFrame)* scale);
        self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, self.cropBoxFrame.origin.y, width, height);
    };
    
    void(^HandleTopLeftEdgeFrameUpdate)(void) = ^{
        CGFloat x = MAX(0, xDelta);
        CGFloat y = MAX(0, yDelta);
        SetCropBoxSize(x,y);
        CGFloat x1 = self.cropOriginFrame.origin.x + (CGRectGetWidth(self.cropOriginFrame) - CGRectGetWidth(self.cropBoxFrame));
        CGFloat y1 = self.cropOriginFrame.origin.y + (CGRectGetHeight(self.cropOriginFrame) - CGRectGetHeight(self.cropBoxFrame));
        self.cropBoxFrame = CGRectMake(x1, y1, CGRectGetWidth(self.cropBoxFrame), CGRectGetHeight(self.cropBoxFrame));
    };
    
    void(^HandleTopRightEdgeFrameUpdate)(void) = ^{
        CGFloat x = MAX(0, xDelta);
        CGFloat y = MAX(0, yDelta);
        SetCropBoxSize(x,y);
        CGFloat y1 = self.cropOriginFrame.origin.y + (CGRectGetHeight(self.cropOriginFrame) - CGRectGetHeight(self.cropBoxFrame));
        self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, y1, CGRectGetWidth(self.cropBoxFrame), CGRectGetHeight(self.cropBoxFrame));
    };
    
    void(^HandleBottomLeftEdgeFrameUpdate)(void) = ^{
        SetCropBoxSize(xDelta,yDelta);
        CGFloat x = CGRectGetMaxX(self.cropOriginFrame) - CGRectGetWidth(self.cropBoxFrame);
        self.cropBoxFrame = CGRectMake(x, self.cropBoxFrame.origin.y, CGRectGetWidth(self.cropBoxFrame), CGRectGetHeight(self.cropBoxFrame));
    };
    
    void(^HandleBottomRightEdgeFrameUpdate)(void) = ^{
        SetCropBoxSize(xDelta,yDelta);
    };
    
    switch (_touchedEdge) {
        case left:
            HandleLeftEdgeFrameUpdate();
            break;
        case right:
            HandleRightEdgeFrameUpdate();
            break;
        case top:
            HandleTopEdgeFrameUpdate();
            break;
        case bottom:
            HandleBottomEdgeFrameUpdate();
            break;
        case topLeft:
            HandleTopLeftEdgeFrameUpdate();
            break;
        case topRight:
            HandleTopRightEdgeFrameUpdate();
            break;
        case bottomLeft:
            HandleBottomLeftEdgeFrameUpdate();
            break;
        case bottomRight:
            HandleBottomRightEdgeFrameUpdate();
            break;
            
        default:
            break;
    }
}
@end
