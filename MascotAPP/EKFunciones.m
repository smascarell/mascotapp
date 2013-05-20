//
//  EKFunciones.m
//  MascotAPP
//
//  Created by Samuel on 26/10/12.
//
//

#import "EKFunciones.h"

@implementation EKFunciones


-(id) init {
    if ((self = [super init])) {
        eventStore = [[EKEventStore alloc]init];
    }
    return self;
}

- (void) guardarEvento:(EventosAgenda *) evento editar:(BOOL) editar {

    EKEvent *eventoE;
    if (editar) {
        eventoE = [eventStore eventWithIdentifier:evento.eventID];
    } else {
        eventoE = [EKEvent eventWithEventStore:eventStore];
        eventoE.calendar = eventStore.defaultCalendarForNewEvents;
    }
    
    eventoE.title = evento.titulo;
    eventoE.allDay = NO;
    eventoE.startDate = evento.fecha;
    eventoE.endDate = evento.fecha;
     
    eventoE.alarms = nil;
    
    NSError *error;
    BOOL guardado = [eventStore saveEvent:eventoE span:EKSpanThisEvent error:&error];
    
    if (!guardado && error) {
        NSLog(@"%@",[error localizedDescription]);
    } else {
        evento.eventID = eventoE.eventIdentifier;
    }    
}

- (void) eliminarEvento:(EventosAgenda *) evento{
    
    EKEvent *eventoE = [eventStore eventWithIdentifier:evento.eventID];
    NSError *error;
    BOOL eliminado = [eventStore removeEvent:eventoE span:EKSpanThisEvent error:&error];
    if (!eliminado && error)
        NSLog(@"%@",[error localizedDescription]);
}

- (void) editarEvento:(EventosAgenda *) evento {
    
    [self guardarEvento:evento editar:YES];
    
}

- (NSString *) guardarCumple:(Mascota *)mascota{
    
    EKEvent *eventoE;

    eventoE = [EKEvent eventWithEventStore:eventStore];
    eventoE.calendar = eventStore.defaultCalendarForNewEvents;
    
    NSString *nombreCumple = [NSString stringWithFormat:@"Cumpleaños de %@",mascota.nombre];

    eventoE.title = nombreCumple;
    eventoE.allDay = YES;
    eventoE.startDate = mascota.nacimiento;
    eventoE.endDate = [mascota.nacimiento dateByAddingTimeInterval:10];
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:nil];
    
    [eventoE addRecurrenceRule:rule];

    NSError *error;
    BOOL guardado = [eventStore saveEvent:eventoE span:EKSpanThisEvent error:&error];
    
    if (!guardado && error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    return eventoE.eventIdentifier;
}

- (void) editarCumple:(Mascota *)mascota ekID:(NSString *)ekID{
    
    EKEvent *eventoE = [eventStore eventWithIdentifier:ekID];
    
    if (eventoE == nil) {
        [self guardarCumple:mascota];
        return;
    }
    
    NSString *nombreCumple = [NSString stringWithFormat:@"Cumpleaños de %@",mascota.nombre];

    eventoE.title = nombreCumple;
    eventoE.allDay = YES;
    eventoE.startDate = mascota.nacimiento;
    eventoE.endDate = [mascota.nacimiento dateByAddingTimeInterval:10];
    
    EKRecurrenceRule *rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:nil];
    
    [eventoE addRecurrenceRule:rule];
           
    NSError *error;
    BOOL guardado = [eventStore saveEvent:eventoE span:EKSpanFutureEvents error:&error];
    
    if (!guardado && error) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

@end