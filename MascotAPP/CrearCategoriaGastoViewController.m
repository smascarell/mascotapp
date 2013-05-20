//
//  CrearCategoriaGastoViewController.m
//  MascotAPP
//
//  Created by Samuel on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearCategoriaGastoViewController.h"

@implementation CrearCategoriaGastoViewController

@synthesize txtNombreCategoria = _txtNombreCategoria;
@synthesize delegado = _delegado;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize categoria = _categoria;


- (IBAction)guardar:(id)sender {
    GastosCategoria *gcategoria  = [NSEntityDescription insertNewObjectForEntityForName:@"GastosCategoria" 
                                                   inManagedObjectContext:self.managedObjectContext];       
    //Actualizar las propiedades del gasto
    
    gcategoria.nombre = self.txtNombreCategoria.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self.delegado cerrarNuevaCategoriaGasto:self Gasto:self.categoria];
    
}
- (IBAction)cancelar:(id)sender {
    [self.delegado cerrarNuevaCategoriaGasto:self Gasto:self.categoria];
}


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
    self.txtNombreCategoria.delegate = self;
    [self.txtNombreCategoria becomeFirstResponder];
    
    [self.txtNombreCategoria setReturnKeyType:UIReturnKeyDone];
    [self.txtNombreCategoria addTarget:self
                            action:@selector(guardar:)
                  forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
