//
//  DetalleMascotaController.m
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetalleMascotaController.h"


@implementation DetalleMascotaController

bool celdasinicial;

@synthesize foto = _foto;
@synthesize vistaCabecera = _vistaCabecera;
@synthesize txtNacimiento = _txtNacimiento;
@synthesize irGaleriaBoton = _irGaleriaBoton;
@synthesize irGastosBoton = _irGastosBoton;
@synthesize cambiarFechabtn = _cambiarFechabtn;
@synthesize editarVolver = _editarVolver;


@synthesize context = _context;
@synthesize mascota = _mascota;
@synthesize textDate = _textDate;

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
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = YES;
    
    UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:self.mascota.img];
    [imagen resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320.0f, 180.0f) interpolationQuality:kCGInterpolationHigh];
        
    if (imagen == nil) {
        self.foto.image = [UIImage imageNamed:@"82-dog-paw@2x"];
    } else {
    
        self.foto.image = imagen;
        //[self.foto setContentMode:UIViewContentModeScaleAspectFill];
        //[self.foto setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        //[self.foto setContentMode:UIViewContentModeScaleAspectFill];
        //[self.foto setClipsToBounds:YES];
    }
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    
    [self.tableView setBackgroundView:image];
}
    
- (void)viewDidUnload
{
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self setFoto:nil];
    [self setEditarVolver:nil];
    [self setVistaCabecera:nil];
    [self setTxtNacimiento:nil];
    [self setCambiarFechabtn:nil];
    [self setTxtNacimiento:nil];
    [self setIrGaleriaBoton:nil];
    [self setIrGastosBoton:nil];
    [super viewDidUnload];

}

- (void) viewWillAppear:(BOOL)animated{
    
    //Inicializar correctamente los controles de la vista.
    self.clearsSelectionOnViewWillAppear = YES;
     
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Nombre";
            break;
        case 1:
            return @"Animal y Raza";
            break;
        case 2:
            return @"Color";
            break;
        case 3:
            return @"Sexo";
            break;
        case 4:
            return @"Microchip";
            break;
        case 5:
            return @"Fecha de nacimiento";
            break;           
        default:
            return @"";
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    
    //Nombre
    if (indexPath.section == 0 ) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
        
        EditarMascotaController *em = [storyboard instantiateViewControllerWithIdentifier:@"EditarMascotaController"];
                                
        em.objetoKey = @"nombre";
        em.objetoNombre = NSLocalizedString(@"nombre", nil);
        em.editarFecha = NO;
        
        em.objetoEditado = self.mascota;
        em.delegado = self;
        
        [self.navigationController pushViewController:em animated:YES];
    }
    
    //Animal
    if (indexPath.section == 1) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
        
        if (indexPath.row == 0) {
            AnimalTableViewController *a = [storyboard instantiateViewControllerWithIdentifier:@"AnimalTableViewController"];
            
            a.mascota = self.mascota;
            a.delegado = self;
            a.managedObjectContext = self.context;
            [self.navigationController presentModalViewController:a animated:YES];
 
        } else{
            RazaTableViewController *r = [storyboard instantiateViewControllerWithIdentifier:@"RazaTableViewController"];
            r.animal = self.mascota.esAnimal;
            r.delegado = (id)self;
            r.managedObjectContext = self.context;
            [self.navigationController presentModalViewController:r animated:YES];

        }
    }
    
    //Color
    if (indexPath.section == 2 ) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
        
        EditarMascotaController *em = [storyboard instantiateViewControllerWithIdentifier:@"EditarMascotaController"];
        
        em.objetoKey = @"color";
        em.objetoNombre = NSLocalizedString(@"color", nil);
        em.editarFecha = NO;
        
        em.objetoEditado = self.mascota;
        em.delegado = self;
        [self.navigationController pushViewController:em animated:YES];

        
    }
    //Chip
    if (indexPath.section == 4 ) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
        
        EditarMascotaController *em = [storyboard instantiateViewControllerWithIdentifier:@"EditarMascotaController"];
        
        em.objetoKey = @"chip";
        em.objetoNombre = NSLocalizedString(@"chip", nil);
        em.editarFecha = NO;
        
        em.objetoEditado = self.mascota;
        em.delegado = self;
        
        [self.navigationController pushViewController:em animated:YES];
    }

    if (indexPath.section == 5) {
        
        [self seleccFecha];
    }


   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Nombre de tu mascota, aparecerá en var las secciones";
            break;
        case 1:
            return @"Selecciona el animal y la raza correspondiente";
            break;
        case 2:
        case 3:
        case 4:
        case 5:    
            break;
          
        default:
            break;
    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CeldaDetalle";
    static NSString *CeldaSelector = @"CeldaSelector";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.mascota.nombre;
            cell.imageView.image = [UIImage imageNamed:@"38-icon-pencil"];
            break;
            
        case 1: {
               if (indexPath.row == 0)
               {
                   cell.textLabel.text = self.mascota.esAnimal.nombre;
               }
               else{
                   cell.textLabel.text = self.mascota.raza; 
               }
            cell.imageView.image = [UIImage imageNamed:@"38-icon-list"];
        }
            break;
            
        case 2:
            cell.textLabel.text = self.mascota.color;
            cell.imageView.image = [UIImage imageNamed:@"38-icon-pencil"];
            break;
            
        case 3:
        {
            SegmentedControlCell *cell = [tableView dequeueReusableCellWithIdentifier:CeldaSelector];
            if (cell == nil) {
                cell = [[SegmentedControlCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CeldaSelector];
            }
            cell.delegado = self;
            
            if ([self.mascota.sexo isEqualToString:@"Macho"]) {
                [cell.selectorsexo setSelectedSegmentIndex:0];
            } else [cell.selectorsexo setSelectedSegmentIndex:1];
            
            return cell;
        }
        case 4:
            cell.textLabel.text = self.mascota.chip;
            break;
            
        case 5:
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            [df setLocale:[NSLocale currentLocale]];
      
            if (self.mascota.nacimiento == NULL) {
                cell.textLabel.text = @"";
            } else
                cell.textLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.mascota.nacimiento]];
            cell.imageView.image = [UIImage imageNamed:@"38-icon-list"];
            break;
        }
                      
        default:
            break;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 30.0;
    } else return 44.0;
}

- (void)machohembra:(NSInteger *)segmento{
    if (segmento == 0) {
        self.mascota.sexo = @"Macho";
    } else self.mascota.sexo = @"Hembra";
    
    NSError *error;
    if (![self.mascota.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) cerrarEdicionMascota:(EditarMascotaController *)controller cerrarGuardar:(BOOL)guardar{
    
    if (guardar) {
        NSError *error;
        NSManagedObjectContext *addingManagedObjectContext = [controller.objetoEditado managedObjectContext];
        if (![addingManagedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.tableView reloadData];
    } 
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) insertarImagen {
    
//    self.mascota.img = [self guardarImagenDisco:[self generarPath]
//                                         imagen:[self scale:imagenNueva toSize:CGSizeMake(320.0, 180.0)] ];
//    self.mascota.img90 = [self guardarImagenDisco:[self generarPath]
//                                      imagen:[self scale:imagenNueva toSize:CGSizeMake(90.0, 90.0)] ];
    
//    self.mascota.img = [self guardarImagenDisco:[self generarPath] imagen:imagenNueva];
//    self.mascota.img90 = [self guardarImagenDisco:[self generarPath] imagen:imagenNueva ];
    
    UIImage* image = imagenNueva;
    UIImage* smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320.0f, 180.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage* smallImage90 = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(90.0f, 90.0f) interpolationQuality:kCGInterpolationHigh];
    
    self.mascota.img = [self guardarImagenDisco:[self generarPath] imagen:smallImage];
    self.mascota.img90 = [self guardarImagenDisco:[self generarPath] imagen:smallImage90];
                        
    NSError *error;
    if (![self.mascota.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}

- (NSString *)guardarImagenDisco:(NSString *)nombre imagen:(UIImage *)imagen
{
    NSData *pngData = UIImageJPEGRepresentation(imagen, 1);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:nombre];
    [pngData writeToFile:filePath atomically:YES]; 
    return [documentsPath stringByAppendingPathComponent:nombre]; 
}

- (NSString*) generarPath
{	
	NSTimeInterval timeIntervalSeconds = [NSDate timeIntervalSinceReferenceDate];
	unsigned long long nanoseconds = (unsigned long long) floor(timeIntervalSeconds * 1000000);
	
	return [NSString stringWithFormat:@"%qu.jpg", nanoseconds];
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size,YES,0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
}


- (void)seleccFecha {
    if (pickerViewPopup != nil) {
        pickerViewPopup = nil;
    }
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Fecha de nacimiento"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];
    
    pickerViewPopup.tag = 1;
    
    //seleccionar fecha
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
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

- (IBAction)Volver:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)seleccionaranimal:(AnimalTableViewController *)controller animal:(Animal *)animal{
    
    self.mascota.esAnimal = animal;
    self.mascota.animal = animal.nombre;
    self.mascota.raza = nil;
     
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
    [controller.navigationController popViewControllerAnimated:YES]; 
}

-(void)seleccionarRaza:(RazaTableViewController *)controller raza:(Raza *)raza{
    self.mascota.raza = raza.nombre;
    raza.perteneceAnimal = self.mascota.esAnimal;
    
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    [controller.navigationController popViewControllerAnimated:YES]; 

}

- (IBAction)cambiarFoto:(id)sender {
    if (pickerViewPopup != nil) {
        pickerViewPopup = nil;
    }
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Capturar Foto",@"Seleccionar Existente",nil];
    
    pickerViewPopup.tag = 2;
    
    [pickerViewPopup showInView:self.view];
    
    CGRect menuRect = pickerViewPopup.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 0; //height of picker
    menuRect.size.height = orgHeight;
    pickerViewPopup.frame = menuRect;
}


- (void)hacerFoto {
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

-(void) seleccionarFotodeGaleria {
    
    UIImagePickerController *galeriaController = [UIImagePickerController new];
    galeriaController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [galeriaController setDelegate:(id)self];
    [self presentModalViewController:galeriaController animated:YES];
    
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = (id)self;
	HUD.labelText = @"Actualizando imagen";
    
	
	//Get image
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imagenNueva = image;
    
	//Display in ImageView object (if you want to display it
	self.foto.image = image;
    
	//Take image picker off the screen (required)
	
    [HUD showWhileExecuting:@selector(insertarImagen) onTarget:self withObject:nil animated:YES];

    if (fotoCamara) {
        NSParameterAssert(image);
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = (id)self;
	HUD.labelText = @"Actualizando imagen";
    imagenNueva = image;
    
    [self.foto setImage:image];
    
	[HUD showWhileExecuting:@selector(insertarImagen) onTarget:self withObject:nil animated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
      if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            self.txtNacimiento.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
            self.mascota.nacimiento = datePicker.date;
            NSError *error;
            if (![self.mascota.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self.tableView reloadData];
        }
      }
    
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            fotoCamara = YES;
            [self hacerFoto];

        }
        else if (buttonIndex == 1){
            fotoCamara = NO;
            [self seleccionarFotodeGaleria];
        }
    }
  
}

@end
