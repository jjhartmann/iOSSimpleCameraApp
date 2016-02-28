//
//  ViewController.h
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate,
                                              UITableViewDelegate,
                                              UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property BOOL newMedia;
@property AVCaptureVideoPreviewLayer *previewLayer;
@property AVCaptureSession *captureSession;

// slide menu
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIDynamicAnimator *anaimator;
@property (nonatomic, strong) NSArray *menuItems;

// Method Declaration
- (IBAction)cameraButton:(id)sender;
- (IBAction)cemeraRollButton:(id)sender;
- (IBAction)swipeFromRight:(id)sender;

- (void)setupMenuView;
- (void)showMeny:(BOOL)state;
@end

