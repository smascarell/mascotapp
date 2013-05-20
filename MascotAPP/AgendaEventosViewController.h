//
//  AgendaEventosViewController.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/11/12.
//
//

#import <UIKit/UIKit.h>
#import "EventoNuevoTableViewController.h"
#import "EventoEditarTableViewController.h"
#import "EventoAgendaCell.h"
#import "Mascota.h"
#import "CalendarioViewController.h"
#import "EKFunciones.h"

@interface AgendaEventosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CalendarioVista, NuevoEvento,EditarEvento,CeldaEventoDelegado> {
    TKCalendarMonthView *calendar;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void) actualizarBadgeEventos;
- (void)actualizarHecho:(EventoAgendaCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end
