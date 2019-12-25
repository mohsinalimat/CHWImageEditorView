//
//  CHWViewController.h
//  CHWImageEditorView
//
//  Created by JackyHeWei on 12/05/2019.
//  Copyright (c) 2019 JackyHeWei. All rights reserved.
//

@import UIKit;

@interface CHWViewController : UIViewController
@property(nonatomic,copy)void(^GetCropImageBlock)(UIImage* cropImage);
@end
