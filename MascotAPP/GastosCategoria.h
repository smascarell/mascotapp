//
//  GastosCategoria.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gastos;

@interface GastosCategoria : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *gasto;
@end

@interface GastosCategoria (CoreDataGeneratedAccessors)

- (void)addGastoObject:(Gastos *)value;
- (void)removeGastoObject:(Gastos *)value;
- (void)addGasto:(NSSet *)values;
- (void)removeGasto:(NSSet *)values;

@end
