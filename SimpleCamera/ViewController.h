//
//  ViewController.h
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)cameraButton:(id)sender;
- (IBAction)cemeraRollButton:(id)sender;

@end

