//
//  CeldaGastos.h
//  MascotAPP
//
//  Created by Samuel on 27/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CeldaGastos : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPrecio;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoria;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgMascota;
@property (weak, nonatomic) IBOutlet UILabel *lblfecha;

@end
