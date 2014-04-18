//
//  doneViewController.h
//  One Frame
//
//  Created by Saswata Basu on 3/21/14.
//  Copyright (c) 2014 Saswata Basu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface doneViewController : UIViewController <UIActionSheetDelegate>
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
