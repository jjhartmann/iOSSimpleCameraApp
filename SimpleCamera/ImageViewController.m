//
//  ImageViewController.m
//  SimpleCamera
//
//  Created by Jeremy Hartmann on 2016-02-28.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    
    if (self)
    {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up View
    self.imageView.image = self.image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dimissImageView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
