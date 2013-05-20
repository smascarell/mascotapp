//
//  CrearGastoTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearGastoTableViewController.h"


@implementation CrearGastoTableViewController

@synthesize txtGastoTitulo;
@synthesize txtGastoPrecio;
@synthesize txtGastoFecha;
@synthesize txtGastoCategoria;
@synthesize txtGastoMascota;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize delegado = _delegado;

@synthesize gasto = _gasto;
@synthesize gastoCategoria = _gastoCategoria;
@synthesize gastoNombre = _gastoNombre;
@synthesize mascota = _mascota;
@synthesize modoedicion = _modoedicion;
@synthesize precioValor = _precioValor;

- (IBAction)cancelar:(id)sender {
    
    [self.delegado cerraGastoPrevio:self Guardar:FALSE];
    
}
- (IBAction)guardar:(id)sender {
 
    if ( [self.txtGastoMascota.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Elige una mascota de la lista"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if ([self.txtGastoCategoria.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selecciona la categoría del gasto"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if ( [self.txtGastoPrecio.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se añaden gastos sin precio"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    } else if ([self.txtGastoTitulo.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Escribe el título"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if ([self.txtGastoFecha.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No te olvides de la fecha"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        if (self.modoedicion) {
            
            [self guardarEdicion];
            
        } else {
            
            [self guardarNuevo];
            
        }
               [self.delegado cerraGastoPrevio:self Guardar:TRUE];

    }
}

- (IBAction)fecha:(id)sender {
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Fecha de nacimiento" 
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];  
    
    //seleccionar fecha    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    if (self.modoedicion) {
        if (fechaNacimiento != NULL){
            [datePicker setDate:fechaNacimiento];
        }
    } else
        [datePicker setDate:[NSDate date]];
    
    [pickerViewPopup addSubview:datePicker];
    [pickerViewPopup showInView:self.view];        
    
    CGRect menuRect = pickerViewPopup.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    pickerViewPopup.frame = menuRect;
    
    
    CGRect pickerRect = datePicker.frame;
    pickerRect.origin.y = orgHeight;
    datePicker.frame = pickerRect;

}

- (void)guardarEdicion{
    
    self.gasto.tienenombre = self.gastoNombre;
    
    self.gasto.precio = precioGasto;
    NSLog(@"%@",precioGasto);
    
    if (fechaNacimiento == NULL) {
        self.gasto.fecha = [NSDate date];
    } else  {
        self.gasto.fecha = fechaNacimiento;
    }
    self.gasto.perteceneMascota = self.mascota;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }
   
}
- (void)guardarNuevo{
                
            Gastos *g = [NSEntityDescription insertNewObjectForEntityForName:@"Gastos"
                                                      inManagedObjectContext:self.managedObjectContext];
  
            g.precio = precioGasto;
            
            if (datePicker.date == NULL) {           
                g.fecha = [NSDate date];
            } else  {
                g.fecha = datePicker.date;
            }
            
            g.categoria = self.gastoCategoria;
            g.perteceneMascota = self.mascota;
            g.tienenombre = self.gastoNombre;

            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
                
            }
      }

-(void) guardarEventoGasto: (Gastos *) gasto {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = gasto.tienenombre.nombre;
    event.startDate = [[NSDate alloc] init];
    event.startDate = gasto.fecha;
    //event.startDate = [[NSDate alloc] init];
    event.endDate   = [[NSDate alloc] initWithTimeInterval:1 sinceDate:event.startDate];
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];

}

- (void)guardarGastoNombre{
    
    GastosNombre *gnombre  = [NSEntityDescription insertNewObjectForEntityForName:@"GastosNombre" 
                                                                 inManagedObjectContext:self.managedObjectContext];       
    //Guardar en nombre del gasto
    
    gnombre.nombre = self.txtGastoTitulo.text;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        fechaNacimiento = datePicker.date;
        self.txtGastoFecha.text = [NSString stringWithFormat:@"%@",
                                   [df stringFromDate:fechaNacimiento]];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        NSString *text = textField.text;
        text = [text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [formatter setMaximumFractionDigits:2];
        
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setUsesGroupingSeparator:NO];
        
        // Get the float value of the text field and format it
        textField.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[text floatValue]]];
        
        //Convert string  value to DecimalNumber with 2 decimal digits
        
        precioGasto = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithDouble:[text floatValue]] decimalValue]];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *currency = [formatter stringFromNumber:precioGasto];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        precioGasto = (NSDecimalNumber *)[formatter numberFromString:currency];
    }

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.mascota = self.gasto.perteceneMascota;
    self.gastoNombre = self.gasto.tienenombre;
 
    if (self.modoedicion) {
        self.txtGastoTitulo.text = self.gasto.tienenombre.nombre;
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setLocale:[NSLocale currentLocale]];
        [f setNumberStyle:NSNumberFormatterCurrencyStyle];
        [f setMinimumFractionDigits:2];
        [f setMaximumFractionDigits:2];
               
        NSString *precio = [f stringFromNumber: self.gasto.precio];
        self.txtGastoPrecio.text = precio;
        
        precioGasto = self.gasto.precio;
              
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *nombre = self.gasto.categoria.nombre;

        self.txtGastoCategoria.text = nombre; 
        
        fechaNacimiento = self.gasto.fecha;
        if (fechaNacimiento != NULL) {
            self.txtGastoFecha.text = [NSString stringWithFormat:@"%@",[df stringFromDate:fechaNacimiento]]; 
        }
        self.txtGastoMascota.text = self.gasto.perteceneMascota.nombre;
                
        UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:self.gasto.perteceneMascota.img90];
        
        [self.imgMascotaicono setBounds:CGRectMake(0, 0, 28.0, 28.0)];
        [self.imgMascotaicono.layer setCornerRadius:5.0];
        [self.imgMascotaicono setClipsToBounds:YES];
        self.imgMascotaicono.image = imagen;
        self.imgMascotaicono.contentMode = UIViewContentModeScaleAspectFill;
        
    }
   
    self.txtGastoTitulo.delegate = self;
    self.txtGastoPrecio.delegate = self;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //change it to your condition    
    if ([touch.view isKindOfClass:[UIButton class]]) {      
        return NO;
    }
    
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self.txtGastoTitulo resignFirstResponder];
    [self.txtGastoPrecio resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidUnload
{
    [self setTxtGastoTitulo:nil];
    [self setTxtGastoPrecio:nil];
    [self setTxtGastoFecha:nil];
    [self setTxtGastoMascota:nil];
    [self setTxtGastoMascota:nil];
    [self setImgMascotaicono:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"GastosPrevios" sender:Nil];
    }
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"GastosGategoria" sender:Nil];
    }

}

*/


#pragma mark - Table view delegate

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"GastosPrevios" sender:Nil];
    }
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"GastosGategoria" sender:Nil];
    }
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"GastosPrevios"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        GastosPreviosTableViewController *nuevoGasto = [navController.viewControllers objectAtIndex:0];
        
        nuevoGasto.gasto = self.gasto;
        nuevoGasto.delegado = (id)self;
        nuevoGasto.managedObjectContext = self.managedObjectContext;
    }
    if ([[segue identifier] isEqualToString:@"GastosGategoria"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        GastosCategoriaTableViewController *nuevoGasto = [navController.viewControllers objectAtIndex:0];
        
        nuevoGasto.delegado = (id)self;
        nuevoGasto.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"GastosMascota"]) {
        
        SeleccionarMascotaEventoViewController *gm = segue.destinationViewController;
        
        gm.delegado = (id)self;
        gm.managedObjectContext = self.managedObjectContext;
    }
  
}


- (void)cerrarGastoPrevio:(GastosPreviosTableViewController *)controller GastoNombre:(GastosNombre *)nombre Actualizar:(BOOL)actualizar{
    if (actualizar) {
        self.txtGastoTitulo.text = nombre.nombre;
        self.gastoNombre = nombre;
    }
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)cerrarGastoCategoria:(GastosCategoriaTableViewController *)controller Categoria:(GastosCategoria *)categoria{
    
    self.txtGastoCategoria.text = categoria.nombre;
    
    if (self.modoedicion) {
        self.gasto.categoria = categoria;
        
    } else self.gastoCategoria = categoria;
    
}

-(void)SeleccionarMascota:(SeleccionarMascotaEventoViewController *)controller mascota:(Mascota *)mascota {
    self.mascota = mascota;
    self.txtGastoMascota.text = mascota.nombre;
    NSData *pngData = [NSData dataWithContentsOfFile:mascota.img90];
    UIImage *image = [UIImage imageWithData:pngData];
    
    self.imgMascotaicono.image = image;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
