//
//  CrearNombreGastoViewController.m
//  MascotAPP
//
//  Created by Samuel on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearNombreGastoViewController.h"

@implementation CrearNombreGastoViewController
@synthesize txtNombreGasto = _txtNombreGasto;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize nombre = _nombre;
@synthesize delegado = _delegado;

- (IBAction)guardar:(id)sender {
    GastosNombre *gnombre  = [NSEntityDescription insertNewObjectForEntityForName:@"GastosNombre"                                                                 inManagedObjectContext:self.managedObjectContext];       
    //Actualizar las propiedades del gasto
    
    gnombre.nombre = self.txtNombreGasto.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.delegado cerrarNuevoNombreGasto:self Nombre:self.nombre];
    
}
- (IBAction)cancelar:(id)sender {
    [self.delegado cerrarNuevoNombreGasto:self Nombre:nil];
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
    self.txtNombreGasto.delegate = self;
    [self.txtNombreGasto becomeFirstResponder];
    
    [self.txtNombreGasto setReturnKeyType:UIReturnKeyDone];
    [self.txtNombreGasto addTarget:self
                       action:@selector(guardar:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    UIImage *image = [UIImage imageNamed:@"bg01"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}


/*
-(void)viewDidAppear:(BOOL)animated{

}
*/
- (void)viewDidUnload
{
    [self setTxtNombreGasto:nil];
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
