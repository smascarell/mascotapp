//
//  SeleccionarMascotaEventoViewController.m
//  MascotAPP
//
//  Created by Samuel on 14/08/12.
//
//

#import "SeleccionarMascotaEventoViewController.h"

@interface SeleccionarMascotaEventoViewController ()


@end

@implementation SeleccionarMascotaEventoViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mascota" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];

	NSError *error = nil;

    mascotas = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return mascotas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CeldaListaMascotas *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Mascota *m = (Mascota *)[mascotas objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
                               
    UIImage *imagen = [[UIImage alloc] initWithContentsOfFile:m.img90];
    
    [cell.imagenMascota setBounds:CGRectMake(0, 0, 28.0, 28.0)];
    [cell.imagenMascota.layer setCornerRadius:5.0];
    [cell.imagenMascota setClipsToBounds:YES];
    cell.imagenMascota.contentMode = UIViewContentModeScaleAspectFill;
    cell.imagenMascota.image = imagen;

    cell.nombreMascota.text = m.nombre;
    
   return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegado SeleccionarMascota:self mascota:[mascotas objectAtIndex:indexPath.row]];
}

@end
