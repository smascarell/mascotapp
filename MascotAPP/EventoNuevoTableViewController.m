//
//  EventoNuevoTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import "EventoNuevoTableViewController.h"

@interface EventoNuevoTableViewController ()

@end

@implementation EventoNuevoTableViewController
@synthesize txtTitulo;
@synthesize txtDescripcion;
@synthesize mascotalbl;
@synthesize fechalbl;
@synthesize hechoBoton;
@synthesize imgHecho;
@synthesize imgMascota;
@synthesize Eventolbl;


- (IBAction)cancelar:(id)sender {
    [self.delegado cerrarGuardarEvento:self guardar:NO fecha:nil];
    
}
- (IBAction)guardar:(id)sender {
  
    if ( [self.txtTitulo.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Debes escribir un título para la tarea"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if( [self.fechalbl.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Elige una fecha para la tarea"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }else if ([self.mascotalbl.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Elige una mascota"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

        else{
            EventosAgenda *g = [NSEntityDescription insertNewObjectForEntityForName:@"Evento"
                                                             inManagedObjectContext:self.managedObjectContext];
            g.fecha = fecha;
            g.titulo = self.txtTitulo.text;
            g.descripcion = self.txtDescripcion.text;
            g.mascota = self.mascotalbl.text;
            g.hecho = [NSNumber numberWithBool:hecho];
            g.perteneceMascota = esMascota;
            g.aviso = [NSNumber numberWithInt:alarma];
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
                [self crearNotificacion:fecha text:self.txtTitulo.text action:nil sound:nil launchImage:nil andInfo:nil];
            }

            EKFunciones *ekf = [[EKFunciones alloc]init];
            [ekf guardarEvento:g editar:NO];
            
            [self.delegado cerrarGuardarEvento:self guardar:YES fecha:g.fecha];
    } 
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
    eventStore = [[EKEventStore alloc]init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            eventStore = [[EKEventStore alloc]init];
            // perform the main thread here to avoid any delay. normally seems to be 10 to 15 sec delay.
        
            if (!granted){
                
                //----- codes here when user NOT allow your app to access the calendar.
                
            }
   
        }];
        
    }
    
    hecho = TRUE;
    calendario = nil;
    fecha = [NSDate date];
    
    alarma = 10;
   
    self.txtTitulo.delegate = self;
    self.txtDescripcion.delegate = self;
    
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];

    listaAvisos = [NSArray arrayWithObjects:@"En la hora indicada", @"15 minutos antes",@"30 minutos antes",@"1 hora antes", @"1 día antes",@"1 semana antes", nil];
    
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
    
    [datePicker setDate:[NSDate date]];
    
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
    esMascota = mascota;
    
}

-(void)ConfigAlarmaEvento:(EventoAvisosViewController *)controller indexEvento:(NSInteger)indexEvento{
    
    if (indexEvento == 10) {
        self.Eventolbl.text = @"Ninguna";
    } else  self.Eventolbl.text = [listaAvisos objectAtIndex:indexEvento];
    
    alarma = indexEvento;
    
}

-(void)ActualizarTextoEvento:(EventoNuevoTextoViewController *)controller texto:(NSString *)texto indexPath:(NSIndexPath *)indexPath{
    
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"NuevoTexto"]) {
              
        EventoNuevoTextoViewController *nuevoEventoTextoControlador =  (EventoNuevoTextoViewController *)[segue destinationViewController];
    
        nuevoEventoTextoControlador.indexPath = [self.tableView indexPathForSelectedRow];
        nuevoEventoTextoControlador.delegado = (id)self;
    }
    if ([[segue identifier] isEqualToString:@"Mascotas"]) {
   
        //UINavigationController *navController = segue.destinationViewController;
        //SeleccionarMascotaEventoViewController *listaMascotas = [navController.viewControllers objectAtIndex:0];
        
        SeleccionarMascotaEventoViewController *listaMascotas = (SeleccionarMascotaEventoViewController *)[segue destinationViewController];
      
        listaMascotas.managedObjectContext = self.managedObjectContext;
        listaMascotas.delegado = (id)self;
    }
    
    if ([[segue identifier] isEqualToString:@"EventoAviso"]) {
        
            UINavigationController *navController = segue.destinationViewController;
            EventoAvisosViewController *eventoAviso = [navController.viewControllers objectAtIndex:0];
            
            eventoAviso.alarma = 10;
            eventoAviso.tieneAlarma = FALSE;
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
