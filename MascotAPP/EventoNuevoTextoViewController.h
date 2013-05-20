//
//  EventoNuevoTextoViewController.h
//  MascotAPP
//
//  Created by Samuel on 13/08/12.
//
//

#import <UIKit/UIKit.h>

@protocol EventoNuevoTexto;

@interface EventoNuevoTextoViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <EventoNuevoTexto> delegado;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UITextField *texto;

@end

@protocol EventoNuevoTexto

- (void) ActualizarTextoEvento:(EventoNuevoTextoViewController *)controller texto:(NSString *) texto indexPath:(NSIndexPath *)indexPath;

@end