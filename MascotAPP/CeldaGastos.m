//
//  CeldaGastos.m
//  MascotAPP
//
//  Created by Samuel on 27/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CeldaGastos.h"

@implementation CeldaGastos
@synthesize lblCategoria, lblDesc,lblfecha,lblPrecio, imgMascota;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
