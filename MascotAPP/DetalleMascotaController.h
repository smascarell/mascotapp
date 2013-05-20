//
//  DetalleMascotaController.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"
#import "EditarMascotaController.h"
#import "AmpliarFotoViewController.h"
#import "AnimalTableViewController.h"
#import "MBProgressHUD.h"
#import "SegmentedControlCell.h"
#import "UIImage+Resize.h"
#import "RazaTableViewController.h"

@interface DetalleMascotaController : UITableViewController <UIPickerViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, ActualizarAtributoMascota, AnimalDelegado, RazaDelegado, CambiarSexo> {
    NSString *textDate;
    BOOL editable;
    UIDatePicker *datePicker;   
    UIActionSheet *pickerViewPopup;
    UIImage *imagenNueva;
    BOOL fotoCamara;
}

@property (weak, nonatomic) IBOutlet UIImageView *foto;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editarVolver;
@property (weak, nonatomic) IBOutlet UIView *vistaCabecera;
@property (weak, nonatomic) IBOutlet UIButton *cambiarFechabtn;
@property (weak, nonatomic) IBOutlet UILabel *txtNacimiento;
@property (weak, nonatomic) IBOutlet UIButton *irGaleriaBoton;
@property (weak, nonatomic) IBOutlet UIButton *irGastosBoton;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) Mascota *mascota;
@property (strong) NSString *textDate;


- (NSString *)guardarImagenDisco:(NSString *)nombre imagen:(UIImage *)imagen;
- (void) insertarImagen;
- (NSString*) generarPath;

@end
