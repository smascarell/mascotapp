//
//  GastosGeneral.h
//  MascotAPP
//
//  Created by Samuel on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gastos.h"
#import "CrearGastoTableViewController.h"
#import "GastosNombre.h"
#import "CeldaGastos.h"
#import "GastosSeleccionarFechasViewController.h"
#import "GastosGraficoViewController.h"


@interface GastosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CreaGastoDelegado, PickDates, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate>

{
    BOOL pormascota;
    NSDate *sortDate1;
    NSDate *sortDate2;
    UIActionSheet *pickerYearViewPopup;
    UIActionSheet *popupQuery;
    UIPickerView *yearPickerView;
    NSMutableArray *years;
    
    UIView *popView;
}

@property (strong, nonatomic) Gastos *gasto;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *gastolbl;
@property (weak, nonatomic) IBOutlet UIButton *btnVerGrafico;
@property (weak, nonatomic) IBOutlet UIButton *fechaBoton;


@property (nonatomic) BOOL graficoPorMes;

- (void) actualizarTotal;

- (void) seleccionarAAnterior:(UIActionSheet *)actionSheet;
- (void) cancelYearSelector;

@end