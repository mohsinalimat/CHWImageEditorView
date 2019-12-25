//
//  ViewController.m
//  CHWImageEditorView_Example
//
//  Created by cherish on 2019/12/25.
//  Copyright © 2019 JackyHeWei. All rights reserved.
//

#import "ViewController.h"
#import "CHWViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-160), 20, 20)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"myimage2"];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2.0, CGRectGetMaxY(_imageView.frame), 200, 40)];
    [btn setTitle:@"Crop And Rotate" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(cropRotate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_imageView];
    [self.view addSubview:btn];
}

-(void)cropRotate:(id)sender{
    __weak typeof(self)weak_self = self;
    CHWViewController* vc = [[CHWViewController alloc] init];
    vc.GetCropImageBlock = ^(UIImage *cropImage) {
        __strong typeof(weak_self)strong_self = weak_self;
        if (strong_self) {
            [strong_self.imageView setImage:cropImage];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}

@end
