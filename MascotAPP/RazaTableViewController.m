//
//  RazaTableViewController.m
//  MascotAPP
//
//  Created by Samuel Mascarell on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RazaTableViewController.h"

@interface RazaTableViewController ()

@end

@implementation RazaTableViewController

@synthesize delegado;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize animal = _animal;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects] + 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] ) {
        
        static NSString *identificadorCelda2 = @"NuevaRazaCell";
        UITableViewCell *celda = (NuevaCelda *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }
        celda.imageView.image = [UIImage imageNamed:self.animal.img];
        return celda;
    }

    static NSString *cellIdentifier = @"RazaCell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = (UITableViewCell *)[[UITableViewCell alloc]
                              initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Raza *r = (Raza *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = r.nombre;
    cell.imageView.image = [UIImage imageNamed:r.perteneceAnimal.img];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"CrearRaza"]) {
        
        CrearRazaViewController *nuevaRaza = (CrearRazaViewController *)[segue destinationViewController]; 
        
        nuevaRaza.delegado = (id)self;
        nuevaRaza.animal = self.animal;
        nuevaRaza.managedObjectContext = self.managedObjectContext;
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    } 
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Selecciona la Raza";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Si la raza de tu animal no existe, puedes crearla y añadirla a la lista";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] )  {
         [self performSegueWithIdentifier:@"CrearRaza" sender:self];
         return;
    }
    Raza *r = (Raza *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [delegado seleccionarRaza:self raza:r];
}

- (IBAction)cancelar:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)guardarRaza:(NSString *)nombre guardar:(BOOL)guardar{
    
    if (guardar && nombre != nil) {
        Raza *raza = [NSEntityDescription insertNewObjectForEntityForName:@"Raza"
                                                   inManagedObjectContext:self.managedObjectContext];
        raza.nombre = nombre;
        raza.perteneceAnimal = self.animal;
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Raza" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"perteneceAnimal == %@", self.animal];
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = (id)self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return self.fetchedResultsController;
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
            //[self configureCell:(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

//+(NSArray *)objectsForEntityNamed:(NSString *)name withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
//    
//    NSFetchRequest *req = [[NSFetchRequest alloc] init];
//    [req setEntity:entity];
//    [req setPredicate:predicate];
//    NSError *error = nil;
//    
//    NSArray *array = [context executeFetchRequest:req error:&error];
//    
//    if (array == nil){
//        NSException *exception = [NSException exceptionWithName:(NSString *) exception reason:[error localizedDescription] userInfo:nil];
//        
//        [exception raise];
//        
//    }
//    return array;  
//}


@end
