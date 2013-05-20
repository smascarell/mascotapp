//
//  ContactosTableViewController.m
//  MascotAPP
//
//  Created by Samuel on 02/10/12.
//
//

#import "ContactosTableViewController.h"

@interface ContactosTableViewController ()

@end

@implementation ContactosTableViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing)
    {
        // We are changing to edit mode
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];
        self.navigationItem.leftBarButtonItem = doneButton;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.title = @"MascoAgenda";
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        // We are changing out of edit mode
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
        self.navigationItem.leftBarButtonItem = addButton;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleDeleting)];
        self.navigationItem.rightBarButtonItem = deleteButton;
    }

}

-(void)toggleEditing
{
    EDICION = !EDICION;
    [self setEditing:!self.isEditing animated:YES];
}

-(void)toggleDeleting
{
    
    [self setEditing:!self.isEditing animated:YES];
    EDICION = !EDICION;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (EDICION) {
        if(indexPath.section == 0)
        {
            if (self.isEditing) {
                return  UITableViewCellEditingStyleInsert;
            } else
                return  UITableViewCellEditingStyleNone;
        }
        else
        {
            if (self.isEditing) {
                return  UITableViewCellEditingStyleInsert;
            } else
                return  UITableViewCellEditingStyleDelete;
        }

    } else {
        return  UITableViewCellEditingStyleDelete;
        if(indexPath.section == 0)
        {
           return  UITableViewCellEditingStyleNone;
        }
        else
        {
            return  UITableViewCellEditingStyleDelete;
        }

    }
}

-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    [[self navigationController] dismissModalViewControllerAnimated:YES];
    return YES;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {

    idPersona = ABRecordGetRecordID(person);
    
    [self updateData:idPersona];
    [self dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
    
    return NO;
}


- (void)seleccionarContacto{
    
    ABPeoplePickerNavigationController *agendaContactos = [ABPeoplePickerNavigationController new];
    agendaContactos.peoplePickerDelegate = self;
    
    [self presentModalViewController:agendaContactos animated:YES];
}

-(void) updateData:(int)valor {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (currentIndexPath.section == 0) {
              
        switch (currentIndexPath.row) {
            case 0:
                [prefs setInteger:valor forKey:@"veterinarioKey"];
                break;
            case 1:
                [prefs setInteger:valor forKey:@"tiendaKey"];
                break;
            case 2:
                [prefs setInteger:valor forKey:@"residenciaKey"];
                break;
            case 3:
                [prefs setInteger:valor forKey:@"peluqueriaKey"];
                break;
            default:
                break;
        }
    } else {
        if (currentIndexPath.row == 0)
            [prefs setInteger:valor forKey:@"contacto1Key"];
        else [prefs setInteger:valor forKey:@"contacto2Key"];
    }
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
      
    EDICION = FALSE;
        
    agenda = ABAddressBookCreate();
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    self.navigationItem.leftBarButtonItem = addButton;
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleDeleting)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    self.navigationItem.title = @"MascoAgenda";
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg01"]];
    [self.tableView setBackgroundView:image];

}

- (void)viewDidUnload
{
    CFRelease(agenda);
    CFRelease(contactos);
    CFRelease(persona);
    CFRelease(telefonos);

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 //Return the number of rows in the section.
    if (section == 0) {
         return 4;
    } else{
        //return agendaPlist.count - 3;
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger personaID;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                personaID = [prefs integerForKey:@"veterinarioKey"];
                break;
            case 1:
                personaID = [prefs integerForKey:@"tiendaKey"];
                break;
            case 2:
                personaID = [prefs integerForKey:@"residenciaKey"];
                break;
            case 3:
                personaID = [prefs integerForKey:@"peluqueriaKey"];
                break;
            default:
                break;
        }
       
        persona = ABAddressBookGetPersonWithRecordID(agenda, personaID);
        
        NSString *nombre = (__bridge NSString *)(ABRecordCopyValue(persona, kABPersonFirstNameProperty));
        NSString *apellidos = (__bridge NSString *)(ABRecordCopyValue(persona, kABPersonLastNameProperty));
        
        if (apellidos == nil) {
            apellidos = @"";
        }
        if (nombre == nil) {
            nombre = @"No asignado";
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",nombre,apellidos];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Veterinario";
                cell.imageView.image = [UIImage imageNamed:@"veterinario-icon"];
                break;
            case 1:
                cell.textLabel.text = @"Tienda";
                cell.imageView.image = [UIImage imageNamed:@"tienda-icon"];
                break;
            case 2:
                cell.textLabel.text = @"Residencia";
                cell.imageView.image = [UIImage imageNamed:@"residencia-icon"];
                break;
            case 3:
                cell.textLabel.text = @"Peluquería";
                cell.imageView.image = [UIImage imageNamed:@"peluqueria-icon"];
                break;
            default:
                break;
        }
    }
    
    /* Section 1 - custom phones */
    else {
        
        switch (indexPath.row) {
            case 0:
                personaID = [prefs integerForKey:@"contacto1Key"];
                break;
            case 1:
                personaID = [prefs integerForKey:@"contacto2Key"];
                break;
            default:
                break;
        }

            persona = ABAddressBookGetPersonWithRecordID(agenda, personaID);
            
            NSString *nombre = (__bridge NSString *)(ABRecordCopyValue(persona, kABPersonFirstNameProperty));
            NSString *apellidos = (__bridge NSString *)(ABRecordCopyValue(persona, kABPersonLastNameProperty));
        
            cell.textLabel.text =[NSString stringWithFormat:@"Contacto %d",indexPath.row+1];
            cell.imageView.image = [UIImage imageNamed:@"person-icon"];
        
            if (apellidos == nil) {
                apellidos = @"";
            }
            if (nombre == nil) {
                nombre = @"No asignado";
            }
            cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"%@ %@",nombre,apellidos];

    }
     return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Contactos";
    } else
        return @"Contactos personalizados";
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndexPath = indexPath;
    NSString *key;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    key = @"veterinarioKey";
                    break;
                case 1:
                    key = @"tiendaKey";
                    break;
                case 2:
                    key = @"residenciaKey";
                    break;
                case 3:
                    key = @"peluqueriaKey";
                    break;
                default:
                    break;
            }
        } else {
            if (indexPath.row == 0) key = @"contacto1Key";
                else key = @"contacto2Key";
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
    } else
        [self seleccionarContacto];
    
    [tableView reloadData];

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger personaID;
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                personaID = [prefs integerForKey:@"veterinarioKey"];
                break;
            case 1:
                personaID = [prefs integerForKey:@"tiendaKey"];
                break;
            case 2:
                personaID = [prefs integerForKey:@"residenciaKey"];
                break;
            case 3:
                personaID = [prefs integerForKey:@"peluqueriaKey"];
                break;
            default:
                break;
        }
    } else {
        if (indexPath.row == 0)
            personaID = [prefs integerForKey:@"contacto1Key"];
        else personaID = [prefs integerForKey:@"contacto2Key"];
    }
        persona = ABAddressBookGetPersonWithRecordID(agenda, personaID);
        
        if (persona !=nil) {
            //ABPersonViewController *contacto = [ABPersonViewController new];
            ABRecordRef person = (ABRecordRef)persona;
            ABPersonViewController *picker = [[ABPersonViewController alloc] init];
            picker.personViewDelegate = self;
            picker.displayedPerson = person;
            // Allow users to edit the person’s information
            picker.allowsEditing = YES;
            picker.allowsActions = YES;
            [self.navigationController pushViewController:picker animated:YES];
        }
 
}
@end
