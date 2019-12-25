//
//  CHWBarIten.m
//  画风
//
//  Created by Cherish on 2017/6/18.
//  Copyright © 2017年 Cherish. All rights reserved.
//

#import "CHWBarItem.h"
#import "CHWMacroDefine.h"

@interface CHWBarItem()
@property(nonatomic)CGSize imageSize;
@end
@implementation CHWBarItem

- (instancetype)initWithFrame:(CGRect)frame imageSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = size;
        [self commonInitial];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = CGSizeZero;
        [self commonInitial];
    }
    return self;
}

-(void)commonInitial{
    [self setBackgroundColor:[UIColor clearColor]];
    self.ShowBorder = NO;
    self.titleOverlay = NO;
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    
    self.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.selectedTitleAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0],
                                     NSForegroundColorAttributeName:Highlighted_Color};
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGSize frameSize = self.frame.size;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    
    if ([self isSelected]) {
        if (self.ShowBorder)
        {
            self.layer.borderWidth = 1;
            self.layer.borderColor = Highlighted_Color.CGColor;
        }
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        
        titleAttributes = [self selectedTitleAttributes];
        if (!titleAttributes)
        {
            titleAttributes = [self unselectedTitleAttributes];
        }
    }else{
        if (self.ShowBorder)
        {
            self.layer.borderWidth = 0;
        }
        
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        
        titleAttributes = [self unselectedTitleAttributes];
    }
    if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        _imageSize = [image size];
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
    
    if (_title.length == 0) {
        [image drawInRect:CGRectMake(roundf(frameSize.width/2.0-_imageSize.width/2.0) + _imagePositionAdjustment.horizontal, roundf(frameSize.height/2.0-_imageSize.height/2.0) + _imagePositionAdjustment.vertical, _imageSize.width, _imageSize.height)];
    }else{
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - _imageSize.width / 2) +
                                     _imagePositionAdjustment.horizontal,
                                     roundf(frameSize.height / 2 - _imageSize.height / 2) +
                                     _imagePositionAdjustment.vertical,
                                     _imageSize.width, _imageSize.height)];
        [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) +
                                      _titlePositionAdjustment.horizontal, frameSize.height - 20 + _titlePositionAdjustment.vertical, titleSize.width, titleSize.height)
         
            withAttributes:titleAttributes];
    }
    
    CGContextRestoreGState(context);
    
}

-(void)setSelectedImage:(UIImage*)selectedImage withUnSelectedImage:(UIImage*)unSelectedImage{
    if (selectedImage && selectedImage != [self selectedImage]) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unSelectedImage && unSelectedImage != [self unselectedImage]) {
        [self setUnselectedImage:unSelectedImage];
    }
}

-(void)setBackgroundSelectedImage:(UIImage*)selectedImage withUnSelectedImage:(UIImage*)unSelectedImage{
    if (selectedImage && selectedImage != [self selectedBackgroundImage]) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unSelectedImage && unSelectedImage != [self unselectedBackgroundImage]) {
        [self setUnselectedBackgroundImage:unSelectedImage];
    }
}

- (UIImage *)finishedSelectedImage
{
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage
{
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage
{
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}
@end
