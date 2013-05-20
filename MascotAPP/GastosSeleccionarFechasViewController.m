//
//  GastosSeleccionarFechasViewController.m
//  MascotAPP
//
//  Created by Samuel on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GastosSeleccionarFechasViewController.h"

@implementation GastosSeleccionarFechasViewController
@synthesize fecha1lbl;
@synthesize fecha2lbl;
@synthesize date1 = _date1;
@synthesize date2 = _date2;
@synthesize delegado = _delegado;


- (IBAction)guardar {
    if (self.date1 && self.date2 ) {
        [self.delegado dates:self date1:self.date1 date2:self.date2 actualizar:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selecciona las fechas"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)cancelar:(id)sender {
  
    [self.delegado dates:self date1:nil date2:nil actualizar:NO];
}

- (IBAction)currentYear:(id)sender {
    
    self.date1 = [NSDate firstDayOfCurrentYear];
    self.date2 = [NSDate date];
    
    [self guardar];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateStyle = NSDateFormatterMediumStyle;
//    
//    self.fecha1lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date1]];
//    self.fecha2lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date2]];
   
}

- (IBAction)year:(id)sender {
    
    self.date2 = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    /*
     Create a date components to represent the number of years to add to the current date.
     In this case, we add -1 to subtract one year.
     
     */
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = - 1;
    
    self.date1 = [calendar dateByAddingComponents:addComponents toDate:self.date2 options:0];
    [self guardar];
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateStyle = NSDateFormatterMediumStyle;
//    
//    self.fecha1lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date1]];
//    self.fecha2lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date2]];

}

- (IBAction)lastYear:(id)sender {
    
    self.date1 = [NSDate firstDayOfPreviousYear];
    self.date2 = [NSDate firstDayOfCurrentYear];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:-1];
    
    NSDate *lastday = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:self.date2 options:0];
    self.date2 = lastday;
    
    [self guardar];

//
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateStyle = NSDateFormatterMediumStyle;
//    
//    self.fecha1lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date1]];
//    self.fecha2lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.date2]];
    
}

- (IBAction)allDates:(id)sender {
    self.date1 = self.date2 = nil;
    [self.delegado dates:self date1:self.date1 date2:self.date2 actualizar:YES];}


- (IBAction)seleccionarFecha1:(id)sender {
    pickerViewPopup1 = [[UIActionSheet alloc] initWithTitle:@"Fecha Inicio" 
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"OK",nil]; 
    
    pickerViewPopup1.tag = 1;

    
    //seleccionar fecha    
    datePicker1 = [[UIDatePicker alloc] init];
    datePicker1.datePickerMode = UIDatePickerModeDate;
    [pickerViewPopup1 addSubview:datePicker1];
    [pickerViewPopup1 showInView:self.view];        
    
    CGRect menuRect = pickerViewPopup1.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    pickerViewPopup1.frame = menuRect;
    
    
    CGRect pickerRect = datePicker1.frame;
    pickerRect.origin.y = orgHeight;
    datePicker1.frame = pickerRect;

    
}

- (IBAction)seleccionarFecha2:(id)sender {
    pickerViewPopup2 = [[UIActionSheet alloc] initWithTitle:@"Fecha Fin" 
                                                  delegate:self
                                         cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];  
    
    pickerViewPopup2.tag = 2;

    
    //seleccionar fecha    
    datePicker2 = [[UIDatePicker alloc] init];
    datePicker2.datePickerMode = UIDatePickerModeDate;
    [pickerViewPopup2 addSubview:datePicker2];
    [pickerViewPopup2 showInView:self.view];        
    
    CGRect menuRect = pickerViewPopup2.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    pickerViewPopup2.frame = menuRect;
    
    
    CGRect pickerRect = datePicker2.frame;
    pickerRect.origin.y = orgHeight;
    datePicker2.frame = pickerRect;

    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            self.fecha1lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker1.date]];
            self.date1 = datePicker1.date;
        }

    }else if(actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            self.fecha2lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker2.date]];
            self.date2 = datePicker2.date;
        }
    }
        
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setFecha1lbl:nil];
    [self setFecha2lbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
