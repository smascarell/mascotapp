//
//  EventoEditarTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 14/08/12.
//
//

#import "EventoEditarTableViewController.h"

@interface EventoEditarTableViewController ()

@end
@implementation EventoEditarTableViewController

@synthesize evento = _evento;
@synthesize txtTitulo;
@synthesize txtDescripcion;
@synthesize mascotalbl;
@synthesize fechalbl;
@synthesize eventolbl;
@synthesize hechoBoton;
@synthesize imgHecho;
@synthesize imgMascota;


- (IBAction)cancelar:(id)sender {
    [self.delegado cerrarEditarEvento:self guardar:NO fecha:nil];
    
}
- (IBAction)guardar:(id)sender {
    
    if ( [self.txtTitulo.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Debes escribir un título para la tarea"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if( [self.fechalbl.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Elige una fecha para la tarea"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else if ([self.mascotalbl.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Elige una mascota"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        self.evento.fecha = fecha;
        self.evento.titulo = self.txtTitulo.text;
        self.evento.descripcion = self.txtDescripcion.text;
        self.evento.mascota = self.mascotalbl.text;
        self.evento.hecho = [NSNumber numberWithBool:hecho];
        self.evento.aviso = [NSNumber numberWithInt:(int)alarma];
        
        if (alarma != 10) {
            NSDate *fechaAviso;
            switch (alarma) {
                       
                case 0:
                    [self crearNotificacion:fecha text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
                    break;
                    
                case 1:
                {
                    fechaAviso = [fecha dateByAddingTimeInterval:-900];
                    [self crearNotificacion:fechaAviso text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
                    break;
 
                }
                case 2 : {
                    fechaAviso = [fecha dateByAddingTimeInterval:-1800];
                    [self crearNotificacion:fechaAviso text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
                    break;
                }
                    
                case 3 : {
                    fechaAviso = [fecha dateByAddingTimeInterval:-86400];
                    [self crearNotificacion:fechaAviso text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
                    break;
                }
                case 4 : {
                    fechaAviso = [fecha dateByAddingTimeInterval:-604800];
                    [self crearNotificacion:fechaAviso text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
                    break;
                }

                default:
                    break;
            }
            
            
            [self crearNotificacion:fechaAviso text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
            
            EKFunciones *ekf = [[EKFunciones alloc]init];
            [ekf editarEvento:self.evento];
        }
        EKFunciones *ekf = [[EKFunciones alloc]init];
        [ekf editarEvento:self.evento];
        [self.delegado cerrarEditarEvento:self guardar:YES fecha:self.evento.fecha];
    }
}
- (IBAction)eliminarEvento:(id)sender {
    [self.delegado cerrarEliminarEvento:self evento:self.evento fecha:self.evento.fecha];
}
- (IBAction)cambiarHecho:(id)sender {
    hecho = !hecho;
    if (hecho)
        [self.imgHecho setImage:[UIImage imageNamed:@"checked"]];
    else
        [self.imgHecho setImage:[UIImage imageNamed:@"unchecked"]];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.txtTitulo.delegate = self;
    self.txtDescripcion.delegate = self;
    
    self.txtTitulo.text = self.evento.titulo;
    self.txtDescripcion.text = self.evento.descripcion;
    self.mascotalbl.text = self.evento.perteneceMascota.nombre;
    
    UIImage *image90 = [UIImage imageWithContentsOfFile:self.evento.perteneceMascota.img90];
    
    [self.imgMascota setBounds:CGRectMake(0, 0, 28.0, 28.0)];
    [self.imgMascota.layer setCornerRadius:5.0];
    [self.imgMascota setClipsToBounds:YES];
    self.imgMascota.contentMode = UIViewContentModeScaleAspectFill;
    self.imgMascota.image = image90;
    
    listaAvisos = [NSArray arrayWithObjects:@"En la hora indicada", @"15 minutos antes",@"30 minutos antes",@"1 hora antes", @"1 día antes",@"1 semana antes", nil];
    
    alarma = [self.evento.aviso intValue];
    
    if (alarma == 10) {
        self.eventolbl.text = @"Ninguna";
    } else
    self.eventolbl.text = [listaAvisos objectAtIndex:[self.evento.aviso intValue]];
    
       
    if ([self.evento.hecho boolValue]) {
        hecho = TRUE;
        [self.imgHecho setImage:[UIImage imageNamed:@"checked"]];
    } else {
        hecho = FALSE;
        [self.imgHecho setImage:[UIImage imageNamed:@"unchecked"]];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    self.fechalbl.text = [NSString stringWithFormat:@"%@",
                          [df stringFromDate:self.evento.fecha]];
        
    fecha = self.evento.fecha;
    
    UIImageView *imagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:imagebg];
    
}

- (void)viewDidUnload
{
    [self setTxtTitulo:nil];
    [self setTxtDescripcion:nil];
    [self setMascotalbl:nil];
    [self setFechalbl:nil];
    [self setHechoBoton:nil];
    [self setImgHecho:nil];
    [self setImgMascota:nil];
    [self setEventolbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        
        // df.dateStyle = NSDateFormatterLongStyle;
        
        self.fechalbl.text =  [NSString stringWithFormat:@"%@",
                               [df stringFromDate:datePicker.date]];
        fecha = datePicker.date;
    }
}

- (void) seleccionarFecha {
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Fecha del evento"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];
    
    //seleccionar fecha
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
        
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"fecha / hora"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(80.0f, 180.0f, 140.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(cambiarModoFecha) forControlEvents:UIControlEventValueChanged];
    [pickerViewPopup addSubview:closeButton];
    
    [datePicker setDate:self.evento.fecha];
    
    [pickerViewPopup addSubview:datePicker];
    [pickerViewPopup showInView:self.view];
    
    CGRect menuRect = pickerViewPopup.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    pickerViewPopup.frame = menuRect;
    
    CGRect pickerRect = datePicker.frame;
    pickerRect.origin.y = orgHeight+30;
    datePicker.frame = pickerRect;
    
}

- (void) cambiarModoFecha {
    if (datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        datePicker.datePickerMode = UIDatePickerModeDate;
    } else
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
}


-(void)SeleccionarMascota:(SeleccionarMascotaEventoViewController *)controller mascota:(Mascota *)mascota{
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:mascota.img90];
    
    [self.imgMascota setBounds:CGRectMake(0, 0, 28.0, 28.0)];
    [self.imgMascota.layer setCornerRadius:5.0];
    [self.imgMascota setClipsToBounds:YES];
    self.imgMascota.contentMode = UIViewContentModeScaleAspectFill;
    self.imgMascota.image = imagen;
    
    self.mascotalbl.text = mascota.nombre;
    self.evento.perteneceMascota = mascota;
    
}

-(void)ConfigAlarmaEvento:(EventoAvisosViewController *)controller indexEvento:(NSInteger)indexEvento{

    if (indexEvento == 10) {
        self.eventolbl.text = @"Ninguna";
        
    } else 
             self.eventolbl.text = [listaAvisos objectAtIndex:indexEvento];

    self.evento.aviso = [NSNumber numberWithInt:indexEvento];
    alarma = indexEvento;
    
    NSError *error = nil;
    if (![self.evento.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"Mascotas"]) {
               
        SeleccionarMascotaEventoViewController *listaMascotas = (SeleccionarMascotaEventoViewController *)[segue destinationViewController];
        
        listaMascotas.managedObjectContext = self.managedObjectContext;
        listaMascotas.delegado = (id)self;
    }
    
    if ([[segue identifier] isEqualToString:@"EventoAviso"]) {       
        UINavigationController *navController = segue.destinationViewController;
        EventoAvisosViewController *eventoAviso = [navController.viewControllers objectAtIndex:0];
        
        eventoAviso.alarma = [self.evento.aviso integerValue];
        if (eventoAviso.alarma < 10) {
            eventoAviso.tieneAlarma = TRUE;
        } else {
            eventoAviso.tieneAlarma = FALSE;
        }
        
        eventoAviso.fecha = fecha;
        eventoAviso.delegado = (id)self;
    }
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    [self seleccionarFecha];
                    
                default:
                    break;
            }
            break;
        case 3:
            [self.delegado cerrarEliminarEvento:self evento:self.evento fecha:self.evento.fecha];
       
        break;
        default:
            break;
    }
    
}

- (void) crearNotificacion:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo

{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
    
    localNotification.userInfo = userInfo;
    
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end