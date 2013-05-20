//
//  EventoAvisosViewController.m
//  MascotAPP
//
//  Created by Samuel on 14/09/12.
//
//

#import "EventoAvisosViewController.h"

@interface EventoAvisosViewController ()

@end

@implementation EventoAvisosViewController

@synthesize tieneAlarma = _tieneAlarma;
@synthesize alarma = _alarma;
@synthesize fecha = _fecha;

- (IBAction)guardarAlarma:(id)sender {
    
    [self.delegado ConfigAlarmaEvento:self indexEvento:self.alarma];
    [self dismissModalViewControllerAnimated:YES];
}

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
        
    listaAvisos = [NSArray arrayWithObjects:@"En la hora indicada", @"15 minutos antes",@"30 minutos antes",@"1 hora antes", @"1 día antes",@"1 semana antes", nil];

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
    if (self.tieneAlarma) {
        return 2;
    } else
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Configurar una alarma de aviso";
            break;
        case 1:
            if (self.tieneAlarma) {
                return @"Selecciona una alarma de la lista";
            }
             else return @"";
            break;
        default:
            break;
    }
    return @"";

}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (!self.tieneAlarma) {
                return @"No tienes ninguna alarma configurada para esta tarea";
            } else  {
                NSString *sfecha;
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                df.dateStyle = NSDateFormatterLongStyle;
                
                sfecha = [NSString stringWithFormat:@"Esta tarea tiene una alarma configurada el día %@",
                                      [df stringFromDate:self.fecha]];
                return sfecha;
            }
            break;
        case 1:
            return nil;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return listaAvisos.count;
            break;
        default:
            return 1;
    }
}


- (void) mostrarLista:(id)sender {
        
    self.tieneAlarma = !self.tieneAlarma;
    
    UISwitch* switchControl = sender;
    
    if (!switchControl.on) {
        self.alarma = 10;
    } else {
        self.alarma = 0;
    }
  
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID_0 = @"ActivarAlarmaCell";
    static NSString *CellID_1 = @"Cell";
    
    if (indexPath.section == 0) {
        
        UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:CellID_0];
        
        if (aCell == nil) {
            aCell = [tableView dequeueReusableCellWithIdentifier:CellID_0];
        }

        aCell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        aCell.textLabel.text = @"Activar alarma";
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        aCell.accessoryView = switchView;
        [switchView setOn:self.tieneAlarma animated:NO];
        [switchView addTarget:self action:@selector(mostrarLista:) forControlEvents:UIControlEventValueChanged];
         return aCell;
        
    } else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID_1];
        
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellID_1];
        }
        if (self.alarma == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else  cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.text = [listaAvisos objectAtIndex:indexPath.row];
        [cell setHidden:!self.tieneAlarma];
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.alarma = indexPath.row;
    [self.tableView reloadData];

}

@end
