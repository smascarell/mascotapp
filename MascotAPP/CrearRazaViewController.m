//
//  CrearRazaViewController.m
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearRazaViewController.h"

@interface CrearRazaViewController ()

@end

@implementation CrearRazaViewController

@synthesize txtRaza = _txtRaza;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegado = _delegado;
@synthesize raza = _raza;
@synthesize animal = _animal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.txtRaza.delegate = self;
    [self.txtRaza becomeFirstResponder];
    
    [self.txtRaza setReturnKeyType:UIReturnKeyDone];
    [self.txtRaza addTarget:self
                             action:@selector(guardar:)
                   forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidUnload
{
    [self setTxtRaza:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.txtRaza setHighlighted:YES];
    [self.txtRaza becomeFirstResponder];
}

- (IBAction)cancelar:(id)sender {
    
    [self.delegado guardarRaza:nil guardar:FALSE];
}

- (IBAction)guardar:(id)sender {

    [self.delegado guardarRaza:self.txtRaza.text guardar:TRUE];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
