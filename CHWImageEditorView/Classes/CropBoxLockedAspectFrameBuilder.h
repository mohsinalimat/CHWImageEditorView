//
//  CropBoxLockedAspectFrameBuilder.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/10.
//

#import <Foundation/Foundation.h>
#import "CHWMacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CropBoxLockedAspectFrameBuilder : NSObject
@property(nonatomic)CGRect cropBoxFrame;
- (instancetype)initTouchedEdge:(CropRotateOverlayEdge)touchedEdge withContentFrame:(CGRect)contentFrame withCropOriginFrame:(CGRect)cropOriginFrame withCropBoxFrame:(CGRect)cropBoxFrame;
-(void)updateCropBoxFrame:(CGFloat)xDelta withYDelta:(CGFloat)yDelta;
@end

NS_ASSUME_NONNULL_END
