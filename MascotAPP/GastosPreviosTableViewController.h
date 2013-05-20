//
//  GastosPreviosTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gastos.h"
#import "GastosNombre.h"
#import "CrearNombreGastoViewController.h"

@protocol GastoPrevioDelegado;

@interface GastosPreviosTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, GastoNuevoNombreDelegado> {
    NSArray *listaDeNombres;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchRequest *fetchedRequest;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) Gastos *gasto;
@property (strong, nonatomic) GastosNombre *gastoNombre;

@property (nonatomic, weak) id <GastoPrevioDelegado> delegado;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol GastoPrevioDelegado

- (void)cerrarGastoPrevio:(GastosPreviosTableViewController *)controller GastoNombre:(GastosNombre *)nombre Actualizar:(BOOL)actualizar;

@end