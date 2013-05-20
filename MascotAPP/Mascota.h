//
//  Mascota.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Animal, EventosAgenda, Gastos, Pesos;

@interface Mascota : NSManagedObject

@property (nonatomic, retain) NSString * animal;
@property (nonatomic, retain) NSString * chip;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * img90;
@property (nonatomic, retain) NSDate * nacimiento;
@property (nonatomic, retain) NSString * nacimientoEKID;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * raza;
@property (nonatomic, retain) NSString * sexo;
@property (nonatomic, retain) Animal *esAnimal;
@property (nonatomic, retain) NSSet *tieneEvento;
@property (nonatomic, retain) NSSet *tieneGastos;
@property (nonatomic, retain) NSSet *tienePeso;
@end

@interface Mascota (CoreDataGeneratedAccessors)

- (void)addTieneEventoObject:(EventosAgenda *)value;
- (void)removeTieneEventoObject:(EventosAgenda *)value;
- (void)addTieneEvento:(NSSet *)values;
- (void)removeTieneEvento:(NSSet *)values;

- (void)addTieneGastosObject:(Gastos *)value;
- (void)removeTieneGastosObject:(Gastos *)value;
- (void)addTieneGastos:(NSSet *)values;
- (void)removeTieneGastos:(NSSet *)values;

- (void)addTienePesoObject:(Pesos *)value;
- (void)removeTienePesoObject:(Pesos *)value;
- (void)addTienePeso:(NSSet *)values;
- (void)removeTienePeso:(NSSet *)values;

@end
