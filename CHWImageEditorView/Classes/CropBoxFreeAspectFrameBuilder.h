//
//  CropBoxFreeAspectFrameBuild.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/10.
//

#import <Foundation/Foundation.h>
#import "CHWMacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CropBoxFreeAspectFrameBuilder : NSObject
@property(nonatomic)CGRect cropBoxFrame;
- (instancetype)initTouchedEdge:(CropRotateOverlayEdge)touchedEdge withContentFrame:(CGRect)contentFrame withCropOriginFrame:(CGRect)cropOriginFrame withCropBoxFrame:(CGRect)cropBoxFrame;
-(void)updateCropBoxFrame:(CGFloat)xDelta by:(CGFloat)yDelta;
@end

NS_ASSUME_NONNULL_END
