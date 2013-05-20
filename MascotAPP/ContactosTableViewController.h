//
//  ContactosTableViewController.h
//  MascotAPP
//
//  Created by Samuel on 02/10/12.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactosTableViewController : UITableViewController <ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate> {
    
    int ncontacto;
    ABAddressBookRef agenda;
    CFArrayRef contactos;
    ABRecordRef persona;
    ABMultiValueRef telefonos;
    ABRecordID idPersona;
    
    NSMutableDictionary *agendaPlist;
    NSMutableArray *listacontactos;
    
    NSString *veterinarioTelefono;
    NSString *peluqueriaTelefono;
    NSString *residenciaTelefono;
    
    NSIndexPath *currentIndexPath;
    BOOL EDICION;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editarBoton;

-(void) updateData:(int)valor;

@end