//
//  EditarMascotaController.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"

@protocol ActualizarAtributoMascota;

@interface EditarMascotaController : UIViewController <UITextFieldDelegate> {
    BOOL editarFecha; 
}

@property (nonatomic, weak) id <ActualizarAtributoMascota> delegado;
@property (nonatomic, strong) NSManagedObject *objetoEditado;


@property (weak, nonatomic) IBOutlet UITextField *txtObjeto;

@property (nonatomic, strong) NSString *objetoKey;
@property (nonatomic, strong) NSString *objetoNombre;
@property (readwrite) BOOL editarFecha;

@end

@protocol ActualizarAtributoMascota

- (void)cerrarEdicionMascota:(EditarMascotaController *)controller cerrarGuardar:(BOOL)guardar;

@end
