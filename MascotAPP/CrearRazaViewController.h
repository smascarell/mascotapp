//
//  CrearRazaViewController.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Raza.h"

@protocol CrearNuevaRazaDelegado

-(void)guardarRaza:(NSString *)nombre guardar:(BOOL)guardar;

@end

@interface CrearRazaViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtRaza;

@property (nonatomic, strong) Raza *raza;

@property (nonatomic, strong) Animal *animal;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) id <CrearNuevaRazaDelegado> delegado;

@end
