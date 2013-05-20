//
//  MascotasTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MascotasTableViewController.h"

@interface MascotasTableViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MascotasTableViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize indexPathDelete = _indexPathDelete;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
}

- (void)viewDidUnload
{ 
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData]; // reload data just in case there is a modification from gastos
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
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
        
        static NSString *identificadorCelda2 = @"NuevaMascotaCell";
        NuevaCelda *celda = (NuevaCelda *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (NuevaCelda *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }
        celda.texto.text = [NSString stringWithFormat:@"Crear mascota"];
        [celda.icono setImage:[UIImage imageNamed:@"mascotas-icon"]];
        return celda;
    }
    
    static NSString *identificadorCelda = @"CeldaPersonalizada";
    CeldaPersonalizada *celda = (CeldaPersonalizada *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda];
    
    if (celda == nil) {
        celda = (CeldaPersonalizada *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda];
    }

	[self configureCell:celda atIndexPath:indexPath];
    return celda;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    cell.backgroundColor = [UIColor whiteColor];
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"celda-mascota"]];
}


- (void)configureCell:(CeldaPersonalizada *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    Mascota *m = (Mascota *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.lblNombre.text = m.nombre;
    cell.lblAnimal.text = m.esAnimal.nombre;
    
    UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:m.img90];
        
    [cell.imgFoto setBounds:CGRectMake(0, 0, 60.0, 60.0)];
    [cell.imgFoto.layer setCornerRadius:5.0];
    [cell.imgFoto setClipsToBounds:YES];
    cell.imgFoto.image = imagen;
    cell.imgFoto.contentMode = UIViewContentModeScaleAspectFill;
    
    if (m.nacimiento != nil) {
        NSDate* birthday = m.nacimiento;
        
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSYearCalendarUnit | NSMonthCalendarUnit
                                           fromDate:birthday
                                           toDate:now
                                           options:0];
        NSInteger nyears = [ageComponents year];
        NSInteger nmonths = [ageComponents month];
        
        
        NSString *years = [NSString stringWithFormat:@"%d años",nyears];
        NSString *months = [NSString stringWithFormat:@" y %d meses",nmonths];
        
        NSString *ageText = [years stringByAppendingString:months];
        
        cell.lblEdad.text = ageText;
    } else {
        cell.lblEdad.text = nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Gastos" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity1];
   
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"perteceneMascota == %@",m];
    
    NSError *error = nil;
    NSInteger countGastos = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }
    
    cell.nGastos.text = [NSString stringWithFormat:@"%d", countGastos];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
       
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"perteneceMascota == %@ AND hecho == NO",m];
    NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error]; 

    if (error) {
        NSLog(@"ERROR: %@", error);
    }
            
    if (count > 0)
        [cell.indicadorTareasPendientes setImage:[UIImage imageNamed:@"indicador"]];
    else
        [cell.indicadorTareasPendientes setImage:[UIImage imageNamed:@"indicador-vacio"]];
    
    cell.nTareas.text = [NSString stringWithFormat:@"%d", count];
}

#pragma mark - Table view delegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *confirmDelete = [[UIActionSheet alloc] initWithTitle:@"Se va proceder a eliminar tu mascota, junto con los eventos y gastos relacionados"
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:@"Cancelar"
                                                 otherButtonTitles:@"Aceptar", nil];
        
        confirmDelete.delegate = self;
        
        [confirmDelete setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [confirmDelete showFromTabBar:self.navigationController.tabBarController.tabBar];
        self.indexPathDelete = indexPath;
    } 
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] )
        return UITableViewCellEditingStyleNone;
    else return UITableViewCellEditingStyleDelete;

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:self.indexPathDelete]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        return 50;
    }
    return 80;
}

- (void) crearMascota:(CrearMascotaTableViewController *)controller{
    
    [controller.navigationController dismissModalViewControllerAnimated:YES];
    NSError *error;
        
    NSManagedObjectContext *addingManagedObjectContext = [controller context];
    if (![addingManagedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
       
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        [self performSegueWithIdentifier: @"CrearMascota" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"CrearMascota"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        CrearMascotaTableViewController *nuevoMascotaControlador = [navController.viewControllers objectAtIndex:0];
        
        nuevoMascotaControlador.delegado = (id)self;
        nuevoMascotaControlador.context = self.managedObjectContext;
        nuevoMascotaControlador.modoEdicion = FALSE;
    }
    
     
    if ([[segue identifier] isEqualToString:@"EditarMascota"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Mascota *detalleMascota = (Mascota *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        UINavigationController *navController = segue.destinationViewController;
        CrearMascotaTableViewController *detalleController = [navController.viewControllers objectAtIndex:0];
        
        detalleController.context = self.managedObjectContext;
        detalleController.mascota = detalleMascota;
        detalleController.delegado = self;
        detalleController.modoEdicion = TRUE;
    }  

}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mascota" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
}


@end
