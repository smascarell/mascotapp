//
//  SeleccionarMascotaEventoViewController.h
//  MascotAPP
//
//  Created by Samuel on 14/08/12.
//
//

#import <UIKit/UIKit.h>
#import "Mascota.h"
#import "UIImage+RoundedCorner.h"
#import <QuartzCore/QuartzCore.h>
#import "CeldaListaMascotas.h"

@protocol SeleccionarMascota;

@interface SeleccionarMascotaEventoViewController : UITableViewController {
    NSArray *mascotas;
}

@property (nonatomic, weak) id <SeleccionarMascota> delegado;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@protocol SeleccionarMascota

- (void) SeleccionarMascota:(SeleccionarMascotaEventoViewController *)controller mascota:(Mascota *)mascota;

@end
