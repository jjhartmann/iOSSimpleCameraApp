//
//  ImageViewController.h
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

- (id)initWithImage:(UIImage *)image;
- (IBAction)dimissImageView:(id)sender;



@end
