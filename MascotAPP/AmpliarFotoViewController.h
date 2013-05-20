//
//  AmpliarFotoViewController.h
//  MascotAPP
//
//  Created by Samuel on 29/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mascota.h"

@interface AmpliarFotoViewController : UIViewController {
    UIImage *imagen;
    Mascota *mascota;
}

@property(nonatomic, retain) UIImageView *fotoAmpliada;
@property(nonatomic, retain) Mascota *mascota;

@end
