# CHWImageEditorView

[![CI Status](https://img.shields.io/travis/JackyHeWei/CHWImageEditorView.svg?style=flat)](https://travis-ci.org/JackyHeWei/CHWImageEditorView)
[![Version](https://img.shields.io/cocoapods/v/CHWImageEditorView.svg?style=flat)](https://cocoapods.org/pods/CHWImageEditorView)
[![License](https://img.shields.io/cocoapods/l/CHWImageEditorView.svg?style=flat)](https://cocoapods.org/pods/CHWImageEditorView)
[![Platform](https://img.shields.io/cocoapods/p/CHWImageEditorView.svg?style=flat)](https://cocoapods.org/pods/CHWImageEditorView)

## Example
You can use the CHWCropRotateView in your project, how to use the CHWCropRotateView ,you can find the detail in my example project.
CropRotateConfig* config = [CropRotateConfig new];
    self.cropRotateView = [[CHWCropRotateView alloc] initWithImage:image withConfig:config];
    _cropRotateView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-TABBARHEIGHT-60-60);
    _cropRotateView.forceFixedRatio = NO;
    _cropRotateView.delegate = self;
    [self.view addSubview:_cropRotateView];

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CHWImageEditorView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CHWImageEditorView'
```

## Author

JackyHeWei, Cherish_wei_he@163.com

## License

CHWImageEditorView is available under the MIT license. See the LICENSE file for more info.
