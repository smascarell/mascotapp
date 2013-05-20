//
//  EventosAgenda.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mascota;

@interface EventosAgenda : NSManagedObject

@property (nonatomic, retain) NSNumber * aviso;
@property (nonatomic, retain) NSString * calendario;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSNumber * hecho;
@property (nonatomic, retain) NSString * mascota;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) Mascota *perteneceMascota;

@end
