//
//  CrearAnimalViewController.m
//  MascotAPP
//
//  Created by Samuel Mascarell on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearAnimalViewController.h"

@interface CrearAnimalViewController ()

@end

@implementation CrearAnimalViewController

@synthesize animal = _animal;
@synthesize mascota = _mascota;

@synthesize txtNombreAnimal = _txtNombreAnimal;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegado = _delegado;


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
    self.txtNombreAnimal.delegate = self;
    [self.txtNombreAnimal becomeFirstResponder];
    
    [self.txtNombreAnimal setReturnKeyType:UIReturnKeyDone];
    [self.txtNombreAnimal addTarget:self
                            action:@selector(guardar:)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    

}

- (void)viewDidUnload
{
    [self setTxtNombreAnimal:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.txtNombreAnimal setHighlighted:YES];
    [self.txtNombreAnimal becomeFirstResponder];
}

- (IBAction)cancelar:(id)sender {
    [self dismissModalViewControllerAnimated:YES];

}
- (IBAction)guardar:(id)sender {
    Animal *animal = [NSEntityDescription insertNewObjectForEntityForName:@"Animal" 
                                                   inManagedObjectContext:self.managedObjectContext];
    animal.nombre = self.txtNombreAnimal.text;
    
    [self.delegado guardarAnimal:self.animal guardar:TRUE controller:self];
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
