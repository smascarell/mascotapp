//
//  CrearNombreGastoViewController.h
//  MascotAPP
//
//  Created by Samuel on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GastosNombre.h"
#import <QuartzCore/QuartzCore.h>

@protocol GastoNuevoNombreDelegado;

@interface CrearNombreGastoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtNombreGasto;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id <GastoNuevoNombreDelegado> delegado;
@property (strong, nonatomic) GastosNombre *nombre;

@end

@protocol GastoNuevoNombreDelegado

- (void)cerrarNuevoNombreGasto:(CrearNombreGastoViewController *)controller Nombre:(GastosNombre *)nombre;

@end
