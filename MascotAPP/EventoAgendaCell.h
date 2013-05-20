//
//  EventoAgendaCell.h
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import <UIKit/UIKit.h>

@protocol CeldaEventoDelegado;

@interface EventoAgendaCell : UITableViewCell {
    BOOL useDarkBackground;
}

@property BOOL useDarkBackground;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *fecha;
@property (weak, nonatomic) IBOutlet UIButton *hecho;
@property (weak, nonatomic) IBOutlet UIImageView *imgHecho;
@property (weak, nonatomic) IBOutlet UIImageView *imgMascota;
@property (weak, nonatomic) IBOutlet UILabel *nombreMascota;

@property(nonatomic,weak) id <CeldaEventoDelegado> delegado;

@end

@protocol CeldaEventoDelegado

- (void) cambiarEstadoEvento:(UITableViewCell *)cell;

@end
