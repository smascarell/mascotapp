//
//  AnimalTableViewController.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"
#import "AnimalCell.h"
#import "CrearAnimalViewController.h"
#import "EditarMascotaController.h"

@protocol AnimalDelegado;

@interface AnimalTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSIndexPath *selectedIndexPath;
}

@property (weak) id <AnimalDelegado> delegado;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) Mascota *mascota;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AnimalDelegado

-(void)seleccionaranimal:(AnimalTableViewController *)controller animal:(Animal *)animal;

@end
