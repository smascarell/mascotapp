//
//  CeldaListaMascotas.h
//  mascotapp
//
//  Created by Samuel Mascarell on 14/11/12.
//
//

#import <UIKit/UIKit.h>

@interface CeldaListaMascotas : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagenMascota;
@property (weak, nonatomic) IBOutlet UILabel *nombreMascota;

@end
