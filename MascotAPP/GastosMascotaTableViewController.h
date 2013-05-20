//
//  GastosMascotaTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 27/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"

@protocol GastoMascotaDelegado;

@interface GastosMascotaTableViewController : UITableViewController {
    NSFetchRequest *request;
    NSArray *arrayMascotas;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <GastoMascotaDelegado> delegado;

@end

@protocol GastoMascotaDelegado

- (void) cerrarGastoMascota:(Mascota*) mascota;

@end