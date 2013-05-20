//
//  AppDelegate.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MascotasTableViewController.h"
#import "GastosTableViewController.h"
#import "AgendaEventosViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UITabBarController *tabbarController;
}

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)customizeGlobalTheme;
- (void) actualizarBadgeEventos;
- (void) guardarBadgeEventos;

@end
