//
//  CeldaPersonalizada.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"

@interface CeldaPersonalizada : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblNombre;
@property (weak, nonatomic) IBOutlet UILabel *lblAnimal;
@property (weak, nonatomic) IBOutlet UIImageView *imgFoto;
@property (weak, nonatomic) IBOutlet UILabel *lblEdad;
@property (weak, nonatomic) IBOutlet UILabel *lblMeses;
@property (weak, nonatomic) IBOutlet UILabel *nGastos;
@property (weak, nonatomic) IBOutlet UILabel *lblGastosTotal;
@property (weak, nonatomic) IBOutlet UILabel *nTareas;
@property (weak, nonatomic) IBOutlet UIImageView *indicadorTareasPendientes;
@property (weak, nonatomic) IBOutlet UILabel *tareaPendienteLbl;

//@property (nonatomic, retain) Mascota *mascota;

@end

