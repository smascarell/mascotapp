//
//  EditarMascotaController.m
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditarMascotaController.h"

@implementation EditarMascotaController

@synthesize txtObjeto = _txtObjeto;

@synthesize objetoKey = _objetoKey;
@synthesize objetoNombre = _objetoNombre;

@synthesize objetoEditado = _objetoEditado;
@synthesize delegado = _delegado;

@synthesize editarFecha;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self.txtObjeto setReturnKeyType:UIReturnKeyDone];
    [self.txtObjeto addTarget:self
                     action:@selector(Actualizar:)
           forControlEvents:UIControlEventEditingDidEndOnExit];
    self.navigationItem.title = [NSString stringWithFormat:@"Editar %@",[self.objetoEditado.entity name]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.txtObjeto.text = [self.objetoEditado valueForKey:self.objetoKey];
    [self.txtObjeto becomeFirstResponder];     
     
}
- (IBAction)Cancelar:(id)sender {
    [self.delegado cerrarEdicionMascota:self cerrarGuardar:NO];
}

- (IBAction)Actualizar:(id)sender {
 
    [self.objetoEditado setValue:self.txtObjeto.text forKey:self.objetoKey];
   
    [self.delegado cerrarEdicionMascota:self cerrarGuardar:YES];
    
}

- (void)viewDidUnload
{
    [self setTxtObjeto:nil];
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
