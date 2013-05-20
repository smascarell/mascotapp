//
//  MascotasTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "CeldaPersonalizada.h"
#import "NuevaCelda.h"
#import "CrearMascotaTableViewController.h"
#import "Mascota.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+RoundedCorner.h"

@interface MascotasTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, NuevaMascotaDelegado, UIActionSheetDelegate>
{
    NSIndexPath *indexPathDelete;
    
}

@property(nonatomic, copy) NSIndexPath *indexPathDelete;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
