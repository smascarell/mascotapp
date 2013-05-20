//
//  CrearMascotaTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"
#import "Animal.h"
#import "Raza.h"
#import "AnimalTableViewController.h"
#import "RazaTableViewController.h"
#import <TapkuLibrary/TapkuLibrary.h>
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"
#import "EKFunciones.h"

@protocol NuevaMascotaDelegado;


@interface CrearMascotaTableViewController : UITableViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, RazaDelegado>

{
    CGFloat animatedDistance;
    UIDatePicker *datePicker;   
    UIPickerView *pickerView;
    UIPickerView *pickerViewPhoto;
    NSDate *fechaNacimiento;
    UIActionSheet *pickerViewPopup;
    NSArray *listaAnimales;
    BOOL fotoCamara;
    BOOL tieneImagen;
}


@property (nonatomic, weak) id <NuevaMascotaDelegado> delegado;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (strong) NSFetchedResultsController * fetchedResultsController; 

@property (nonatomic, strong) Mascota *mascota;
@property (strong, nonatomic) Animal *animal;
@property (strong, nonatomic) Raza *raza;

@property (nonatomic) BOOL modoEdicion;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelarBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *guardarBtn;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtAnimal;
@property (weak, nonatomic) IBOutlet UITextField *txtRaza;
@property (weak, nonatomic) IBOutlet UITextField *txtColor;
@property (weak, nonatomic) IBOutlet UITextField *txtChip;
@property (weak, nonatomic) IBOutlet UITextField *txtNacimiento;
@property (weak, nonatomic) IBOutlet UIImageView *imgFoto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectorSexo;
@property (unsafe_unretained, nonatomic) IBOutlet UITableViewCell *RazaCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *AnimalCell;

- (NSString *)guardarImagenDisco:(NSString *)nombre imagen:(UIImage *)imagen;
- (NSString *) generarPath;

- (void)insertarMascota;
- (void) editarMascota;

- (void) modoEdicionMascota;

@end

@protocol NuevaMascotaDelegado

- (void)crearMascota:(CrearMascotaTableViewController *)controller;

@end