//
//  GastosSeleccionarFechasViewController.h
//  MascotAPP
//
//  Created by Samuel on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Reporting.h"

@protocol PickDates;

@interface GastosSeleccionarFechasViewController : UIViewController <UIPickerViewDelegate, UIActionSheetDelegate>

{
    UIDatePicker *datePicker1; 
    UIDatePicker *datePicker2; 
    UIActionSheet *pickerViewPopup1;    
    UIActionSheet *pickerViewPopup2;
    
    NSDate *date1;
    NSDate *date2;
    

}
@property (weak, nonatomic) IBOutlet UILabel *fecha1lbl;
@property (weak, nonatomic) IBOutlet UILabel *fecha2lbl;
@property (strong) NSDate *date1;
@property (strong) NSDate *date2;

@property (nonatomic, weak) id <PickDates> delegado;


@end


@protocol PickDates

- (void)dates:(GastosSeleccionarFechasViewController *)controller date1:(NSDate *)date1 date2:(NSDate *)date2 actualizar:(BOOL)actualizar;

@end

