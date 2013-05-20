//
//  EKFunciones.h
//  MascotAPP
//
//  Created by Samuel on 26/10/12.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "EventosAgenda.h"
#import "Mascota.h"

@interface EKFunciones : NSObject {
    
    EKEventStore *eventStore; // evento en la agenda de iPhone
}

- (void) guardarEvento:(EventosAgenda *) evento editar:(BOOL) editar;
- (void) eliminarEvento:(EventosAgenda *) evento;
- (void) editarEvento:(EventosAgenda *) evento;
- (NSString *) guardarCumple:(Mascota *)mascota;
- (void) editarCumple:(Mascota *)mascota ekID:(NSString *)ekID;

@end
