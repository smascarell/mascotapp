//
//  CrearAnimalViewController.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"

@protocol CrearNuevoAnimalDelegado;

@interface CrearAnimalViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Animal *animal;
@property (nonatomic, strong) Mascota *mascota;

@property (weak, nonatomic) IBOutlet UITextField *txtNombreAnimal;

@property (nonatomic, weak) id <CrearNuevoAnimalDelegado> delegado;

@end

@protocol CrearNuevoAnimalDelegado

- (void) guardarAnimal:(Animal *) animal guardar:(BOOL)guardar controller:(CrearAnimalViewController *)controller;

@end
