//
//  CrearCategoriaGastoViewController.h
//  MascotAPP
//
//  Created by Samuel on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GastosCategoria.h"

@protocol GastoNuevaCategoriaGastoDelegado;

@interface CrearCategoriaGastoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtNombreCategoria;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id <GastoNuevaCategoriaGastoDelegado> delegado;
@property (strong, nonatomic) GastosCategoria *categoria;

@end

@protocol GastoNuevaCategoriaGastoDelegado

- (void)cerrarNuevaCategoriaGasto:(CrearCategoriaGastoViewController *)controller Gasto:(GastosCategoria *)categoria;

@end
