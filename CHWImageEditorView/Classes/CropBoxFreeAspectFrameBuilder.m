//
//  CropBoxFreeAspectFrameBuilder.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/10.
//

#import "CropBoxFreeAspectFrameBuilder.h"

@interface CropBoxFreeAspectFrameBuilder()
@property(nonatomic)CGFloat minimumAspectRatio;
@property(nonatomic)CGRect contentFrame;
@property(nonatomic)CGRect cropOriginFrame;
@property(nonatomic)CropRotateOverlayEdge touchedEdge;
@end

@implementation CropBoxFreeAspectFrameBuilder

- (instancetype)initTouchedEdge:(CropRotateOverlayEdge)touchedEdge withContentFrame:(CGRect)contentFrame withCropOriginFrame:(CGRect)cropOriginFrame withCropBoxFrame:(CGRect)cropBoxFrame{
    self = [super init];
    if (self) {
        self.touchedEdge = touchedEdge;
        self.contentFrame = contentFrame;
        self.cropBoxFrame = cropBoxFrame;
        self.cropOriginFrame = cropOriginFrame;
    }
    return self;
}

-(void)updateCropBoxFrame:(CGFloat)xDelta by:(CGFloat)yDelta{
    BOOL(^NewAspectRatioValidWithNewSize)(CGSize) = ^(CGSize newSize){
        BOOL isMore = (MIN(newSize.width, newSize.height) / MAX(newSize.width, newSize.height)) >= self.minimumAspectRatio;
        return isMore;
    };
    
    void(^HandleLeftEdgeFrameUpdate)(CGSize) = ^(CGSize newSize){
        if (NewAspectRatioValidWithNewSize(newSize)) {
            CGFloat x = self.cropOriginFrame.origin.x + xDelta;
            CGFloat width = newSize.width;
            self.cropBoxFrame = CGRectMake(x, self.cropBoxFrame.origin.y, width, self.cropBoxFrame.size.height);
        }
    };
    
    void(^HandleRightEdgeFrameUpdate)(CGSize) = ^(CGSize newSize){
        if (NewAspectRatioValidWithNewSize(newSize)) {
            CGFloat width = newSize.width;
            self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, self.cropBoxFrame.origin.y, width, self.cropBoxFrame.size.height);
        }
    };
    
    void(^HandleTopEdgeFrameUpdate)(CGSize) = ^(CGSize newSize){
        if (NewAspectRatioValidWithNewSize(newSize)) {
            CGFloat y = self.cropOriginFrame.origin.y + yDelta;
            CGFloat height = newSize.height;
            self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, y, self.cropBoxFrame.size.width, height);
        }
    };
    
    void(^HandleBottomEdgeFrameUpdate)(CGSize) = ^(CGSize newSize){
        if (NewAspectRatioValidWithNewSize(newSize)) {
            CGFloat height = newSize.height;
            self.cropBoxFrame = CGRectMake(self.cropBoxFrame.origin.x, self.cropBoxFrame.origin.y, self.cropBoxFrame.size.width, height);
        }
    };
    
    CGSize(^GetNewCropFrameSize)(CropRotateOverlayEdge) = ^(CropRotateOverlayEdge tappedEdge){
        CGFloat x,y;
        switch (tappedEdge) {
            case left:
                x = -xDelta;
                y = 0;
                break;
            case right:
                x = xDelta;
                y = 0;
                break;
            case top:
                x = 0;
                y = -yDelta;
                break;
            case bottom:
                x = 0;
                y = yDelta;
                break;
            case topLeft:
                x = -xDelta;
                y = -yDelta;
                break;
            case topRight:
                x = xDelta;
                y = -yDelta;
                break;
            case bottomLeft:
                x = -xDelta;
                y = yDelta;
                break;
            case bottomRight:
                x = xDelta;
                y = yDelta;
                break;
                
            default:
                return self.cropOriginFrame.size;
                break;
        }
        return CGSizeMake(self.cropOriginFrame.size.width + x,self.cropOriginFrame.size.height + y);
    };
    
    CGSize newSize = GetNewCropFrameSize(_touchedEdge);
    
    switch (self.touchedEdge) {
        case left:
            HandleLeftEdgeFrameUpdate(newSize);
            break;
        case right:
            HandleRightEdgeFrameUpdate(newSize);
            break;
        case top:
            HandleTopEdgeFrameUpdate(newSize);
            break;
        case bottom:
            HandleBottomEdgeFrameUpdate(newSize);
            break;
        case topLeft:
            HandleTopEdgeFrameUpdate(newSize);
            HandleLeftEdgeFrameUpdate(newSize);
            break;
        case topRight:
            HandleTopEdgeFrameUpdate(newSize);
            HandleRightEdgeFrameUpdate(newSize);
            break;
        case bottomLeft:
            HandleBottomEdgeFrameUpdate(newSize);
            HandleLeftEdgeFrameUpdate(newSize);
            break;
        case bottomRight:
            HandleBottomEdgeFrameUpdate(newSize);
            HandleRightEdgeFrameUpdate(newSize);
            break;
        default:
            break;
    }
}
@end
