//
//  ViewController.m
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"

@interface ViewController (){
    CGFloat rootViewWidth;
    CGFloat rootViewHieght;
    CGFloat menuWidth;
    CGFloat menuHieght;
    UIImage *currentImage;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Delcare Member Vars
    rootViewWidth = self.view.frame.size.width;
    rootViewHieght = self.view.frame.size.height;
    menuWidth = (3* rootViewWidth)/4;
    menuHieght = rootViewHieght;
    
    // Setup capture session
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
    
    
    // Set menu items
    self.menuItems = @[@"Close", @"MENU1", @"MENU2"];
    [self setupMenuView];
    
    // Animator
    self.anaimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    
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

- (IBAction)swipeFromLeft:(id)sender
{
    [self showMeny:YES];
}

#pragma mark -
#pragma mark Sliding Menu Impl

- (void)setupMenuView
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(-menuWidth, 0, menuWidth, menuHieght)];
    
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuView];
    
    
    // Set up Table View.
    self.menuTableView = [[UITableView alloc] initWithFrame:self.menuView.bounds style:UITableViewStylePlain];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.alpha = 0.5;
    
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    [self.menuView addSubview:self.menuTableView];
    
}

- (void)showMeny:(BOOL)state
{
    [self.anaimator removeAllBehaviors];
    
    // set Gravity
    CGFloat gravityX = (state) ? 0.3 : -1.0;
    CGFloat boundaryPX = (state) ? menuWidth : -(menuWidth + 5);
    
    // Set up gravity animation
    UIGravityBehavior *gb = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    gb.gravityDirection = CGVectorMake(gravityX, 0.0f);
    
    [self.anaimator addBehavior:gb];
    
    
    // Collision Behaviour
    UICollisionBehavior *cb = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    [cb addBoundaryWithIdentifier:@"menuBoundary" fromPoint:CGPointMake(boundaryPX, 580) toPoint:CGPointMake(boundaryPX, 0) ];
    
    [self.anaimator addBehavior:cb];
    
}


#pragma mark -
#pragma mark UITableView Delegate and Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Implement cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *text = self.menuItems[indexPath.row];
    cell.textLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: // Close the menu
            [self showMeny:NO];
            break;
            
        default:
            break;
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
        currentImage = info[UIImagePickerControllerOriginalImage];
        
        // Write file to camera roll
        if(self.newMedia)
        {
            UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        }
        else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
        {
            NSLog(@"ERROR: Movie not supported");
        }
        
        
        // Open image view
        [self performSegueWithIdentifier:@"imageViewSegue" sender:self];
        
        
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

#pragma mark -
#pragma mark Seque Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"imageViewSegue"])
    {
        ImageViewController *vc = [segue destinationViewController];
        vc.image = currentImage;
    }
}


@end

