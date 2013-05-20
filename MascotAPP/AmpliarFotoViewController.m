//
//  AmpliarFotoViewController.m
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AmpliarFotoViewController.h"

@implementation AmpliarFotoViewController
@synthesize fotoAmpliada;
@synthesize mascota;


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

- (void)viewWillAppear:(BOOL)animated{
    NSData *pngData = [NSData dataWithContentsOfFile:mascota.img];
    UIImage *image = [UIImage imageWithData:pngData];
    fotoAmpliada.image = image;
}
-(void)viewDidAppear:(BOOL)animated{
    NSString *nombre = [[NSString alloc]initWithString:mascota.nombre];
    self.title = nombre;
}
#pragma mark - View lifecycle

- (void)loadView {
   
    self.fotoAmpliada = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.fotoAmpliada.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.fotoAmpliada.contentMode = UIViewContentModeScaleAspectFit;
    self.fotoAmpliada.backgroundColor = [UIColor whiteColor];
    
    self.view = self.fotoAmpliada;
}


- (void)viewDidUnload
{
    [self setFotoAmpliada:nil];
    [super viewDidUnload];
    
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

@end
