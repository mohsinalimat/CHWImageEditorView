//
//  CHWViewController.m
//  CHWImageEditorView
//
//  Created by JackyHeWei on 12/05/2019.
//  Copyright (c) 2019 JackyHeWei. All rights reserved.
//

#import "CHWViewController.h"
#import <CHWImageEditorView/CHWCropRotateView.h>
#import <CHWImageEditorView/CHWCropRotateToolBar.h>

@interface CHWViewController ()<CHWCropRotateDelegate>
@property(nonatomic,strong)CHWCropRotateView* cropRotateView;
@property(nonatomic,strong)CHWCropRotateToolBar *toolBar;
@end

@implementation CHWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configCropRotateView:[UIImage imageNamed:@"myimage2"]];
    [self configBottomToolBar];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_cropRotateView resetUIFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods
-(void)configCropRotateView:(UIImage*)image{
    CropRotateConfig* config = [CropRotateConfig new];
    self.cropRotateView = [[CHWCropRotateView alloc] initWithImage:image withConfig:config];
    _cropRotateView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-TABBARHEIGHT-60-60);
    _cropRotateView.forceFixedRatio = NO;
    _cropRotateView.delegate = self;
    [self.view addSubview:_cropRotateView];
}

-(void)configBottomToolBar{
    self.toolBar = [[CHWCropRotateToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)-TABBARHEIGHT-60, CGRectGetWidth(self.view.bounds), TABBARHEIGHT+60)];
    _toolBar.backgroundColor = [UIColor blackColor];
    __weak typeof(self)weak_self = self;
    self.toolBar.DidCropRatioHandle = ^(SquareCropRatio cropRatio) {
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            [strong_self.cropRotateView squareCropImageByRatio:cropRatio];
        }
    };
    self.toolBar.ResetCropRotateViewHandle = ^{
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            [strong_self.cropRotateView reset];
        }
    };
    self.toolBar.DidRotate90Handle = ^(BOOL clockWise) {
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            [strong_self.cropRotateView counterclockwiseRotate90:clockWise];
        }
    };
    self.toolBar.ChangeCropStyleHandle = ^(CroppingStyle cropStyle) {
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            strong_self.cropRotateView.croppingStyle = cropStyle;
        }
    };
    self.toolBar.DidCropShapeHandle = ^(ShapeType shapeType) {
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            [strong_self.cropRotateView setCroppingShapeStyle:shapeType];
        }
    };
    self.toolBar.CropImageHandle = ^{
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            UIImage* cropImage = [strong_self.cropRotateView crop];
            if (strong_self.GetCropImageBlock) {
                strong_self.GetCropImageBlock(cropImage);
            }
            [strong_self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [self.view addSubview:_toolBar];
}

-(void)resetCropRotateView:(id)sender{
    [self.cropRotateView reset];
}

#pragma mark CHWCropRotateDelegate methods
-(void)cropViewDidBecomeResettable:(CHWCropRotateView*)cropRotateView canResettable:(BOOL)canResettable{
    [self.toolBar updateButtonsStatus:canResettable];
}

- (void)cropViewDidBecomeCropable:(CHWCropRotateView *)cropRotateView canCropable:(BOOL)canCropable{
    [self.toolBar updateCropButtonsStatus:canCropable];
}
@end
