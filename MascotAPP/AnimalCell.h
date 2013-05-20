//
//  AnimalCell.h
//  MascotAPP
//
//  Created by Samuel Mascarell on 06/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"

@interface AnimalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * lblNombre;
@property (weak, nonatomic) IBOutlet UIImageView * imgFoto;

@property (nonatomic, retain) Animal *animal;

@end
