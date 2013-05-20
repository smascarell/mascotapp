//
//  CalendarioViewController.h
//  MascotAPP
//
//  Created by Samuel on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "NSDate+Reporting.h"
#import "EventosAgenda.h"
#import "EventoEditarTableViewController.h"
#import "EventoNuevoTableViewController.h"

@protocol CalendarioVista;

@interface CalendarioViewController : TKCalendarMonthTableViewController <EKEventViewDelegate,EKEventEditViewDelegate,TKCalendarMonthViewDataSource, TKCalendarMonthViewDelegate, EditarEvento, NuevoEvento, NSFetchedResultsControllerDelegate> {
    
	NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
                                                                                
}

@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) EKEventStore *almacenEventos;
@property (strong) NSMutableArray *listaEventos;
@property (strong) NSMutableArray *listaEventosMes;

@property (strong) EKCalendar *calendario;
@property (strong) NSMutableArray *listaEventosHOY;

@property (nonatomic, weak) id <CalendarioVista> delegado;

- (NSMutableArray *)monthEvents:(NSDate *)startDate toDate:(NSDate *)lastDate;
- (NSArray *)fetchEventsForToday:(NSDate *)startDate;
- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
- (NSDate *)dateByAddingDay:(NSInteger)numberOfDays toDate:(NSDate *)inputDate;

@end

@protocol CalendarioVista

- (void) calendarioCambiarModoVista:(CalendarioViewController *)controller;
- (void) actualizarBadgeEventos;

@end
