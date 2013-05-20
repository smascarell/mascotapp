//
//  GastosGeneral.m
//  MascotAPP
//
//  Created by Samuel on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GastosTableViewController.h"


@implementation GastosTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

@synthesize gastolbl = _gastolbl;
@synthesize gasto = _gasto;
@synthesize graficoPorMes = _graficoPorMes;
@synthesize btnVerGrafico = _btnVerGrafico;

@synthesize tableView = _tableView;


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    sortDate1 = [NSDate date];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];
    [self.btnVerGrafico setEnabled:FALSE];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidUnload
{
 
    //[self setOrdenarMascotabtn:nil];
    [self setGastolbl:nil];
    [self setBtnVerGrafico:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self actualizarTotal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)nuevoGastobtn:(id)sender {
    [self performSegueWithIdentifier:@"CrearGasto" sender:self];
}

-(void) actualizarTotal {
    
    NSNumber *sum = [self.fetchedResultsController.fetchedObjects
                     valueForKeyPath:@"@sum.precio"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setMinimumFractionDigits:2];
    [f setMaximumFractionDigits:2];
    
    NSString *precio = [f stringFromNumber: sum];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int year  = [[formatter stringFromDate:sortDate1] intValue];
       
    self.gastolbl.text = [NSString stringWithFormat:@"%i : %@",year,precio];
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.tableView.userInteractionEnabled) {
        [[self.tableView.superview viewWithTag:7] removeFromSuperview];
        [self.tableView setUserInteractionEnabled:YES];

    }
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
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        return 1;
    }
   return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        return 1;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([[self.fetchedResultsController sections] count] == 0) {
//        return 44;
//    }
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
//    
//    if (indexPath.row == [sectionInfo numberOfObjects] ) {
//        return 44;
//    } 
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([[self.fetchedResultsController sections] count] == 0)
        return nil;
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Gastos" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity1];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"perteceneMascota.nombre == %@",[sectionInfo name]];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error);
    }

    NSNumber *sum = [results valueForKeyPath:@"@sum.precio"];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setMinimumFractionDigits:2];
    [f setMaximumFractionDigits:2];
    
    NSString *precio = [f stringFromNumber: sum];
    
    NSString *nombreGasto = [[NSString alloc]initWithFormat:@"%@ - %@",[sectionInfo name],precio];
        
    return nombreGasto;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.fetchedResultsController.fetchedObjects count] == 0 ) {
        
        static NSString *identificadorCelda2 = @"CeldaNuevoGasto";
        UITableViewCell *celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }
        return celda;
    }

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    NSInteger nsection = [sectionInfo numberOfObjects];

    if (indexPath.row == nsection) {
        
        static NSString *identificadorCelda2 = @"CeldaNuevoGasto";
        UITableViewCell *celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        if (celda == nil) {
            celda = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identificadorCelda2];
        }        
        return celda;
    }
    
    static NSString *CellIdentifier = @"CeldaGasto";
    
    CeldaGastos *cell = (CeldaGastos *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = (CeldaGastos *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    Gastos *g = (Gastos *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    cell.lblCategoria.text = g.categoria.nombre;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setMinimumFractionDigits:2];
    [f setMaximumFractionDigits:2];
    
    NSString *precio = [f stringFromNumber: g.precio];
    
    cell.lblPrecio.text = precio;
    cell.lblDesc.text = g.tienenombre.nombre;
    
    if (g.fecha != NULL) {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateStyle:NSDateFormatterMediumStyle];
        
        cell.lblfecha.text = [NSString stringWithFormat:@"%@",[df stringFromDate:g.fecha]];
    } else cell.lblfecha.text = @"";
    
    if (g.perteceneMascota.img90 != NULL) {
        UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:g.perteceneMascota.img90];
        
        [cell.imgMascota setBounds:CGRectMake(0, 0, 28.0, 28.0)];
        [cell.imgMascota.layer setCornerRadius:5.0];
        [cell.imgMascota setClipsToBounds:YES];
        cell.imgMascota.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgMascota.image = imagen;
        
    } else {
        UIImage *image = [UIImage imageNamed:@"82-dog-paw@2x"];
        cell.imgMascota.image = image;
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.fetchedResultsController.fetchedObjects count] != 0 ){
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        return YES;
    }

    else  {
        self.navigationItem.leftBarButtonItem = nil;
        return NO;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.fetchedResultsController.fetchedObjects count] != 0 ) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        
        NSInteger nsection = [sectionInfo numberOfObjects];
        if (indexPath.row == nsection) return UITableViewCellEditingStyleNone;
        
        else return UITableViewCellEditingStyleDelete;
    }
    
    
    else return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    
    NSInteger nsection = [sectionInfo numberOfObjects];
    
    if (indexPath.row == nsection) return;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
         
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.fetchedResultsController.fetchedObjects count] )
        [self performSegueWithIdentifier:@"CrearGasto" sender:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"celda-mascota"]];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSPredicate *predicate;
    switch (buttonIndex) {
        case 0 :
            return;
        case 1: //Año actual
            predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", [NSDate firstDayOfCurrentYear], [NSDate date]];
            sortDate1 = [NSDate firstDayOfCurrentYear];
            [self.btnVerGrafico setEnabled:TRUE];
            self.graficoPorMes = TRUE;
            break;
        case 2: //Año anterior
            predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", [NSDate firstDayOfPreviousYear], [NSDate firstDayOfCurrentYear]];
            sortDate1 = [NSDate firstDayOfPreviousYear];
            [self.btnVerGrafico setEnabled:TRUE];
            self.graficoPorMes = TRUE;
            break;
        case 3: {
            [self seleccionarAAnterior:actionSheet];
            self.graficoPorMes = TRUE;
            [self.btnVerGrafico setEnabled:TRUE];
            return;
            break;
        }   
        case 4: //Todo
            predicate = nil;
            //Tomamos el año 2000 como fecha mas antigua
            sortDate1 = [NSDate dateWithYear:2000 month:1 day:1];
            self.graficoPorMes = FALSE;
            [self.btnVerGrafico setEnabled:FALSE];
            break;
        default:
            break;
    }
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    [self actualizarTotal];
}

- (IBAction)cambiarFechas:(id)sender {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int year  = [[formatter stringFromDate:[NSDate date]] intValue];
  
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancelar" otherButtonTitles:[NSString stringWithFormat:@"Año %i",year],[NSString stringWithFormat:@"Año %i",year-1], @"Seleccionar año", @"Todo", nil];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    actionSheet.tag = 10;
 }


-(void)seleccionarAAnterior:(UIActionSheet *)actionSheet {
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    pickerYearViewPopup = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    
    [pickerYearViewPopup setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    //Get Current Year into i2
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    
    //Create Years Array from 2000 to This year
    years = [[NSMutableArray alloc] init];
    for (int i=i2; i>=1990; i--) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    [pickerYearViewPopup addSubview:pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancelar"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(230, 7.0f, 80.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(cancelYearSelector) forControlEvents:UIControlEventValueChanged];
    [pickerYearViewPopup addSubview:closeButton];
    
    [pickerYearViewPopup showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [pickerYearViewPopup setBounds:CGRectMake(0, 0, 320, 485)];
    [self.tableView reloadData];
    [self actualizarTotal];

 
}

-(void) cancelYearSelector{
    [pickerYearViewPopup dismissWithClickedButtonIndex:0 animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [years count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [years objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    NSString *str= [years objectAtIndex:row];
    
    int value = [str intValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:value];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    sortDate1 = [cal dateFromComponents:comps];
    
    [comps setDay:31];
    [comps setMonth:12];
    [comps setYear:value];
    
    sortDate2 = [cal dateFromComponents:comps];
    
    NSPredicate  *predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha <= %@", sortDate1,sortDate2];
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    [self actualizarTotal];
    [pickerYearViewPopup dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)seleccionFecha:(id)sender
{
    UIButton *bt = sender;
    NSPredicate *predicate;
    switch (bt.tag) {
            
        //Seleccionar año de la lista
            
        case 1001:
            [self.tableView setUserInteractionEnabled:YES];
            [[self.tableView.superview viewWithTag:7] removeFromSuperview];
            [self seleccionarAAnterior:(UIActionSheet *)sender];
            break;
        
        // Año pasado
            
        case 1002:
            [self.tableView setUserInteractionEnabled:YES];
             predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", [NSDate firstDayOfPreviousYear], [NSDate firstDayOfCurrentYear]];
            [[self.tableView.superview viewWithTag:7] removeFromSuperview];
            sortDate1 = [NSDate firstDayOfPreviousYear];
            break;
        
        // Año Actual
            
        case 1003:
            [self.tableView setUserInteractionEnabled:YES];
            predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha < %@", [NSDate firstDayOfCurrentYear], [NSDate date]];
            [[self.tableView.superview viewWithTag:7] removeFromSuperview];
            sortDate1 = [NSDate firstDayOfCurrentYear];
            break;
            
        //Todos
            
        case 1004:
            [self.tableView setUserInteractionEnabled:YES];
            //predicate = nil;
            predicate = nil;
            [[self.tableView.superview viewWithTag:7] removeFromSuperview];
            sortDate1 = [NSDate dateWithYear:2007 month:1 day:1];
            break;
            
        default:
            break;
    }
    
    
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    NSError *error = nil;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    [self actualizarTotal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"CrearGasto"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        CrearGastoTableViewController *nuevoGasto = [navController.viewControllers objectAtIndex:0];
                             
        nuevoGasto.modoedicion = FALSE;
        nuevoGasto.delegado = (id)self;
        nuevoGasto.managedObjectContext = self.managedObjectContext;
        nuevoGasto.fetchedResultsController = self.fetchedResultsController;
    }
    
    if ([[segue identifier] isEqualToString:@"EditarGasto"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navController = segue.destinationViewController;
        
        CrearGastoTableViewController *editarGasto = [navController.viewControllers objectAtIndex:0];
        
        editarGasto.modoedicion = TRUE;
               
        Gastos *gasto = (Gastos *)[[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];

        editarGasto.gasto = gasto;
        editarGasto.delegado = (id)self;
        editarGasto.managedObjectContext = self.managedObjectContext;
    }
    
    if ([[segue identifier] isEqualToString:@"cambiarFechas"]) {
        
            UINavigationController *navController = segue.destinationViewController;
            
            GastosSeleccionarFechasViewController *dates = [navController.viewControllers objectAtIndex:0];
            dates.delegado = self;
    }
    
    if ([[segue identifier] isEqualToString:@"GastosGrafico"]) {
        GastosGraficoViewController *grafico = segue.destinationViewController;
        grafico.fetchedResultsController = self.fetchedResultsController;
        grafico.managedObjectContext = self.managedObjectContext;
        grafico.fecha = sortDate1;
        grafico.porMes = self.graficoPorMes;
    } 
}

- (void)cerraGastoPrevio:(CrearGastoTableViewController *)controller Guardar:(BOOL)guardar{
   
    [controller.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)dates:(GastosSeleccionarFechasViewController *)controller date1:(NSDate *)date1 date2:(NSDate *)date2 actualizar:(BOOL)actualizar{
     
    if (actualizar) {
        NSPredicate *predicate;
       
        if (date1 == nil) {
            predicate = nil;
            
        }
        else{
            predicate = [NSPredicate predicateWithFormat:@"fecha >= %@ AND fecha <= %@", date1, date2];
            }
        
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        NSError *error = nil;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
         
        [self.tableView reloadData];
        [self actualizarTotal];
    }
    
    [controller.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSSortDescriptor *ordenarDescriptor;
    NSSortDescriptor *ordenarDescriptor2;
    
    NSArray *sortDescriptors;
    
    NSString *sectionNameKeyPath;
    
    ordenarDescriptor = [[NSSortDescriptor alloc] initWithKey:@"perteceneMascota.nombre" ascending:NO];
    
    ordenarDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"fecha" ascending:NO];
    sectionNameKeyPath = @"perteceneMascota.nombre";
    sortDescriptors = [NSArray arrayWithObjects:ordenarDescriptor, ordenarDescriptor2, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Gastos" 
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
        
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
                                                             initWithFetchRequest:fetchRequest 
                                                             managedObjectContext:self.managedObjectContext 
                                                             sectionNameKeyPath:sectionNameKeyPath
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}  

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSInteger nsection = [self.fetchedResultsController.sections count];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if (nsection == 1 && [sectionInfo numberOfObjects] == 1) {
                    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];

            }
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            if (nsection == 0 && [sectionInfo numberOfObjects] == 0)
                break;
            
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
           [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
        {
            
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
  
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            break;
        }
        case NSFetchedResultsChangeUpdate:
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
    [self actualizarTotal];
}


@end
