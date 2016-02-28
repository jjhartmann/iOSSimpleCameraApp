//
//  ViewController.m
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.captureSession == nil)
    {
        self.captureSession = [AVCaptureSession new];
    }
    
    // Create video device and input Device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDevice)
    {
        NSLog(@"ERROR: Failed to create capture device.");
        abort();
    }
    
    
    // Add device to session
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if(error)
    {
        NSLog(@"ERROR: Failed to create divice input, %@", error);
        abort();
    }
    
    if (![self.captureSession canAddInput:input])
    {
        NSLog(@"ERROR: Failed to set input to capture session");
        abort();
    }
    
    // Set Input
    [self.captureSession addInput:input];
    
    // Configure preview layer
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.previewLayer setFrame:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    // Add Layer to view
    [self.imageView.layer addSublayer:self.previewLayer];
    
    // StartCamera
    [self.captureSession startRunning];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButton:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        self.newMedia = YES;
    }
}

- (IBAction)cemeraRollButton:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        self.newMedia = NO;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        if(self.newMedia)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        }
        else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
        {
            NSLog(@"ERROR: Movie not supported");
        }
    }
}


- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

