//
//  UIImage+CHWImageTool.h
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/13.
//

#import <UIKit/UIKit.h>

@class CHWCropInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CHWImageTool)
-(UIImage*)getCroppedImage:(CHWCropInfoModel*)cropInfoModel;
@end

NS_ASSUME_NONNULL_END
