//
//  EventoEditarTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 14/08/12.
//
//

#import <UIKit/UIKit.h>
#import "EventosAgenda.h"
#import "SeleccionarMascotaEventoViewController.h"
#import "EventoAvisosViewController.h"
#import <EventKit/EventKit.h>
#import "EKFunciones.h"
#import <QuartzCore/QuartzCore.h>

@protocol EditarEvento;

@interface EventoEditarTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPickerViewDelegate,
UIActionSheetDelegate, UITextFieldDelegate,UITextViewDelegate, SeleccionarMascota, EventoAvisos>  {
    
    NSDate * fecha;
    BOOL hecho;
    NSInteger alarma;
    NSArray *listaAvisos;
    UIDatePicker *datePicker;
    UIActionSheet *pickerViewPopup;
    UIPickerView *pickerView;
}


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) EventosAgenda *evento;

@property (nonatomic, weak) id <EditarEvento> delegado;

@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtDescripcion;
@property (weak, nonatomic) IBOutlet UILabel *mascotalbl;
@property (weak, nonatomic) IBOutlet UILabel *fechalbl;
@property (weak, nonatomic) IBOutlet UILabel *eventolbl;
@property (weak, nonatomic) IBOutlet UIButton *hechoBoton;
@property (weak, nonatomic) IBOutlet UIImageView *imgHecho;
@property (weak, nonatomic) IBOutlet UIImageView *imgMascota;

- (void) seleccionarFecha;
- (void) cambiarModoFecha;
- (void) crearNotificacion:(NSDate*) fireDate
                      text:(NSString*) alertText
                    action:(NSString*) alertAction
                     sound:(NSString*) soundfileName
               launchImage:(NSString*) launchImage
                   andInfo:(NSDictionary*) userInfo;


@end

@protocol EditarEvento

-(void) cerrarEditarEvento:(EventoEditarTableViewController *)controller guardar:(BOOL) guardar fecha:(NSDate *)fecha;

-(void) cerrarEliminarEvento:(EventoEditarTableViewController *)controller evento:(EventosAgenda *)evento fecha:(NSDate *)fecha;

@end