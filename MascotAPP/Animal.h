//
//  Animal.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mascota, Raza;

@interface Animal : NSManagedObject

@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSSet *esRaza;
@property (nonatomic, retain) NSSet *perteceneMascota;
@end

@interface Animal (CoreDataGeneratedAccessors)

- (void)addEsRazaObject:(Raza *)value;
- (void)removeEsRazaObject:(Raza *)value;
- (void)addEsRaza:(NSSet *)values;
- (void)removeEsRaza:(NSSet *)values;

- (void)addPerteceneMascotaObject:(Mascota *)value;
- (void)removePerteceneMascotaObject:(Mascota *)value;
- (void)addPerteceneMascota:(NSSet *)values;
- (void)removePerteceneMascota:(NSSet *)values;

@end
