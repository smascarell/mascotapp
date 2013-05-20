//
//  GaleriaFotosViewController.m
//  MascotAPP
//
//  Created by Samuel on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GaleriaFotosViewController.h"

@implementation GaleriaFotosViewController

@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)TakePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
	//Use camera if device has one otherwise use photo library
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
	else
	{
		[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
    
	[imagePicker setDelegate:(id)self];
    
	//Show image picker
	[self presentModalViewController:imagePicker animated:YES];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

//********** RECEIVE PICTURE **********
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//Get image
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	//Display in ImageView object (if you want to display it
	[imageView setImage:image];
    
	//Take image picker off the screen (required)
	[self dismissModalViewControllerAnimated:YES];
    
    NSParameterAssert(image);
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

}


@end
