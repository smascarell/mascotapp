//
//  EventoAvisosViewController.h
//  MascotAPP
//
//  Created by Samuel on 14/09/12.
//
//

#import <UIKit/UIKit.h>

@protocol EventoAvisos;

@interface EventoAvisosViewController : UITableViewController {
    NSArray * listaAvisos;
}

@property (nonatomic, weak) id <EventoAvisos> delegado;
@property (nonatomic) BOOL tieneAlarma;
@property (nonatomic) NSInteger alarma;
@property (strong,nonatomic) NSDate *fecha;

@end

@protocol EventoAvisos

- (void) ConfigAlarmaEvento:(EventoAvisosViewController *)controller indexEvento:(NSInteger)indexEvento;

@end
