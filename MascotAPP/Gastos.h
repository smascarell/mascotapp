//
//  Gastos.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GastosCategoria, GastosNombre, Mascota;

@interface Gastos : NSManagedObject

@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSDecimalNumber * precio;
@property (nonatomic, retain) GastosCategoria *categoria;
@property (nonatomic, retain) Mascota *perteceneMascota;
@property (nonatomic, retain) GastosNombre *tienenombre;

@end
