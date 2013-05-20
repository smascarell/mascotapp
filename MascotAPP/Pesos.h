//
//  Pesos.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mascota;

@interface Pesos : NSManagedObject

@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSDecimalNumber * peso;
@property (nonatomic, retain) Mascota *perteneceMascota;

@end
