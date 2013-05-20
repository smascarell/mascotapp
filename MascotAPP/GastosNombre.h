//
//  GastosNombre.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gastos;

@interface GastosNombre : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *gastos;
@end

@interface GastosNombre (CoreDataGeneratedAccessors)

- (void)addGastosObject:(Gastos *)value;
- (void)removeGastosObject:(Gastos *)value;
- (void)addGastos:(NSSet *)values;
- (void)removeGastos:(NSSet *)values;

@end
