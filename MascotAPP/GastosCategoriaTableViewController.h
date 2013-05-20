//
//  GastosCategoriaTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GastosCategoria.h"
#import "CrearCategoriaGastoViewController.h"
#import "Gastos.h"

@protocol GastoCategoriaDelegado;

@interface GastosCategoriaTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, GastoNuevaCategoriaGastoDelegado>{
    NSArray *listaCategorias;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) Gastos *gasto;

@property (nonatomic, weak) id <GastoCategoriaDelegado> delegado;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end

@protocol GastoCategoriaDelegado

- (void)cerrarGastoCategoria:(GastosCategoriaTableViewController *)controller Categoria:(GastosCategoria *)categoria;

@end