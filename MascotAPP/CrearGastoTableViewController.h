//
//  CrearGastoTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gastos.h"
#import "GastosPreviosTableViewController.h"
#import "GastosCategoria.h"
#import "GastosCategoriaTableViewController.h"
#import "GastosMascotaTableViewController.h"
#import "SeleccionarMascotaEventoViewController.h"
#import "GastosNombre.h"
#import "Mascota.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@protocol CreaGastoDelegado;

@interface CrearGastoTableViewController : UITableViewController <GastoPrevioDelegado,GastoCategoriaDelegado,SeleccionarMascota, UITextFieldDelegate,UIPickerViewDelegate, UIActionSheetDelegate> {
    
    NSDate *fechaNacimiento;
    UIDatePicker *datePicker;
    UIActionSheet *pickerViewPopup;
    UIPickerView *pickerView;
    NSMutableString *precioValor;
    NSDecimalNumber *precioGasto;

}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITextField *txtGastoTitulo;
@property (weak, nonatomic) IBOutlet UITextField *txtGastoPrecio;
@property (weak, nonatomic) IBOutlet UITextField *txtGastoFecha;
@property (weak, nonatomic) IBOutlet UITextField *txtGastoCategoria;
@property (weak, nonatomic) IBOutlet UITextField *txtGastoMascota;

@property (weak, nonatomic) IBOutlet UIImageView *imgMascotaicono;

@property (nonatomic, assign) BOOL modoedicion;
@property (nonatomic, retain) NSMutableString *precioValor;

@property (strong, nonatomic) Gastos *gasto;
@property (strong, nonatomic) GastosCategoria *gastoCategoria;
@property (strong, nonatomic) GastosNombre *gastoNombre;
@property (strong, nonatomic) Mascota *mascota;


@property (nonatomic, weak) id <CreaGastoDelegado> delegado;

- (void)guardarEdicion;
- (void)guardarNuevo;
- (void)guardarGastoNombre;
- (void) guardarEventoGasto : (Gastos *) gasto;

@end

@protocol CreaGastoDelegado

- (void)cerraGastoPrevio:(CrearGastoTableViewController *)controller Guardar:(BOOL)guardar;

@end
