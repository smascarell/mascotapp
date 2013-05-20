//
//  RazaTableViewController.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Raza.h"
#import "NuevaCelda.h"
#import "CrearRazaViewController.h"
#import <CoreData/CoreData.h>
#import "Animal.h"

@protocol RazaDelegado;

@interface RazaTableViewController : UITableViewController <CrearNuevaRazaDelegado>

@property (weak) id <RazaDelegado> delegado;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@property (strong, nonatomic) Animal *animal;

@end


@protocol RazaDelegado

-(void)seleccionarRaza:(RazaTableViewController *)controller raza:(Raza *)raza;

@end
