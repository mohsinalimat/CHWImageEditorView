//
//  UIImage+CHWImageTool.m
//  CHWImageEditorView
//
//  Created by cherish on 2019/12/13.
//

#import "UIImage+CHWImageTool.h"
#import "CHWCropInfoModel.h"
#import "CHWUtils.h"

@implementation UIImage (CHWImageTool)

-(UIImage*)imageWithFixedOrientation{
    CGImageRef cgImage = self.CGImage;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    if (!cgImage) {
        return nil;
    }
    if (!colorSpace) {
        return nil;
    }
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, width, height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }else if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored){
        transform = CGAffineTransformTranslate(transform, width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored){
        transform = CGAffineTransformTranslate(transform, 0, height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }
    
    if (self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }else if (self.imageOrientation == UIImageOrientationLeftMirrored || self.imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, CGImageGetBitsPerComponent(cgImage),0, colorSpace, CGImageGetBitmapInfo(cgImage));
    if (!context) {
        return nil;
    }
    CGContextConcatCTM(context, transform);
    
    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored || self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored) {
        CGContextDrawImage(context, CGRectMake(0, 0, height, width), cgImage);
    }else{
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    }
    
    CGImageRef newCgImage = CGBitmapContextCreateImage(context);
    if (!newCgImage) {
        return nil;
    }
    return [[UIImage alloc] initWithCGImage:newCgImage];
}

-(UIImage*)transformedImage:(CGAffineTransform)transform zoomScale:(CGFloat)zoomScale sourceSize:(CGSize)sourceSize cropSize:(CGSize)cropSize imageViewSize:(CGSize)imageViewSize withShapeType:(ShapeType)shapeType{
    CGImageRef cgImage = self.CGImage;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    if (!colorSpace) {
        return self;
    }
    if (@available(iOS 10, *)) {
        bool isSupportsOutput = CGColorSpaceSupportsOutput(colorSpace);
        if (!isSupportsOutput) {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
    }
    
    CGFloat expectedWidth = floor(sourceSize.width / imageViewSize.width * cropSize.width) / zoomScale;
    CGFloat expectedHeight = floor(sourceSize.height / imageViewSize.height * cropSize.height) / zoomScale;
    
    CGRect deviceRect = CGRectMake(0, 0, expectedWidth, expectedHeight);
    
    CGSize outputSize = CGSizeMake(expectedWidth, expectedHeight);
    CGFloat bitmapBytesPerRow = 0;
    
    CGContextRef context = CGBitmapContextCreate(nil, outputSize.width, outputSize.height, CGImageGetBitsPerComponent(cgImage),bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if (!context) {
        context = CGBitmapContextCreate(nil, outputSize.width, outputSize.height, CGImageGetBitsPerComponent(cgImage),bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst);
    }
    if (context) {
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width, outputSize.height / cropSize.height);
        uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width / 2, cropSize.height / 2);
        uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
        
        CGMutablePathRef path = NULL;
       
        
        switch (shapeType) {
            case CIRCLE_SHAPE:
            {
                path = [CHWUtils getCircleCGMutablePath:deviceRect];
            }
                break;
            case OVAL_SHAPE:
            {
                path = [CHWUtils getOvalCGMutablePath:deviceRect];
            }
                break;
            case HALF_CIRCLE_SHAPE:
            {
                path = [CHWUtils getHalfCircleCGMutablePath:deviceRect];
            }
                break;
            case TRIANGLE_SHAPE:
            {
                path = [CHWUtils getTriangleCGMutablePath:deviceRect];
            }
                break;
            case HEART_SHAPE:
            {
                path = [CHWUtils getHeartCGMutablePath:CGContextConvertRectToDeviceSpace(context, deviceRect)];
            }
                break;
            case HEXAGON_SHAPE:
            {
                path = [CHWUtils getHopHexagonShapeBezierCGMutablePath:deviceRect];
            }
                break;
            case OCTAGON_SHAPE:
            {
               path = [CHWUtils getOctagonCGMutablePath:deviceRect];
            }
                break;
            case STAR_SHAPE:
            {
                path = [CHWUtils getStarShapeCGMutablePath:deviceRect];
            }
                break;
            case ARC_SHAPE:
            {
                path = [CHWUtils getArcRectCGMutablePath:deviceRect];
            }
                break;
                
            case CROSS_SHAPE:
            {
                path = [CHWUtils getCrossShapeCGMutablePath:deviceRect];
            }
                break;
            case SECTOR_SHAPE:
            {
                path = [CHWUtils getSectorCGMutablePath:deviceRect];
            }
                break;
                
            default:
                break;
        }
        
        if (path) {
            CGContextAddPath(context,path);
            CGContextClip(context);
            CGPathRelease(path);
        }
        CGContextConcatCTM(context, uiCoords);
        CGContextConcatCTM(context, transform);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        
        
        CGContextDrawImage(context, CGRectMake(-imageViewSize.width / 2, -imageViewSize.height / 2, imageViewSize.width, imageViewSize.height), cgImage);
        CGImageRef resultCgImage = CGBitmapContextCreateImage(context);
        UIImage* newImage = [UIImage imageWithCGImage:resultCgImage];
        CGImageRelease(resultCgImage);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        return newImage;
    }
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return nil;
}

-(UIImage*)getCroppedImage:(CHWCropInfoModel*)cropInfoModel{
    UIImage* fixedImage = [self imageWithFixedOrientation];
    if (!fixedImage) {
        return nil;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, cropInfoModel.translation.x, cropInfoModel.translation.y);
    transform = CGAffineTransformRotate(transform, cropInfoModel.rotation);
    transform = CGAffineTransformScale(transform, cropInfoModel.scale, cropInfoModel.scale);
    
    UIImage* newImage = [fixedImage transformedImage:transform zoomScale:cropInfoModel.scale sourceSize:self.size cropSize:cropInfoModel.cropSize imageViewSize:cropInfoModel.imageViewSize withShapeType:cropInfoModel.shapeType];
    return newImage;
}

@end
