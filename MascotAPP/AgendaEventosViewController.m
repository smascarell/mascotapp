//
//  AgendaEventosViewController.m
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/11/12.
//
//

#import "AgendaEventosViewController.h"

@interface AgendaEventosViewController ()

@end

@implementation AgendaEventosViewController

@synthesize tableView = _tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"celda-mascota"]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        
        static NSString *identificadorCelda2 = @"CeldaNuevoEvento";
        UITableViewCell *celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }
        return celda;
    }
    
    static NSString *CellIdentifier = @"CeldaEvento";
    EventoAgendaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
 
    EventosAgenda *g = (EventosAgenda *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titulo.text = g.titulo;
    cell.nombreMascota.text = g.perteneceMascota.nombre;
    cell.delegado = (id)self;
    [cell setTag:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    if (g.fecha == NULL) {
        cell.detailTextLabel.text = @"";
    } else
        
        cell.fecha.text =  [NSString stringWithFormat:@"%@",
                            [df stringFromDate:g.fecha]];
    if ([g.hecho boolValue]) {
        [cell.imgHecho setImage:[UIImage imageNamed:@"checked"]];
    } else
        [cell.imgHecho setImage:[UIImage imageNamed:@"unchecked"]];
    
    NSData *pngData = [NSData dataWithContentsOfFile:g.perteneceMascota.img90];
    
    UIImage *image90 = [UIImage imageWithData:pngData];
    
    [cell.imgMascota setBounds:CGRectMake(0, 0, 60.0, 60.0)];
    [cell.imgMascota.layer setCornerRadius:5.0];
    [cell.imgMascota setClipsToBounds:YES];
    cell.imgMascota.image = image90;
    cell.imgMascota.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (void)actualizarHecho:(EventoAgendaCell *)cell atIndexPath:(NSIndexPath *)indexPath {
        
    EventosAgenda *g = (EventosAgenda *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Configure the cell...
 
    if ([g.hecho boolValue])
        [cell.imgHecho setImage:[UIImage imageNamed:@"checked"]];
    else
        [cell.imgHecho setImage:[UIImage imageNamed:@"unchecked"]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        return 50;
    }
    return 80;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EventosAgenda *eventoEliminar = (EventosAgenda *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        
        EKFunciones *ekf = [[EKFunciones alloc]init];
        [ekf eliminarEvento:eventoEliminar];
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self actualizarBadgeEventos];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] )
        return UITableViewCellEditingStyleNone;
    else return UITableViewCellEditingStyleDelete;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] )
        [self performSegueWithIdentifier:@"CrearEvento" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"CrearEvento"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        EventoNuevoTableViewController *nuevoEventoControlador = [navController.viewControllers objectAtIndex:0];
        
        nuevoEventoControlador.delegado = (id)self;
        nuevoEventoControlador.managedObjectContext = self.managedObjectContext;
    }
    if ([[segue identifier] isEqualToString:@"ModoCalendario"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        CalendarioViewController *calendario = [navController.viewControllers objectAtIndex:0];
        
        self.fetchedResultsController = nil;
        
        NSMutableArray *eventos = [[NSMutableArray alloc]initWithArray:[self.fetchedResultsController fetchedObjects]];
        calendario.listaEventos = eventos;
        calendario.managedObjectContext = self.managedObjectContext;
        calendario.fetchedResultsController = self.fetchedResultsController;
        calendario.delegado = (id)self;
    }
    
    if ([[segue identifier] isEqualToString:@"EditarEvento"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EventosAgenda *evento = (EventosAgenda *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        UINavigationController *navController = segue.destinationViewController;
        
        EventoEditarTableViewController *editarEventoControlador = [navController.viewControllers objectAtIndex:0];
        
        editarEventoControlador.evento = evento;
        editarEventoControlador.delegado = (id)self;
        editarEventoControlador.managedObjectContext = self.managedObjectContext;
    }
    
}

-(void) cerrarGuardarEvento:(EventoNuevoTableViewController *)controller guardar:(BOOL) guardar fecha:(NSDate *)fecha{
    if (guardar) {
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    [self actualizarBadgeEventos];
}
- (void) cerrarEditarEvento:(EventoNuevoTableViewController *)controller guardar:(BOOL) guardar fecha:(NSDate *)fecha{
    
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    if (guardar) {
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        self.fetchedResultsController = nil;
    }
    
    [self actualizarBadgeEventos];
}
- (void) cerrarEliminarEvento:(EventoEditarTableViewController *)controller evento:(EventosAgenda *)evento fecha:(NSDate *)fecha{
    
    EKFunciones *ekf = [[EKFunciones alloc]init];
    [ekf eliminarEvento:evento];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow]];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    [self actualizarBadgeEventos];
}


- (void)calendarioCambiarModoVista:(CalendarioViewController *)controller{
    [controller.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)cambiarEstadoEvento:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    EventosAgenda *evento = (EventosAgenda *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    if ([evento.hecho boolValue] == TRUE) {
        evento.hecho = [NSNumber numberWithBool:FALSE];
    } else evento.hecho = [NSNumber numberWithBool:TRUE];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }
    
    [self actualizarBadgeEventos];
}

- (void) actualizarBadgeEventos {
    
    UITabBarController *tabbarController = self.tabBarController;
    UITabBar *tb = tabbarController.tabBar;
    
    UITabBarItem *tbi = [tb.items objectAtIndex:0];
        
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hecho == NO and fecha<=%@",[NSDate date]];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    NSInteger countGastos = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    if (countGastos > 0)
        [tbi setBadgeValue:[NSString stringWithFormat:@"%i",countGastos]];
    else [tbi setBadgeValue:nil];
    
}

-(void)cambiarFRC:(BOOL) hecho{
    
    self.fetchedResultsController = nil;
    self.fetchedResultsController.delegate = nil;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:
                                @"( hecho == %@ )",[NSNumber numberWithBool:hecho ]]];
    
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:5];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    [self.tableView reloadData];
    
    
}
- (IBAction)tareasTodas:(id)sender {
    
    _fetchedResultsController = nil;
    _fetchedResultsController.delegate = nil;
    
    [self fetchedResultsController];
    
    [self.tableView reloadData];
}

- (IBAction)tareasRealizadas:(id)sender {
    
    [self cambiarFRC:TRUE];
}

- (IBAction)tareasPendientes:(id)sender {
    
    [self cambiarFRC:FALSE];
    
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
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
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
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self actualizarHecho:(EventoAgendaCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
    //[self.tableView reloadData];
}

@end
