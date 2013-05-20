//
//  CalendarioViewController.m
//  MascotAPP
//
//  Created by Samuel on 11/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarioViewController.h"

@implementation CalendarioViewController

@synthesize dataArray, dataDictionary;
@synthesize almacenEventos = _almacenEventos;

@synthesize listaEventos = _listaEventos;
@synthesize listaEventosMes = _listaEventosMes;
@synthesize listaEventosHOY = _listaEventosHOY;

@synthesize calendario = _calendario;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize delegado = _delegado;


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
    //return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);

}
- (IBAction)modoVista:(id)sender {
    [self.delegado calendarioCambiarModoVista:self];
}


-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    
    NSError *error = nil;
    EKEvent *evento = controller.event;
    
    switch (action) {
        case EKEventEditViewActionSaved:
            if (self.calendario == evento.calendar) {
                [self.listaEventos addObject:evento];
            }
            [self.almacenEventos saveEvent:evento span:EKSpanThisEvent error:&error];
            [self.tableView reloadData];
            break;
            
        case EKEventEditViewActionDeleted:
            if (self.calendario == evento.calendar) {
                [self.listaEventos removeObject:evento];
            }
            [self.almacenEventos removeEvent:evento span:EKSpanThisEvent error:&error];
            [self.tableView reloadData];
            break;
        case EKEventEditViewActionCanceled:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
}

-(EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller{
    
    return self.calendario;
}

-(void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action{
    EKEvent *evento = controller.event;
    switch (action) {
        case EKEventEditViewActionDeleted:
            if (self.calendario == evento.calendar) {
                [self.listaEventos removeObject:evento];
            }
            [self.tableView reloadData];            
        default:
            break;
    }
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidLoad{
	[super viewDidLoad];
    
    [self.monthView selectDate:[NSDate date]];
    
    
    TKDateInformation info = [[NSDate date] dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
    
    self.listaEventosHOY = [NSMutableArray arrayWithArray:[self fetchEventsForToday: myTimeZoneDay]];
     
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"CrearEvento"]) {
        UINavigationController *navController = segue.destinationViewController;
        
        EventoNuevoTableViewController *nuevoEventoControlador = [navController.viewControllers objectAtIndex:0];
        
        nuevoEventoControlador.delegado = (id)self;
        nuevoEventoControlador.managedObjectContext = self.managedObjectContext;

    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}
- (void) viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];
 
}

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
    self.listaEventosMes = [self monthEvents:startDate toDate:lastDate];
	NSArray *data = [NSArray arrayWithArray:self.listaEventosMes];
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
	// iterating date then times would go up and down based on daylight savings.
    
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit)
                                    fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
            
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
    
    NSArray *n = [data valueForKey:@"fecha"];
    
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
        if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
        
        NSString *dateCompare = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:d]];
        
       
        if ([n.description rangeOfString:dateCompare].length > 0 ) {
            [marks addObject:[NSNumber numberWithBool:YES]];
        } else [marks addObject:[NSNumber numberWithBool:NO]];

		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}

	return [NSArray arrayWithArray:marks];
}


- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	
	// CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];

    self.listaEventosHOY = [NSMutableArray arrayWithArray:[self fetchEventsForToday: myTimeZoneDay]];

    [self.tableView reloadData];
	
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
    
	[super calendarMonthView:mv monthDidChange:d animated:animated];
    
    //self.listaEventosMes = [self monthEvents:d];
    [self.monthView selectDate:d];
    
    // CHANGE THE DATE TO YOUR TIMEZONE
	TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *myTimeZoneDay = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone systemTimeZone]];
    
    self.listaEventosHOY = [NSMutableArray arrayWithArray:[self fetchEventsForToday: myTimeZoneDay]];
    
	[self.tableView reloadData];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
	
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    
    return self.listaEventosHOY.count;
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
  
    EventosAgenda *evento = [self.listaEventosHOY objectAtIndex:indexPath.row];
      
    cell.textLabel.text = evento.titulo;
    cell.detailTextLabel.text = evento.descripcion;

    if ([evento.hecho boolValue] == TRUE) {
        
        cell.imageView.image = [UIImage imageNamed:@"checked"];
    } else
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
    return cell;
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventosAgenda *evento = (EventosAgenda *)[self.listaEventosHOY objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MascotApp" bundle:[NSBundle mainBundle]];
    
    EventoEditarTableViewController *editarEventoControlador = (EventoEditarTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"EditarEvento"];
  
    editarEventoControlador.evento = evento;
    editarEventoControlador.delegado = (id)self;
    editarEventoControlador.managedObjectContext = self.managedObjectContext;
    editarEventoControlador.fetchedResultsController = self.fetchedResultsController;

    [self.navigationController pushViewController:editarEventoControlador animated:YES];    
}


-(void)cerrarGuardarEvento:(EventoNuevoTableViewController *)controller guardar:(BOOL)guardar fecha:(NSDate *)fecha{
   
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    
    if (guardar) {
        [self updateFetch:fecha];
    }
    
    [self.delegado actualizarBadgeEventos];
}

-(void)cerrarEditarEvento:(EventoEditarTableViewController *)controller guardar:(BOOL)guardar fecha:(NSDate *)fecha{
    
    [controller.navigationController popToRootViewControllerAnimated:YES];
    
    if (guardar) {
        [self updateFetch:fecha];
    }
    
    [self.delegado actualizarBadgeEventos];
}

-(void) cerrarEliminarEvento:(EventoEditarTableViewController *)controller evento:(EventosAgenda *)evento fecha:(NSDate *)fecha{
    
    [self.managedObjectContext deleteObject:evento];
        
    [self updateFetch:fecha];
    
    [controller.navigationController popViewControllerAnimated:YES];
    
    [self.delegado actualizarBadgeEventos];
}

- (void) updateFetch : (NSDate *)fecha{
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.listaEventos = [[NSMutableArray alloc]initWithArray:[self.fetchedResultsController fetchedObjects]];
    
    self.listaEventosHOY = [NSMutableArray arrayWithArray:[self fetchEventsForToday: fecha]];
    
    [self.monthView reload];
    [self.monthView selectDate:fecha];
    [self.tableView reloadData];
     
}

- (NSArray *)fetchEventsForToday:(NSDate *)startDate {
    // Create the predicate's start and end dates.
    
    NSDate *startingDate = [self dateAtBeginningOfDayForDate:startDate];
    NSDate *endDate = [self dateByAddingDay:1 toDate:startingDate];
          
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha <= %@ ",startingDate,endDate];
    NSArray *eventos = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate];
    
    return eventos;
}



-(NSMutableArray *) monthEvents:(NSDate *)startDate toDate:(NSDate *)lastDate{
    
    
    NSMutableArray *eventosMes;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha <= %@ ",startDate,lastDate];
    eventosMes = [NSMutableArray arrayWithArray:[self.listaEventos filteredArrayUsingPredicate:predicate]];
    
    return eventosMes;
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back       
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingDay:(NSInteger)numberOfDays toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:numberOfDays];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
	NSError *error;
	if (![_fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

@end