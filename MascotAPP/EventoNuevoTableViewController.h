//
//  EventoNuevoTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import <UIKit/UIKit.h>
#import "EventosAgenda.h"
#import "EventoNuevoSimpleCell.h"
#import "EventoHechoCell.h"
#import "EventoNuevoTextoViewController.h"
#import <TapkuLibrary/TapkuLibrary.h>
#import "SeleccionarMascotaEventoViewController.h"
#import "EventoAvisosViewController.h"
#import <EventKit/EventKit.h>
#import "EKFunciones.h"

@protocol NuevoEvento;

@interface EventoNuevoTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPickerViewDelegate,
                                            UIActionSheetDelegate, UITextFieldDelegate,UITextViewDelegate, EventoNuevoTexto,SeleccionarMascota, EventoAvisos> {
    
    NSString * calendario;
    NSDate * fecha;
    BOOL hecho;
    NSArray *listaAvisos;
                                    
    int alarma;
    
    UIDatePicker *datePicker;
    UIActionSheet *pickerViewPopup;
    UIPickerView *pickerView;
    Mascota *esMascota;
                                                
    EKEventStore *eventStore; // evento en la agenda de iPhone
    
}

@property (nonatomic, weak) id <NuevoEvento> delegado;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (weak, nonatomic) IBOutlet UILabel *mascotalbl;
@property (weak, nonatomic) IBOutlet UILabel *fechalbl;
@property (weak, nonatomic) IBOutlet UIButton *hechoBoton;
@property (weak, nonatomic) IBOutlet UIImageView *imgHecho;
@property (weak, nonatomic) IBOutlet UIImageView *imgMascota;
@property (weak, nonatomic) IBOutlet UILabel *Eventolbl;

- (void) seleccionarFecha;

@end

@protocol NuevoEvento

-(void) cerrarGuardarEvento:(EventoNuevoTableViewController *)controller guardar:(BOOL) guardar fecha:(NSDate *)fecha;

@end

