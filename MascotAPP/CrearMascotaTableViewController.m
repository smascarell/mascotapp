//
//  CrearMascotaTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrearMascotaTableViewController.h"


@implementation CrearMascotaTableViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize context = _context;
@synthesize delegado = _delegado;

@synthesize mascota = _mascota;
@synthesize animal = _animal;

@synthesize txtNombre = _txtNombre;
@synthesize txtAnimal = _txtAnimal;
@synthesize txtRaza = _txtRaza;
@synthesize txtColor = _txtColor;
@synthesize txtChip = _txtChip;
@synthesize txtNacimiento = _txtNacimiento;
@synthesize imgFoto = _imgFoto;
@synthesize selectorSexo = _selectorSexo;
@synthesize RazaCell = _RazaCell;
@synthesize guardarBtn = _guardarBtn;
@synthesize modoEdicion = _modoEdicion;

@synthesize fetchedResultsController = _fetchedResultsController;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)cancelar:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
    
    self.txtNombre.delegate = self;
    self.txtAnimal.delegate = self;
    self.txtRaza.delegate = self;
    self.txtColor.delegate = self;
    self.txtChip.delegate = self;
    self.txtNacimiento.delegate = self;
       
    datePicker = [[UIDatePicker alloc] init];
    
    if (self.modoEdicion) {
        
        [self modoEdicionMascota];
        self.title = self.mascota.nombre;
        
    } else{
 
        [self.RazaCell setUserInteractionEnabled:NO];
        [self.imgFoto setContentMode:UIViewContentModeScaleAspectFit];
        [self.imgFoto setImage:[UIImage imageNamed:@"mascota-foto"]];
    }
}

-(void) modoEdicionMascota {
    
    tieneImagen = TRUE;
    
    if ([self.txtAnimal.text isEqualToString:nil])
        [self.RazaCell setUserInteractionEnabled:NO];
    else {
        [self.RazaCell setUserInteractionEnabled:YES];
        [self.RazaCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
      
    self.AnimalCell.imageView.image = [UIImage imageNamed:self.mascota.esAnimal.img];
    self.RazaCell.imageView.image = [UIImage imageNamed:self.mascota.esAnimal.img];

    [self.imgFoto setContentMode:UIViewContentModeScaleAspectFill];
    
    UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:self.mascota.img];
    
    [self.imgFoto setImage:imagen];
    
    self.txtNombre.text = self.mascota.nombre;
    self.animal = self.mascota.esAnimal;
    self.txtAnimal.text = self.animal.nombre;
    self.txtRaza.text = self.mascota.raza;
    self.txtChip.text = self.mascota.chip;
    self.txtColor.text = self.mascota.color;
    
    if ([self.mascota.sexo isEqualToString:@"Macho"]) {
        self.selectorSexo.selectedSegmentIndex = 0;
    } else {
        self.selectorSexo.selectedSegmentIndex = 1;
    }
    
    fechaNacimiento = self.mascota.nacimiento;
    
    if (fechaNacimiento == nil) {
        self.txtNacimiento.text = nil;
    } else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateStyle = NSDateFormatterMediumStyle;
        self.txtNacimiento.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.mascota.nacimiento]];
        [datePicker setDate:fechaNacimiento];
    }   
}

- (void)viewDidUnload
{
    [self setTxtNombre:nil];
    [self setTxtAnimal:nil];
    [self setTxtRaza:nil];
    [self setTxtColor:nil];
    [self setTxtChip:nil];
    [self setImgFoto:nil];
    [self setTxtNacimiento:nil];
    [self setSelectorSexo:nil];
    [self setRazaCell:nil];
    [self setGuardarBtn:nil];
    [self setCancelarBtn:nil];
    [self setAnimalCell:nil];
    [super viewDidUnload];
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

- (IBAction)salvar:(id)sender {
    
    [self.view endEditing:TRUE]; //dismiss keyboard
    
        if (!tieneImagen) {
            NSString * msgAlerta = [NSString stringWithFormat:@"Debes asignarle una foto a %@",self.txtNombre.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msgAlerta  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([self.txtNacimiento.text isEqualToString:@""]) {
            NSString * msgAlerta = [NSString stringWithFormat:@"Debes asignarle una fecha de nacimiento a %@",self.txtNombre.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msgAlerta  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }

    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.labelText = @"Guardando";
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = (id)self;
        
    // Show the HUD while the provided method executes in a new thread
        if (self.modoEdicion) 
            [HUD showWhileExecuting:@selector(editarMascota) onTarget:self withObject:nil animated:YES];
        else
            [HUD showWhileExecuting:@selector(insertarMascota) onTarget:self withObject:nil animated:YES];   
}

- (void) insertarMascota {
        
    self.mascota = [NSEntityDescription insertNewObjectForEntityForName:@"Mascota" inManagedObjectContext:self.context];
    
    //Actualizar las propiedades de la mascota
    
    self.mascota.nombre = self.txtNombre.text;
    self.mascota.esAnimal = self.animal;
    self.mascota.raza = self.txtRaza.text;
    self.mascota.color = self.txtColor.text;
    self.mascota.chip = self.txtChip.text;
    
    if ([self.selectorSexo selectedSegmentIndex] == 0) {
        self.mascota.sexo = @"Macho";
    } else {
        self.mascota.sexo = @"Hembra";
    }
    
    UIImage* image = self.imgFoto.image;
    UIImage* smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640.0f, 360.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage* smallImage90 = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(180.0f, 180.0f) interpolationQuality:kCGInterpolationHigh];
    
    self.mascota.img = [self guardarImagenDisco:[self generarPath] imagen:smallImage];
    self.mascota.img90 = [self guardarImagenDisco:[self generarPath] imagen:smallImage90];

    self.mascota.nacimiento = fechaNacimiento;
    
    EKFunciones *ekf = [EKFunciones new];
       
    self.mascota.nacimientoEKID = [ekf guardarCumple:self.mascota];
    
    [self.delegado crearMascota:self];  
}

- (void) editarMascota{
    
    self.mascota.nombre = self.txtNombre.text;
    self.mascota.esAnimal = self.animal;
    self.mascota.raza = self.txtRaza.text;
    self.mascota.color = self.txtColor.text;
    self.mascota.chip = self.txtChip.text;
    
    if ([self.selectorSexo selectedSegmentIndex] == 0) {
        self.mascota.sexo = @"Macho";
    } else {
        self.mascota.sexo = @"Hembra";
    }
    
    UIImage* image = self.imgFoto.image;
    UIImage* smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640.0f, 360.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage* smallImage90 = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(180.0f, 180.0f) interpolationQuality:kCGInterpolationHigh];
    
    self.mascota.img = [self guardarImagenDisco:[self generarPath] imagen:smallImage];
    self.mascota.img90 = [self guardarImagenDisco:[self generarPath] imagen:smallImage90];
    
    self.mascota.nacimiento = fechaNacimiento;
    
    EKFunciones *ekf = [EKFunciones new];
        
    [ekf editarCumple:self.mascota ekID:self.mascota.nacimientoEKID];
    
    [self.delegado crearMascota:self];
}

- (IBAction)seleccionarFoto:(id)sender {
    
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
	HUD.labelText = @"Guardando imagen";
    
	
	//Get image
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	//Display in ImageView object (if you want to display it
    [self.imgFoto setContentMode:UIViewContentModeScaleAspectFill];
	self.imgFoto.image = image;
    
	//Take image picker off the screen (required)
	
    [HUD showWhileExecuting:@selector(insertarImagen) onTarget:self withObject:nil animated:YES];
    
    if (fotoCamara) {
        NSParameterAssert(image);
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    tieneImagen = TRUE;
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = (id)self;
	HUD.labelText = @"Guardando imagen";
    //imagenNueva = image;
       
    [self.imgFoto setImage:image];
    tieneImagen = TRUE;
    
	[HUD showWhileExecuting:@selector(insertarImagen) onTarget:self withObject:nil animated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void) insertarImagen {
    
    [self.tableView reloadData];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            self.txtNacimiento.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
            fechaNacimiento = datePicker.date;
        }
    }
    if (actionSheet.tag == 2) {
        if (buttonIndex == 0){
            fotoCamara = YES;
            [self hacerFoto];
            
        }
            
        else if (buttonIndex == 1){
             fotoCamara = NO;
            [self seleccionarFotodeGaleria];
        }
            
    }   
    
}

- (IBAction)seleccFecha:(id)sender {
    
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
    datePicker.datePickerMode = UIDatePickerModeDate;
    [pickerViewPopup addSubview:datePicker];
    [pickerViewPopup showInView:[UIApplication sharedApplication].keyWindow];
    
    CGRect menuRect = pickerViewPopup.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    pickerViewPopup.frame = menuRect;
     
    CGRect pickerRect = datePicker.frame;
    pickerRect.origin.y = orgHeight;
    datePicker.frame = pickerRect;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"Animal"]) {
        UINavigationController *navController = segue.destinationViewController;
        AnimalTableViewController *a = [navController.viewControllers objectAtIndex:0];
        
        a.managedObjectContext = self.context;
        a.mascota = self.mascota;
        a.delegado = (id)self;
    }
    if ([[segue identifier] isEqualToString:@"Raza"]) {
        UINavigationController *navController = segue.destinationViewController;
        RazaTableViewController *r = [navController.viewControllers objectAtIndex:0];
        r.animal = self.animal;
        r.delegado = (id)self;
        r.managedObjectContext = self.context;
    }
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


- (NSString*)generarPath {	
	NSTimeInterval timeIntervalSeconds = [NSDate timeIntervalSinceReferenceDate];
	unsigned long long nanoseconds = (unsigned long long) floor(timeIntervalSeconds * 1000000);	
	return [NSString stringWithFormat:@"%qu.jpg", nanoseconds];
}


-(void)seleccionaranimal:(AnimalTableViewController *)controller animal:(Animal *)animal{
    self.animal = animal;
    self.txtAnimal.text = animal.nombre;
    self.AnimalCell.imageView.image = [UIImage imageNamed:animal.img];
    self.txtRaza.text = NULL;
    
    [self.RazaCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [self.RazaCell setUserInteractionEnabled:YES];
    
    self.RazaCell.imageView.image = [UIImage imageNamed:animal.img];
    
    [controller dismissModalViewControllerAnimated:YES];
    
    [self.tableView reloadData];
    
}

-(void)seleccionarRaza:(RazaTableViewController *)controller raza:(Raza *)raza{
    self.txtRaza.text = raza.nombre;
    [controller.navigationController dismissModalViewControllerAnimated:YES];
}

@end
